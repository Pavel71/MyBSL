//
//  MenuRealmWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 09.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


// Этот класс отвечает за обращение к базе данных и подготовку данных! Так как методов не много но они повторяются я принял решение вывести его в отдельный воркер

import UIKit
import RealmSwift


final class MenuRealmWorker {
  
  private var foodRealmManager: FoodRealmManager
  private var mealRealmManager: MealRealmManager
  
  init() {
    self.foodRealmManager = FoodRealmManager()
    self.mealRealmManager = MealRealmManager()
  }
  
  

  
}

// MARK: Meal Requests
extension MenuRealmWorker {
  
  func fetchAllMeals() -> [MenuModel.MenuMealViewModel] {
    let meals = mealRealmManager.fetchAllMeals()
    
    return presentMealViewModel(items: meals)
  }
  
  func fetchAllProductsInMeal(mealId: String) -> [ProductRealm]? {
    let products = mealRealmManager.fetchAllProductsInMealById(mealId: mealId)
    return products
  }
  
}

// MARK: Product Requests

extension MenuRealmWorker {
  
  // Fetch All product
  func fetchAllProducts() -> [MenuModel.MenuProductListViewModel] {
    
    let items = foodRealmManager.allProducts()
    return presentProductViewModel(items: items)
  }
  
  // Fetch Favorits
  func fetchFavorits() ->  [MenuModel.MenuProductListViewModel] {
    let items = foodRealmManager.fetchFavorits()
    return presentProductViewModel(items: items)
  }
  
  // FetchProduct By ID
  
  func getProductFromRealm(productId: String) -> ProductRealm? {
    
    return foodRealmManager.getProductById(id: productId)
  }
}


// MARK: Prepare Data to ViewModel
extension MenuRealmWorker {
  
  // Вообщем ладно мне нужно создавать здесь свой КлассViewModel и все будет норм!
  // Пока я его напишу руками а там посмотрим
  
  // Get MealViewModel
  
  private func presentMealViewModel(items: Results<MealRealm>) -> [MenuModel.MenuMealViewModel] {
    
    return items.map(getMealsViewModel)

  }
  
  private func getMealsViewModel(meal:MealRealm) -> MenuModel.MenuMealViewModel {
    
    var mealViewModel = MenuModel.MenuMealViewModel(isChoosen: false, mealId: meal.id, isExpanded: meal.isExpandMeal, name: meal.name, typeMeal: meal.typeMeal, products: [])
    
//    var mealViewModel = MealViewModel.init(isExpand:meal.isExpandMeal, name: meal.name, typeMeal: meal.typeMeal, products: [], mealId: meal.id)
    
    mealViewModel.products = meal.listProduct.map(getProductListViewModel)
    return mealViewModel
  }
  
  private func getProductListViewModel(product: ProductRealm) -> ProductListViewModel {
    
    let product = ProductListViewModel.init(insulinValue: nil, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
    
    return product
    
  }
  
  
  
  // Get ProductViewModel
  
  private func presentProductViewModel(items: Results<ProductRealm>) -> [MenuModel.MenuProductListViewModel] {
    
    var dummyArray: [MenuModel.MenuProductListViewModel] = []
    
    for product in items {
      
      let carboString = String(product.carbo)
      let portionString = String(product.portion)
      
      let productCellViewModel = MenuModel.MenuProductListViewModel(id: product.id, name: product.name, carboOn100Grm: carboString, isFavorit: product.isFavorits, portion: portionString, category: product.category)
      
      dummyArray.append(productCellViewModel)
    }
    
    return dummyArray
  }
}
