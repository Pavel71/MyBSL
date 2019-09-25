//
//  NewMealViewWorker.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 12/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// класс отвечает за подготовку данных для newViewModel!

class NewMealViewPresenterWorker {
  
  
  static func getNewMealViewModel(updateMeal: MealRealm?, listtypeOfMeal: [String]) -> NewMealViewModel {
    
    var newMealViewModel: NewMealViewModel
    if updateMeal == nil {
      
      newMealViewModel = NewMealViewModel.init(listTypeOfMeal: listtypeOfMeal, mealId: nil, name: nil, typeOfMeal: nil)
      
    } else {
      
      newMealViewModel = NewMealViewModel.init(listTypeOfMeal: listtypeOfMeal, mealId: updateMeal?.id, name: updateMeal?.name, typeOfMeal: updateMeal?.typeMeal)

    }
    
    return newMealViewModel
  }
  
}
