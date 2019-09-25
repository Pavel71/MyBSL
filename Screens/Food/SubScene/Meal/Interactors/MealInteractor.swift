//
//  MealInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 29/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

protocol MealBusinessLogic {
  func makeRequest(request: Meal.Model.Request.RequestType)
}

class MealInteractor: MealBusinessLogic {
  
  var presenter: MealPresentationLogic?
  var realmManager: MealRealmManager!
  
//  var items: Results<MealRealm>!
  
  var isDefaultList = true
  
  func makeRequest(request: Meal.Model.Request.RequestType) {
    if realmManager == nil {
      realmManager = MealRealmManager()
    }
    
    
    workWithMealRequest(request: request)
    workWithProductListFromMealRequests(request: request)
    
    switch request {
      
    // Show Sections By Type OF meal
    case .showListMealsBySection(let isDefaultList):
      
      self.isDefaultList = isDefaultList
      let items = realmManager.fetchAllMeals()
      
      presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
      
      // Search Bar
    case .searchMealByname(let character):
      
      let items = realmManager.seacrhMealByName(character: character)
      presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
      
    // Set Realm Observer
    case .setRealmObserver:
      
      realmManager.didChangeRealmDB = {[weak self] items in self?.realmDBDidChange(items: items)}
      let realmTokken = realmManager.setObserverToken()
      
      presenter?.presentData(response: .passRealmObserverTokken(realmTokken: realmTokken))

      
      // Show NewMealView
      
    case .showNewMealView(let mealId):
      
      let listOFTypeMeal = getListOfTypeOfMeal()
      let updateMeal = getUpdateMeal(mealId: mealId)
      
      presenter?.presentData(response: .prepareNewMealViewModel(updateMeal: updateMeal, listOfTypeMeal: listOFTypeMeal))
      
    default:break
    }
    
    
    
  }
  
  private func workWithProductListFromMealRequests(request:Meal.Model.Request.RequestType) {
    
    switch  request {
      // Product List Delete Update Add
      case .deleteProductFromMeal(let mealId, let rowProduct):
        realmManager.deleteProductFromMeal(row: rowProduct, mealId: mealId) // realmDBDidChange
      
      case .updateProductPortionFromMeal(let mealId, let rowProduct, let portion):
        realmManager.updateProductPortionFromMeal(row: rowProduct, mealId: mealId, portion: portion) // realmDBDidChange
      
      case .addProductInMeal(let mealId, let productId):
        realmManager.addproductInMeal(mealId: mealId, productId: productId) // realmDBDidChange
      
      
    default:break
    }
  }
  
  // MARK: Work With Meal Request
  
  private func workWithMealRequest(request:Meal.Model.Request.RequestType) {
    
    switch request {
      // FetchAll Meals
      case .fetchAllMeals:
        let items = realmManager.fetchAllMeals()
        presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
     
      
      
    // Expand Meal
      case .expandedMeal(let mealId):
        realmManager.changeMealExpande(mealId: mealId) // realmDBDidChange
      // Delete Meal
      case .deleteMeal(let mealId):
        
        realmManager.deleteMeal(mealId: mealId) // realmDBDidChange
      // Add or Update Meal
      case .addOrUpdateNewMeal(let viewModel):
        
        if viewModel.mealId != nil {
          // Обновляем продукт
          realmManager.updateAllMealFields(viewModel: viewModel) { [weak self] (success) in
            self?.presenter?.presentData(response: .passSuccessAddOrUpdateMeal(isSuccessAdd:success, isUpdateMeal: true)) // realmDBDidChange
          }
          
        } else {
          realmManager.addNewMeal(viewModel: viewModel) { [weak self] (success) in
            self?.presenter?.presentData(response: .passSuccessAddOrUpdateMeal(isSuccessAdd:success, isUpdateMeal: false)) // realmDBDidChange
          }
          
        }
      
    default:break
    }
  }
  
  // for NewMealViewModel Presenter
  
  private func getUpdateMeal(mealId: String?) -> MealRealm? {
    
    var updateMeal: MealRealm?
    if let mealId = mealId {
      updateMeal = realmManager.getMealById(mealId: mealId)
    }
    return updateMeal
  }
  
  private func getListOfTypeOfMeal() -> [String] {
    return realmManager.getTypeOFMealList()
  }
  
  private func realmDBDidChange(items: Results<MealRealm>) {
    print("Change DB delete productsIn Realm")
    
    presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
  }
  
}
