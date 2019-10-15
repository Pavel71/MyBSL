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
    sectionViewModel.meals = items.map(getMealsViewModel)

    return sectionViewModel
  }
  
  private static func getMealsViewModel(meal:MealRealm) -> MealViewModel {
    
    var mealViewModel = MealViewModel.init(isExpand:meal.isExpandMeal, name: meal.name, typeMeal: meal.typeMeal, products: [], mealId: meal.id)

    mealViewModel.products = meal.listProduct.map(getProductListViewModel)
    return mealViewModel
  }
  
  private static func getProductListViewModel(product: ProductRealm) -> ProductListViewModel {
    
    let product = ProductListViewModel.init(insulinValue: nil, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
    
    return product
    
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

