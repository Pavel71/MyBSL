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
//    let mealCollectionViewModel = MealCollectionVCViewModel(
//      cells: realmData.listDinners.map(getMealViewModel)
//    )
    
    let collectionVCVM = CollectionVCVM(
      cells: realmData.listDinners.map(getMealViewModel))
    // InsulinSupply
    
    // По идеи я буду это брать юзер дефолтсе так как в реалме сохранять это бессмысленно!
    let insulinSupplyVM = InsulinSupplyViewModel(insulinSupply: 300)
    
    
    return MainScreenViewModel(
      collectionVCVM  : collectionVCVM,
      chartVCVM       : chartViewModel,
      insulinSupplyVM : insulinSupplyVM
    )
  }
  
  // Meal View Model
  
  private func getMealViewModel(dinner: DinnersRealm) -> MainScreenMealViewModel {
    
    let resultVM = ProductListResultsViewModel(
    sumCarboValue   : String(dinner.totalCarbo),
    sumPortionValue : String(dinner.totalPortion),
    sumInsulinValue : String(dinner.totalInsulin))
    
    let mealProdVcViewModel = MealProductsVCViewModel(
      cells    : dinner.listProduct.map(getProductViewModel),
      resultVM : resultVM
    )
    
    return MainScreenMealViewModel(
      type                   : .mealObject,
      id                 : dinner.id,
      productResultViewModel : resultVM,
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
      mealId   : sugarRealm.mealId,
      dataCase : ChartDataCase(rawValue: sugarRealm.dataCase)!,
      sugar    : sugarRealm.sugar,
      time     : sugarRealm.time
      
    )
    
   return sugarViewModel
  }
  
  
  
}
