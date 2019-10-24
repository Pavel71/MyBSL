//
//  ProductListWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


class ProductListWorker {
  
  // Add Product
  static func addProducts(products: [ProductRealm], newDinnerProducts: [ProductListViewModel]) -> [ProductListViewModel] {
    
    var dummyData: [ProductListViewModel] = newDinnerProducts
    
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
    let productListViewModel = ProductListViewModel(insulinValue: product.insulin, isFavorit: product.isFavorits, carboIn100Grm: product.carbo, category: product.category, name: product.name, portion: product.portion)
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
