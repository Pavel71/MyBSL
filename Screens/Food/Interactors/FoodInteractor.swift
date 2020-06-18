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
  
  
  var addService     : AddService!
  var deleteService  : DeleteService!
  var updateService  : UpdateService!
  var listnerService : ListnerService!
  
  var convertWorker : ConvertorWorker!
  
  // Realm Objects

//  var items: Results<ProductRealm>!
  
  
  
  var isDefaultList: Bool = true
  
  var currentSegment: Segment = .allProducts
  
  var items: Results<ProductRealm>!
  
  // MARK: Init
  
  init() {
    let locator = ServiceLocator.shared
    realmManager   = locator.getService()
    addService     = locator.getService()
    deleteService  = locator.getService()
    updateService  = locator.getService()
    listnerService = locator.getService()
    
    convertWorker  = locator.getService()
  }
  
  
  func makeRequest(request: Food.Model.Request.RequestType) {
    
    workWithTableViewViewModel(request: request)
    workWithNewFoodViewViewModel(request: request)
    addAndDismissProductFSListner(request:request)
    
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
  
  // MARK: FireStore Lisner
  
  private func addAndDismissProductFSListner(request:Food.Model.Request.RequestType) {
    
    switch request {
    case .setProductsFireStoreLisner:
      print("Start Set Product FireStore Lisner")

      setProductFireStoreListner()
      
      
    case .dissmisProductsFireStoreListner:
      print("Dissmis Product FireStore Lisner")
      listnerService.dismissProductListner()
      
    default:break
    }
  }
  
  private func setProductFireStoreListner() {
    
    guard listnerService.productListner == nil else {return}
    
    // Нужно отправить сигнал о том что подгружаем данные
    presenter?.presentData(response: .showLoadingMessage(message: "Идет Загрузка данных..."))
    
    listnerService.setProductLisner { result in
        
        switch result {
        case .success((let models,let type)):
          
          let productsRealm = self.convertProductsNetworkToRealm(productsNetwork: models)
          
          switch type {
          case .added,.modifided:
            print("Добавить в реалм или Обновим старые Products")
            self.realmManager.setProductsToRealm(products: productsRealm)
          case .removed:
            print("Удалить в реалме")
            self.realmManager.deleteProducts(products: productsRealm)
          }
          self.didChangeProductDB()
          self.presenter?.presentData(response: .reloadTableView)
          
        case .failure(let error):
          print("error",error)
        }
      self.didChangeProductDB()
      self.presenter?.presentData(response: .showOffLoadingMessage)
      
        
      }
  }
  
  private func convertProductsNetworkToRealm(productsNetwork: [ProductNetworkModel]) -> [ProductRealm] {
    
    var productsRealm = productsNetwork.map(self.convertWorker.convertProductNEtwrokModelToProductRealm(productNetworkModel:))
    
    
    return productsRealm
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
        
      let realmProduct = convertWorker.convertFoodCellVMtoProductRealm(viewModel: viewModel)
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
        presenter?.presentData(response: .reloadTableView)
      
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




// MARK: Work With FireBase

extension FoodInteractor {
  
 private func addProductToFireBase(productRealm:ProductRealm) {
    
  let productToFireBase = convertWorker.convertProductsRealmToProductNetworkModel(product: productRealm)
  
    addService.addProductToFireBase(product: productToFireBase)
  
  // Вот здесь нужно убедится что листнер сейчас есть! если нет то добавить его
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
