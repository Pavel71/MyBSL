//
//  ProductListViewModel.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 16/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


protocol ProductListViewModelable {
  
  var mealId: String {get set}
  var productsData:[MealViewModel.ProductCell] {get set}
}


struct ProductListViewModel: ProductListViewModelable {
  
  var mealId: String
  
  var productsData: [MealViewModel.ProductCell]
  
}
