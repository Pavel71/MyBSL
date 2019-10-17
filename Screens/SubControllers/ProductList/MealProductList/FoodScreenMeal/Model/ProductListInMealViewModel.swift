//
//  ProductListViewModel.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 16/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


protocol ProductListInMealViewModelable {
  
  var mealId: String? {get set}
  var productsData:[ProductListViewModel] {get set}
}


struct ProductListInMealViewModel: ProductListInMealViewModelable {
  
  var mealId: String?
  
  var productsData: [ProductListViewModel]
  
}
