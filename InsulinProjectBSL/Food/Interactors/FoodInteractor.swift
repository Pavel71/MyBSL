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

  var items: Results<ProductRealm>!
  
  var service: FoodService?
  
  var isDefaultList: Bool = true
  
  var tableView: UITableView!
  
  func makeRequest(request: Food.Model.Request.RequestType) {
    
    if realmManager == nil {
      print("Set RealmManager")
      realmManager = FoodRealmManager()
      // set clouser Update
      realmManager.didChangeRealmDB = didChangeProductDB
    }
    
    switch request {
      // MARK: Realm
      
    case .fetchAllProducts:

      items = realmManager.allProducts()
      presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
    case .fetchProductByFavorits:
      items = realmManager.fetchFavorits()
      presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))
      
    case .setRealmObserverToken:
      
      let realmObserverToken = realmManager.setObserverToken(items: items)
      presenter?.presentData(response: .passRealmObserver(productRealmObserver: realmObserverToken))
      
    case .filterProductByName(let name):
      items = items.filter("name CONTAINS[cd] %@", name)
      // Здесь нужен items  который последний это могут быть как фавориты так и все продукты
      presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: items, bySections: isDefaultList))

    case .deleteProduct(let productId):
      guard let product = realmManager.getProductById(id: productId) else {return}
      realmManager.deleteProduct(product: product)  // didChangeProductDB
     
    case .updateFavoritsField(let productId):
      guard let product = realmManager.getProductById(id: productId) else {return}
      realmManager.updateProductFavoritField(product: product)  // didChangeProductDB
      
    // MARK: Realm Add or Update
    case .addNewProductInRealm(let viewModel):
      
      let newProduct = createNewProduct(viewModel: viewModel)
      
      realmManager.addNewProduct(newProduct: newProduct) { [weak self] (succes) in
        self?.presenter?.presentData(response: .succesAddNewProduct(succes: succes)) // didChangeProductDB
      }
      
    case .updateCurrentProductInRealm(let viewModel):

      realmManager.updateAllFields(viewModel: viewModel)
      // Пока здесь нет ошибки!
      presenter?.presentData(response: .succesAddNewProduct(succes: true)) // didChangeProductDB
      
      
    // MARK: New PrdouctViewModel
    case .showNewProductView(let productIdString):
      
      // здесь будет правильнне поиск по id
      let allCategoryList = realmManager.getCategoryList()
      let updateProduct = realmManager.getProductById(id: productIdString) // Если есть такой продукт то верни

      presenter?.presentData(response: .prepareDataToFillNewProductViewModel(categorylist: allCategoryList, updateProduct: updateProduct))

    case .showListProductsBySection(let isDefaultList):
      self.isDefaultList = isDefaultList
      presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: self.items, bySections: isDefaultList))
    }
    
  }

  private func didChangeProductDB() {
    self.presenter?.presentData(response: .prepareDataFromRealmToViewModel(items: self.items, bySections: isDefaultList))

  }
  
  private func createNewProduct(viewModel: FoodCellViewModel) -> ProductRealm {
    let name = viewModel.name
    let category = viewModel.category
    let carbo = Int(viewModel.carbo)!
    let isFavorits = viewModel.isFavorit
    let massa = Int(viewModel.portion)!
    
    return ProductRealm.init(name: name, category: category, carbo: carbo, isFavorits: isFavorits, portion:massa)
  }
  
  

  
}
