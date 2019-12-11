//
//  ResultViewWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


class ResultViewWorker {
  
  
  static func getSumCarbo(products: [MealProductViewModel]) -> Float {
    
    return products.map{$0.carboInPortion}.reduce(0, +)
    
  }
  static func getSumInsulin(products: [MealProductViewModel]) -> Float {
    
    return products.map{$0.factInsulin}.reduce(0, +)
    
  }
  static func getSumPortion(products: [MealProductViewModel]) -> Int {
    
    return products.map{$0.portion}.reduce(0, +)
    
  }
  
}
