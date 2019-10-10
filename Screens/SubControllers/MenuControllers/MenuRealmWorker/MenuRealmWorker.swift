//
//  MenuRealmWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 09.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


// Этот класс отвечает за обращение к базе данных и подготовку данных! Так как методов не много но они повторяются я принял решение вывести его в отдельный воркер

import UIKit
import RealmSwift


final class MenuRealmWorker {
  
  var foodRealmManager: FoodRealmManager
  
  init() {
    self.foodRealmManager = FoodRealmManager()
  }
  
  // Fetch All product
  func fetchAllProducts() -> [MenuProductListViewModel] {
    
    let items = foodRealmManager.allProducts()
    return presentViewModel(items: items)
  }
  
  // Fetch Favorits
  func fetchFavorits() ->  [MenuProductListViewModel] {
    let items = foodRealmManager.fetchFavorits()
    return presentViewModel(items: items)
  }
  
  // FetchProduct By ID
  
  func getProductFromRealm(productId: String) -> ProductRealm? {
    
    return foodRealmManager.getProductById(id: productId)
  }

  
}


// MARK: Prepare Data to ViewModel
extension MenuRealmWorker {
  
  private func presentViewModel(items: Results<ProductRealm>) -> [MenuProductListViewModel] {
    
    var dummyArray: [MenuProductListViewModel] = []
    
    for product in items {
      
      let carboString = String(product.carbo)
      let portionString = String(product.portion)
      
      let productCellViewModel = MenuProductListViewModel(id: product.id, name: product.name, carboOn100Grm: carboString, isFavorit: product.isFavorits, portion: portionString, category: product.category)
      
      dummyArray.append(productCellViewModel)
    }
    
    return dummyArray
  }
}
