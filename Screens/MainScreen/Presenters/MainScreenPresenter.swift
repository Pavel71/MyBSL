//
//  MainScreenPresenter.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainScreenPresentationLogic {
  func presentData(response: MainScreen.Model.Response.ResponseType)
}

class MainScreenPresenter: MainScreenPresentationLogic {
  weak var viewController: MainScreenDisplayLogic?
  
  func presentData(response: MainScreen.Model.Response.ResponseType) {
    
    catchViewModelResponse(response: response)
  
  }
  
}


// MARK: Catch ViewModel Response

extension MainScreenPresenter {
  
  private func catchViewModelResponse(response: MainScreen.Model.Response.ResponseType) {
    
    switch response {
    case .prepareViewModel(let realmData):
      
      // Здесь нужно получить ищ реалма модельку с данными и отправить ее на контроллер Дальше только обновить экран
      let dayViewModel = getViewModel(realmData: realmData)
      viewController?.displayData(viewModel: .setViewModel(viewModel: dayViewModel))
    default: break
    }
  }
}


//MARK: Work with Realm Data

extension MainScreenPresenter {
  
  // MAin View Model
  private func getViewModel(realmData: DayRealm) -> MainScreenViewModel {
    
    
    // Charts
    let chartViewModel = ChartVCViewModel(
      chartEntryModels : realmData.listSugar.map(getChartViewModel)
    )
    
    
    // Dinners
    let mealCollectionViewModel = MealCollectionVCViewModel(
      cells: realmData.listDinners.map(getMealViewModel)
    )
    
    
    return MainScreenViewModel(
      mealVCVM  : mealCollectionViewModel,
      chartVCVM : chartViewModel
    )
  }
  
  // Meal View Model
  
  private func getMealViewModel(dinner: DinnersRealm) -> MainScreenMealViewModel {
    
    let mealProdVcViewModel = MealProductsVCViewModel(
      cells    : dinner.listProduct.map(getProductViewModel),
      resultVM : ProductListResultsViewModel(
        sumCarboValue   : String(dinner.totalCarbo),
        sumPortionValue : String(dinner.totalPortion),
        sumInsulinValue : String(dinner.totalInsulin))
    )
    
    return MainScreenMealViewModel(
      mealProductVCViewModel : mealProdVcViewModel,
      compansationFase       : CompansationPosition(rawValue: dinner.compansationFase)!
    )
  }
  
  private func getProductViewModel(product: ProductRealm) -> MealProductViewModel  {
    
    return MealProductViewModel(
      name           : product.name,
      carboInPortion : product.carboInPortion,
      portion        : product.portion,
      factInsulin    : product.actualInsulin)
  }
  
  // Chart View Model
  
  private func getChartViewModel(sugarRealm: SugarRealm) -> SugarViewModel {
    
    let sugarViewModel = SugarViewModel(
      
      insulin  : sugarRealm.insulin,
      carbo    : sugarRealm.totalCarbo,
      dataCase : ChartDataCase(rawValue: sugarRealm.dataCase)!,
      sugar    : sugarRealm.sugar,
      time     : sugarRealm.time
    )
    
   return sugarViewModel
  }
  
  
  
}
