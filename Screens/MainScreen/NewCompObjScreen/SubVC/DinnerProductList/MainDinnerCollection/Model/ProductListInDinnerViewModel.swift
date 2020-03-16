//
//  ProductListInDinnerViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

//protocol ProductListInDinnerViewModelCell {
//  
//  var nameProduct: String {get}
//  var portionValue: String {get}
//  var carboInPortionLabel: String {get}
//  var insulinValue: String {get}
//  
//}

struct ProductListInDinnerViewModel: ProductListViewModalable {
  
  var resultsViewModel: ProductListResultsViewModel
  var productsData: [ProductListViewModel]
//  var isPreviosDinner: Bool
//  var isNeedCorrectInsulinIfActualInsulinWrong: Bool
  
  init(
    resultsViewModel:ProductListResultsViewModel,
    productsData:[ProductListViewModel]
//    isPreviosDinner: Bool,
//    isNeedCorrectInsulin: Bool = false
    
    ) {
    self.resultsViewModel = resultsViewModel
    self.productsData = productsData
//    self.isPreviosDinner = isPreviosDinner
//    self.isNeedCorrectInsulinIfActualInsulinWrong = isNeedCorrectInsulin
  }
  
}

// Я думаю что мне здесь нужна просто своя моделька и все не ебать мозг




