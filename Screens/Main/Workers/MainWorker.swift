//
//  MainWorker.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

class MainService {

}


// Так как нам нету смысла опускать до презентреа можно все обновить для юзера на View Controllerr то это будет делать этот воркер!

class MainWorker {
  
  
  
  
}

// MARK: Work With Update UI ViewController

extension MainWorker {
  
  
  // Add Product
  static func addProducts(products: [ProductRealm], newDinnerProducts: [ProductListViewModel]) -> [ProductListViewModel] {

    var dummyData: [ProductListViewModel] = []

    products.forEach { (product) in
      
      if !checkProductByName(name: product.name, newDinnerProducts: newDinnerProducts) {
        let productListViewModel = getProductListViewModel(product: product)
        dummyData.insert(productListViewModel,at:0)
      }
      
    }
    return dummyData
    
  }
  // Get Product List View Model
  static private func getProductListViewModel(product:ProductRealm) -> ProductListViewModel {
    let productListViewModel = ProductListViewModel(insulinValue: product.insulin, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
    return productListViewModel
  }
  
  static private func checkProductByName(name: String,newDinnerProducts:[ProductListViewModel]) -> Bool {
    
    return newDinnerProducts.contains{ $0.name == name }
    
  }
  
  static func deleteProducts(products: [ProductRealm],newDinnerProducts: [ProductListViewModel]) -> [ProductListViewModel] {
    
    var copyArray = newDinnerProducts
    
    products.forEach { (productCame) in
      copyArray.removeAll{$0.name == productCame.name}
    }
    return copyArray
    
  }
  
  
}
