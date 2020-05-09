//
//  FoodInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift




// здесь происходят все изменение на items
// дальше они передаются презентеру и он уже отображает данные


protocol FoodBusinessLogic {
  func makeRequest(request: Food.Model.Request.RequestType)
}

class FoodInteractor: FoodBusinessLogic {

  var presenter: FoodPresentationLogic?
  
  
  var realmManager  : FoodRealmManager!
  var addService    : AddService!
  var deleteService : DeleteService!
  var updateService : UpdateService!
  
  // Realm Objects

//  var items: Results<ProductRealm>!
  
  
  
  var isDefaultList: Bool = true
  
  var currentSegment: Segment = .allProducts
  
  var items: Results<ProductRealm>!
  
  
  init() {
    let locator = ServiceLocator.shared
    realmManager  = locator.getService()
    addService    = locator.getService()
    deleteService = locator.getService()
    updateService = locator.getService()
  }
  
  
  func makeRequest(request: Food.Model.Request.RequestType) {
    
    workWithTableViewViewModel(request: request)
    workWithNewFoodViewViewModel(request: request)

    
  }
  
  private func workWithTableViewViewModel(request: Food.Model.Request.RequestType) {

    fetchDataFromDB(request: request)
    changeDB(request: request)
    
    switch request {

      
      // Section Button Push
      case .showListProductsBySection(let isDefaultList):
        
        self.isDefaultList = isDefaultList
        let items = realmManager.getItems()
        presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
    default:break
    }
    
  }
  // MARK: Realm Change DB
  private func changeDB(request:Food.Model.Request.RequestType) {
    
    switch  request {
      
    case .deleteProduct(let productId):
      
      guard let product = realmManager.getProductById(id: productId) else {return}
      realmManager.deleteProduct(product: product)
      
      deleteProductFromFireBase(productId: productId)
      // можно и не обновлять так как он сделает красивую анимацию
      didChangeProductDB()
      
    case .updateFavoritsField(let productId):
      
      guard let product = realmManager.getProductById(id: productId) else {return}
      realmManager.updateProductFavoritField(product: product)
      
      let updateData = [ProductNetworkModel.CodingKeys.isFavorits.rawValue: product.isFavorits]
      
      updateProductInFireBase(productId: productId, updateData: updateData)
      didChangeProductDB()
      
    case .addNewProductInRealm(let viewModel):
        
        let realmProduct = createNewRealmProduct(viewModel: viewModel)
        realmManager.addNewProduct(product: realmProduct)
        
        addProductToFireBase(productRealm: realmProduct)
        
        didChangeProductDB()

      
    case .updateCurrentProductInRealm(let viewModel):
      guard let id = viewModel.id else {return}
      
      guard let dataDict:[String: Any] = getDataDict(viewModel: viewModel) else {return}
      
      realmManager.updateAllFields(dataDict: dataDict, productId: id)
      
      updateProductInFireBase(productId: id, updateData: dataDict)
      didChangeProductDB()

      
    default: break
    }
    
  }
  
  private func fetchDataFromDB(request:Food.Model.Request.RequestType) {
    
    switch request {
      
      // Segment
      case .fetchAllProducts:
        
        currentSegment = .allProducts
        
        let items = realmManager.allProducts()
        presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
        // Segment
      case .fetchProductByFavorits:
        
        currentSegment = .favorits
        
        let items = realmManager.fetchFavorits()
        presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
        // Search Bar
      case .filterProductByName(let name):
        let items = realmManager.fetchProductByName(name: name)
        // Здесь нужен items  который последний это могут быть как фавориты так и все продукты
        presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
    default:break
    }
  }
  
  // MARK: Work With New Food View
  private func workWithNewFoodViewViewModel(request:Food.Model.Request.RequestType) {
    
    switch request {
      
      case .showNewProductView(let productIdString):
        
        // здесь будет правильнне поиск по id
        let allCategoryList = realmManager.getCategoryList()
        let updateProduct = realmManager.getProductById(id: productIdString) // Если есть такой продукт то верни
        
        presenter?.presentData(response: .prepareDataToFillNewProductViewModel(categorylist: allCategoryList, updateProduct: updateProduct))
      
    default:break
    }
    
  }
  
  
  // MARK: Update View
  
  private func didChangeProductDB() {
    
    // Суть в чем после измененей получи свежые данные в своем сегменте
    switch currentSegment {
    case .allProducts:
      items = realmManager.allProducts()
    case .favorits:
      items = realmManager.fetchFavorits()
    default:break
    }
    
    self.presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))

  }
  

  

  
}


// MARK: Prepare Data To Add


extension FoodInteractor {
  
  private func createNewRealmProduct(viewModel: FoodCellViewModel) -> ProductRealm {
     
     let name       = viewModel.name
     let category   = viewModel.category
     let carbo      = Int(viewModel.carbo)!
     let isFavorits = viewModel.isFavorit
     let massa      = Int(viewModel.portion)!
     
     return ProductRealm.init(
       name            : name,
       category        : category,
       carboIn100Grm   : carbo,
       isFavorits      : isFavorits,
       portion         : massa
     )
   }
  
  private func createNewFireBaseProduct(productRealm: ProductRealm) -> ProductNetworkModel {
    
    
    
    return ProductNetworkModel(
      id                     : productRealm.id,
      name                   : productRealm.name,
      category               : productRealm.category,
      carboIn100grm          : productRealm.carboIn100grm,
      portion                : productRealm.portion,
      percantageCarboInMeal  : productRealm.percantageCarboInMeal,
      userSetInsulinOnCarbo  : productRealm.userSetInsulinOnCarbo,
      insulinOnCarboToML     : productRealm.insulinOnCarboToML,
      isFavorits             : productRealm.isFavorits)
  }
  
}


// MARK: Work With FireBase

extension FoodInteractor {
  
 private func addProductToFireBase(productRealm:ProductRealm) {
    
    let productToFireBase = createNewFireBaseProduct(productRealm: productRealm)
    addService.addProductToFireBase(product: productToFireBase)
  }
  
  private func deleteProductFromFireBase(productId: String) {
    
    deleteService.deleteProducts(productId: productId)
  }
  
  private func updateProductInFireBase(productId: String,updateData:[String:Any]) {
    
    updateService.updateProductRealm(productId: productId, data: updateData)
  }
  
  private func getDataDict(viewModel: FoodCellViewModel) -> [String: Any]? {
    
    guard
      let carbo   = Int(viewModel.carbo),
      let portion = Int(viewModel.portion)
      else {return nil}
      
    
    return [
      ProductNetworkModel.CodingKeys.name.rawValue          : viewModel.name,
      ProductNetworkModel.CodingKeys.carboIn100grm.rawValue : carbo,
      ProductNetworkModel.CodingKeys.category.rawValue      : viewModel.category,
      ProductNetworkModel.CodingKeys.isFavorits.rawValue    : viewModel.isFavorit,
      ProductNetworkModel.CodingKeys.portion.rawValue       : portion
    ]
    
  }
  
}
