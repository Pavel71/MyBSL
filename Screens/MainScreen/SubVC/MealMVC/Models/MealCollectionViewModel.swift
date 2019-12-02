//
//  DinnersViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation






struct MealCollectionVCViewModel {
  
  var cells: [MainScreenMealViewModel]
  
}


struct MainScreenMealViewModel : MealCollectionCellable  {
  
  var mealId                 : String
  var productResultViewModel : ProductListResultsViewModel
  
  var mealProductVCViewModel : MealProductsVCViewModel
  var compansationFase       : CompansationPosition
}
