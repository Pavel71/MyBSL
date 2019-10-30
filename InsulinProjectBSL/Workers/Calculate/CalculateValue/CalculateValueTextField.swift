//
//  CalculateValueTextField.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class CalculateValueTextField {
  

  static func calculateSumInsulin(insulin: Float,indexPath: IndexPath, tableViewData: inout [ProductListViewModel]) -> Float {
    
    tableViewData[indexPath.row].insulinValue = insulin
    let arrayInsulin = tableViewData.map { (product) -> Float  in
      return product.insulinValue ?? 0

    }
    let sum = arrayInsulin.reduce(0, +)
    return sum
  }
  
  
  static func calculateSumCarbo(indexPath: IndexPath, tableViewData: inout [ProductListViewModel]) -> Int {

    let arrayCarbo = tableViewData.map { (product) -> Int  in
      return product.carboInPortion
    }
    
    let sum = arrayCarbo.reduce(0,+)
    return sum
  }
  
  static func calculateSumPortion(portion: Int,indexPath: IndexPath, tableViewData: inout [ProductListViewModel]) -> Int {
    
    tableViewData[indexPath.row].portion = portion
    let arrayPortion = tableViewData.map { (product) -> Int  in
      return product.portion
    }
    let sumPortion = arrayPortion.reduce(0,+)
    return sumPortion
  }
  
}

