//
//  TableViewWorker.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 12/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Класс отвечает за подготовку моделек для TableView

class MealTableViewPresenterWorker {
  
  static func getMealViewModelListForTableView(items: [MealRealm], isDefaultList: Bool) ->  [SectionMealViewModel] {
    
    // Так для начала нужно распарсить отчюда данные
    
    var sectionViewModel: [SectionMealViewModel]
    
    if isDefaultList {
      // получи просто списком в 1 секции
      let defaultList = getDefaultListViewModel(items: items)
      sectionViewModel = [defaultList]
      
    } else {
      // получи секции деленные по типу обеда
      sectionViewModel = getBySectionListViewModel(items: items)
    }
    
    return sectionViewModel
    
  }
  
  // Default List
  private static func getDefaultListViewModel(items: [MealRealm]) -> SectionMealViewModel {
    
    var sectionViewModel = SectionMealViewModel.init(meals: [])
    
    for mealRealm in items {
      
      var meals = MealViewModel.init(isExpand:mealRealm.isExpandMeal, name: mealRealm.name, typeMeal: mealRealm.typeMeal, products: [], mealId: mealRealm.id)
      
      for product in mealRealm.listProduct {
        
        

        let carboInPortionInt = CalculateValueTextField.calculateCarboInPortion(carboIn100grm: product.carbo, portionSize: product.portion)
    
        let product = ProductListViewModel.init(insulinValue: nil, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
        
        meals.products.append(product)
      }
      
      sectionViewModel.meals.append(meals)
    }
    
    
    return sectionViewModel
  }
  
  // By Section
  private static func  getBySectionListViewModel(items: [MealRealm]) -> [SectionMealViewModel] {
    
    // Сдесь нужно сделать групировку данных по категории
    
    var mealsBySections = [SectionMealViewModel]()
    
    let groupedMeals = Dictionary(grouping: items) { (meal) -> String in
      return meal.typeMeal
    }
    
    let sortedKeys = groupedMeals.keys.sorted()
    
    sortedKeys.forEach { (key) in
      guard let values = groupedMeals[key] else {return}
      
      
      var sectionMealByTypeViewModel = getDefaultListViewModel(items: values)
      
      sectionMealByTypeViewModel.sectionName = key
      mealsBySections.append(sectionMealByTypeViewModel)
    }
    
    return mealsBySections
  }
  
}

