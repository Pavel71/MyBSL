//
//  MealProductViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// VC View Model
struct MealProductsVCViewModel {
  // Это должно идти в каждом диннере!
  var cells    : [MealProductViewModel]
  var resultVM : ProductListResultsViewModel
}




// Cell View model
struct MealProductViewModel: MealProductCellable {
  
  var name           : String
  var carboInPortion : Float
  var portion        : Int
  var factInsulin    : Float

}
