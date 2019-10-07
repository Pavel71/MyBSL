//
//  ProductListModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


struct ProductListViewModel: ProductListViewModelCell {
  
  var insulinValue: Float?
  
  var carboIn100Grm: Int
  
  // ProductViewModelCell
  
  var name: String
  var portion: Int
  
  // Computed Property
  var carboInPortion: Int {
    return Int(Float(carboIn100Grm) * Float(portion) / 100)
  }
  
}



struct ProductListResultsViewModel: ProductListResultViewModelable {
  
  var sumCarboValue: String
  
  var sumPortionValue: String
  
  var sumInsulinValue: String
  
  
}
