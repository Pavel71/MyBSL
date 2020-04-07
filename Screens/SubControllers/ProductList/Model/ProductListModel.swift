//
//  ProductListModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


protocol ProductListViewModalable {
  var resultsViewModel: ProductListResultsViewModel {get set}
  var productsData: [ProductListViewModel] {get set}
}


//protocol ProductListInDinnerViewModalable: ProductListViewModalable {
//
//  var isPreviosDinner: Bool {get set}
//  var isNeedCorrectInsulinIfActualInsulinWrong: Bool {get set}
//}


struct ProductListViewModel: ProductListViewModelCell {
  
  
  // CorrectInsulinIfActualIsBad
  var correctInsulinValue: Float?
  
  
  // Actual Insulin
  var insulinValue: Float?
  
//  var goodCompansationInsulin: Float!
  
  var isFavorit: Bool
  var carboIn100Grm: Int
  var category: String
  
  // ProductViewModelCell
  
  var name: String
  var portion: Int
  
  // Computed Property
  var carboInPortion: Int {
    return Int(Float(carboIn100Grm) * (Float(portion) / 100))
  }
  
  var totalCarboInMeal: Double
  
}

// MARK: Equtable Viewmodel by Name

extension ProductListViewModel: Equatable {
  static func == (lhs: ProductListViewModel, rhs: ProductListViewModel) -> Bool {
    return lhs.name == rhs.name
  }
}



struct ProductListResultsViewModel: ProductListResultViewModelable {
  
  var sumCarboValue   : String
  
  var sumPortionValue : String
  
  var sumInsulinValue : String
  
  
  var sumCarboFloat: Float {
    (sumCarboValue as NSString).floatValue
  }
  
  var sumInsulinFloat: Float {
    (sumInsulinValue as NSString).floatValue
  }
  
  
}
