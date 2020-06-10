//
//  MealPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 29/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

protocol MealPresentationLogic {
  func presentData(response: Meal.Model.Response.ResponseType)
}

class MealPresenter: MealPresentationLogic {
  
  weak var viewController: MealDisplayLogic?
  
  func presentData(response: Meal.Model.Response.ResponseType) {
    
    switch response {
      
    // Realm Tokken
      case .passRealmObserverTokken(let realmTokken):
        
        viewController?.displayData(viewModel: .passRealmObserverTokken(realmTokken: realmTokken))
      
      // Meal TableView
      case .prepareMealViewModelforTableView(let items, let isDefaultList):
        
        let arrayItems = Array(items)
        let viewModel = MealTableViewPresenterWorker.getMealViewModelListForTableView(items: arrayItems, isDefaultList: isDefaultList)

        viewController?.displayData(viewModel: .setViewModel(viewModel: viewModel))
      
      // New Meal View
      case .prepareNewMealViewModel(let updateMeal, let listOfTypeMeal):
        
        let newMealViewModel = NewMealViewPresenterWorker.getNewMealViewModel(updateMeal: updateMeal, listtypeOfMeal: listOfTypeMeal)
        viewController?.displayData(viewModel: .setNewMealViewModel(viewModel: newMealViewModel))
      
      
    
    case .passSuccessAddOrUpdateMeal(let isSuccessAdd, let isUpdateMeal):
      viewController?.displayData(viewModel: .showAlertAfterAddMeal(isSuccessAdd: isSuccessAdd, isUpdateMeal: isUpdateMeal))
      
      
    case .showLoadingMessage(let message):
      
      viewController?.displayData(viewModel: .showLoadingMessage(message:message))
    case .showOffLoadingMessage:
      viewController?.displayData(viewModel: .showOffLoadingMessage)
    }
    
  }
  
  
  private func prepareAlertString(success: Bool) -> String {
    
    return success ? "Обед добавленн Успешно" : "Такое имя уже есть! Отредактируйте существующий обед или измение имя"
  }
  
}
