//
//  FoodModels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

enum Food {
   
  enum Model {
    struct Request {
      enum RequestType {
        
        // Realm Case
        case fetchAllProducts
        case fetchProductByFavorits
        case setRealmObserverToken
        
        // Realm
        case filterProductByName(name: String)
        
        case deleteProduct(productId: String)
        case updateFavoritsField(productId: String)
        
        // Sort products by category
        case showListProductsBySection(isDefaultList: Bool)

        
        // NewproductViewCase
        // Если id передаем то показываем продукт которй выбрали если нет то дефолтная view
        case showNewProductView(productIdString: String?)
        
        case updateCurrentProductInRealm(viewModel: FoodCellViewModel)
        case addNewProductInRealm(viewModel: FoodCellViewModel)
        
        

      }
    }
    struct Response {
      enum ResponseType {
        
        case prepareDataFromRealmToViewModel(items: Results<ProductRealm>, bySections: Bool)
//        case reloadTableView(deletions:[Int]?,insertions:[Int]?,updates: [Int]?)
        
        
        case passRealmObserver(productRealmObserver: NotificationToken)
        case prepareDataToFillNewProductViewModel(categorylist: [String], updateProduct: ProductRealm?)
        case succesAddNewProduct(succes: Bool)
//        case passCurrentItemsToSort(items: Results<ProductRealm>)
    
      }
    }
    
    struct ViewModel {
      enum ViewModelData {
        
        case setViewModel(viewModel: [FoodViewModel])
        case setProductRealmObserver(productRealmObserver: NotificationToken)
        case setDataToNewProductView(viewModel: NewProductViewModel)
        case displayAlertSaveNewProduct(succes: Bool)
        
//        case reloadeTableView(deletions:[Int]?,insertions:[Int]?,updates: [Int]?)

      }
    }
  }
  
}

struct FoodViewModel: HeaderInSectionWorkerProtocol {
  
  var isExpanded: Bool
  
  var sectionCategory: String = "Наименование:"
  let items: [Cell]
  
  init(isExpanded: Bool = false, items: [Cell]) {
    self.isExpanded = isExpanded
    self.items = items
  }
  
  struct Cell: FoodCellViewModel {
    
    var id: String?
    
    // FoodCellViewModel
    var name: String
    var category: String
    var isFavorit: Bool
    var carbo: String
    var portion: String

  }
  
  
  
  
}

struct NewProductViewModel: NewProductViewModelable {
  
  var name: String?
  
  var carbo: String?
  
  var category: String?
  
  var massa: String?
  
  var isFavorits: Bool = false
  
  var listCategory: [String]

}


