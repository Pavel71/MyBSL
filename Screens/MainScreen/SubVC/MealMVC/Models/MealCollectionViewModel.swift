//
//  DinnersViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation




struct MealTypeCompansationObjectVM : MealCollectionCellable,CompansationObjactable  {
  
  var topButtonVM            : TopButtonViewModalable
  var type                   : TypeCompansationObject

  var id                     : String

  var productResultViewModel : ProductListResultsViewModel
  
  var mealProductVCViewModel : MealProductsVCViewModel
  var compansationFase       : CompansationPosition
}


struct TopButtonViewModel : TopButtonViewModalable {
  var type: TypeCompansationObject

}
