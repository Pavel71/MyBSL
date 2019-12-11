//
//  DinnersViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



// ComapsationByCarbo Type Cell

struct ComapsnationByCarboVM : CompansationObjactable,CompansationByCarboCellable {
  
  var topButtonVM: TopButtonViewModalable

  var id: String
  var type: TypeCompansationObject
  
  
}


// CompansationByInsulin Type Cell
struct CompansationByInsulinVM : CompansationByInsuliCellable,CompansationObjactable {
  
  var id: String

  var type: TypeCompansationObject

  var topButtonVM: TopButtonViewModalable
  
}


// Meal Type Cell

struct CompansationMealVM : CompansationByMealCellable,CompansationObjactable  {
  
  var topButtonVM            : TopButtonViewModalable
  var type                   : TypeCompansationObject

  var id                     : String

//  var productResultViewModel : ProductListResultsViewModel
  
  var mealProductVCViewModel : MealProductsVCViewModel
  var compansationFase       : CompansationPosition
}


// Сюда нужно положить еще если будут углеводы и инсулин!
struct TopButtonViewModel : TopButtonViewModalable {
  var type: TypeCompansationObject

}
