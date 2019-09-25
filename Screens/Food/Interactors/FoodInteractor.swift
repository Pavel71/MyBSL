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
  
  var service: FoodService?
  
  var isDefaultList: Bool = true
  
  var tableView: UITableView!
  
  func makeRequest(request: Food.Model.Request.RequestType) {
    
    if realmManager == nil {
      print("Set RealmManager")
      realmManager = FoodRealmManager()
      // set clouser DB Cnahge
      realmManager.didChangeRealmDB = {[weak self] items in self?.didChangeProductDB(items:items)}
    }
    
    workWithTableViewViewModel(request: request)
    workWithNewFoodViewViewModel(request: request)

    
  }
  
  private func workWithTableViewViewModel(request: Food.Model.Request.RequestType) {

    fetchDataFromDB(request: request)
    changeDB(request: request)
    
    switch request {
      // Realm Observer
      case .setRealmObserverToken:
        
        let realmObserverToken = realmManager.setObserverToken()
        presenter?.presentData(response: .passRealmObserver(productRealmObserver: realmObserverToken))
      
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
      
    case .updateFavoritsField(let productId):
      
      guard let product = realmManager.getProductById(id: productId) else {return}
      realmManager.updateProductFavoritField(product: product)
      
    case .addNewProductInRealm(let viewModel):
      
      realmManager.addNewProduct(viewModel: viewModel) { [weak self] (succes) in
        self?.presenter?.presentData(response: .succesAddNewProduct(succes: succes))
      }
      
    case .updateCurrentProductInRealm(let viewModel):
      
      realmManager.updateAllFields(viewModel: viewModel)
      presenter?.presentData(response: .succesAddNewProduct(succes: true))
      
    default: break
    }
    
  }
  
  private func fetchDataFromDB(request:Food.Model.Request.RequestType) {
    
    switch request {
      
      // Segment
      case .fetchAllProducts:
        
        let items = realmManager.allProducts()
        presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
        // Segment
      case .fetchProductByFavorits:
        
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
  
  
  // Than Change DB
  private func didChangeProductDB(items: Results<ProductRealm>) {
    
    self.presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))

  }
  

  

  
}
