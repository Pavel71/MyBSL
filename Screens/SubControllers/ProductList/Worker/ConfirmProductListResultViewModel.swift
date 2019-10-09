//
//  ConfirmProductListResultViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ConfirmProductListResultViewModel {
  
  
  static func calculateProductListResultViewModel(data: [ProductListViewModel]) -> ProductListResultViewModelable {
    
    // Carbo
    let arrayCarbo = data.map { (productViewModel) -> Int  in
      return productViewModel.carboInPortion
    }
    let sumCarbo = arrayCarbo.reduce(0,+)
    
    // Portion
    let arrayPortion = data.map { (productViewModel) -> Int  in
      return productViewModel.portion
      
    }
    let sumPortion = arrayPortion.reduce(0,+)
    
    // Insulin
    let arrayInsulin = data.map { (productViewModel) -> Float  in
      
      return productViewModel.insulinValue ?? 0
    }
    
    let sumInsulin = arrayInsulin.reduce(0,+)
    
    
    return ProductListResultsViewModel(sumCarboValue: String(sumCarbo), sumPortionValue: String(sumPortion), sumInsulinValue: String(sumInsulin))
  }
  

  
  
}
