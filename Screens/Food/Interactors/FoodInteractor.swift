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
  
  
  var realmManager: FoodRealmManager!
  
  
  // Realm Objects

//  var items: Results<ProductRealm>!
  
  
  
  var isDefaultList: Bool = true
  
  var currentSegment: Segment = .allProducts
  
  var items: Results<ProductRealm>!
  
  
  init() {
    let locator = ServiceLocator.shared
    realmManager = locator.getService()
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
      // можно и не обновлять так как он сделает красивую анимацию
      didChangeProductDB()
      
    case .updateFavoritsField(let productId):
      
      guard let product = realmManager.getProductById(id: productId) else {return}
      realmManager.updateProductFavoritField(product: product)
      didChangeProductDB()
      
    case .addNewProductInRealm(let viewModel):

        realmManager.addNewProduct(viewModel: viewModel)
        
        didChangeProductDB()

      
    case .updateCurrentProductInRealm(let viewModel):
      
      realmManager.updateAllFields(viewModel: viewModel)
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
  
  
  // MARK: Update ViewModel
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
