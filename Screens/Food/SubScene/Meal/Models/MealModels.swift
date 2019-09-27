//
//  MealModels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 29/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

enum Meal {
   
  enum Model {
    struct Request {
      enum RequestType {
        
        
        // Test
        
        
        // Fetch All List or Sections
        case fetchAllMeals
        case showListMealsBySection(isDefaultList: Bool)
        case searchMealByname(character: String)
        // Set RealmObserver
        case setRealmObserver
        
        // Add Meal Or Update Meal
        case addOrUpdateNewMeal(viewModel: MealViewModel)
        // Expanded Meal
        case expandedMeal(mealId: String)
        // Delete meal
        case deleteMeal(mealId: String)
        
        // ShowNewMealView
        case showNewMealView(mealId: String?)
        
        // ProductListRequests
        // Здесь надежнее будет работать через id! Переписать!
        case deleteProductFromMeal(mealId: String,rowProduct: Int)
        case updateProductPortionFromMeal(mealId: String,rowProduct: Int,portion:Int)
        case addProductInMeal(mealId: String,productId: String)
        
        
      }
    }
    struct Response {
      
      enum ResponseType {
        
        // Prepare View Model for Cell
        case prepareMealViewModelforTableView(items: Results<MealRealm>, bySections: Bool)
      
        case passRealmObserverTokken(realmTokken: NotificationToken)
        
        case prepareNewMealViewModel(updateMeal: MealRealm?, listOfTypeMeal:[String])
        // Add or Update Meal
        case passSuccessAddOrUpdateMeal(isSuccessAdd: Bool, isUpdateMeal: Bool)
      }
    }
    
    struct ViewModel {
      enum ViewModelData {
        
        // Meal TableView View Model
        case setViewModel(viewModel: [SectionMealViewModel])
//        case passSuccessDeleteMeal(viewModel: [SectionMealViewModel])
        case passRealmObserverTokken(realmTokken: NotificationToken)
        // New Meal View Model
        case setNewMealViewModel(viewModel: NewMealViewModel)
        
        // Show Success Alert After Add Meal
        case showAlertAfterAddMeal(isSuccessAdd: Bool, isUpdateMeal: Bool)
      }
    }
  }
  
}


// Это модель на tableView!
struct SectionMealViewModel: HeaderInSectionWorkerProtocol {

  var isExpanded: Bool
  var sectionName: String  // Тип приемов пищи!
  var meals: [MealViewModelCell]
  
  init(isExpanded: Bool = false, sectionName: String = "Все обеды" , meals: [MealViewModelCell]) {
    self.isExpanded = isExpanded
    self.sectionName = sectionName
    self.meals = meals
  }
  
}


// Это модель на 1 Обед!

struct MealViewModel: MealViewModelCell {
  
  var mealId: String?
  var isExpanded: Bool
  
  // protocol prop
  var products: [ProductListViewModel] // То что пойдет в дополнительный лист
  
  // Что показываем в самой ячейки
  var name: String
  var typeMeal: String  // Заголовок секции

  
  init(isExpand: Bool, name: String,typeMeal: String, products: [ProductListViewModel],mealId: String?) {
    
    self.isExpanded = isExpand
    self.name = name
    self.typeMeal = typeMeal
    self.products = products
    self.mealId = mealId
  }
  
 
  
}

struct ProductListViewModel: ProductListViewModelCell {
  
  var insulinValue: String?
  
  var carboIn100Grm: Int
  
  // ProductViewModelCell
  var carboInPortion: String
  var name: String
  var portion: String
  
}

struct NewMealViewModel: NewMealViewModelable {
  
  var listTypeOfMeal: [String]
  
  var mealId: String?
  var name: String?
  
  var typeOfMeal: String?


  
}
