//
//  NewFoodViewWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



class NewFoodViewPresenterWorker {
  
  static func prepareDataToNewProductView(listCategory: [String], updateProduct: ProductRealm?) -> NewProductViewModel {
    
    
    let newProductViewModel: NewProductViewModel
    
    if let updateProduct = updateProduct {
      
      let carboString = "\(updateProduct.carbo)"
      let massaString = "\(updateProduct.portion)"
      
      newProductViewModel = NewProductViewModel(name: updateProduct.name, carbo: carboString, category: updateProduct.category, massa: massaString, isFavorits: updateProduct.isFavorits, listCategory: listCategory)
    } else {
      // Создаем новый продукт
      newProductViewModel = NewProductViewModel(name: nil, carbo: nil, category: nil, massa: nil, isFavorits: false, listCategory: listCategory)
    }
    
    return newProductViewModel
  }
}
