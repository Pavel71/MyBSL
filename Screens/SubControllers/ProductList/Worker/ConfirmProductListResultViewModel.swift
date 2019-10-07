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
    print("Расчет")
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
//      print(productViewModel.insulinValue)
//
//      if let insulin = productViewModel.insulinValue {
//        print(insulin)
//        let insulinFloat = (insulin as NSString).floatValue
//        return insulinFloat
//      }
//      return 0
    }
    
    let sumInsulin = arrayInsulin.reduce(0,+)
    
    print(sumCarbo,sumPortion,sumInsulin)
    
    return ProductListResultsViewModel(sumCarboValue: String(sumCarbo), sumPortionValue: String(sumPortion), sumInsulinValue: String(sumInsulin))
  }
  

  
  
}
