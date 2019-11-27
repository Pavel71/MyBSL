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
    
    let chartViewModel = ChartViewModel(
      chartEntryModels : realmData.listSugar.map(getChartViewModel)
    )
    
    
    return MainScreenViewModel(chartViewModel: chartViewModel)
  }
  
  // Chart View Model
  
  private func getChartViewModel(sugarRealm: SugarRealm) -> SugarViewModel {
    
    // Здесь мне нужно формировать дополнительные данные для графика!
    
    // Допустим я знаю что этот сахар привязан к обеду! Згачит мне нужны дополнительные данные такие как дозировка и кол-во углеводов
    
    // Можно впринципе здесь это формировать но длучше в chat Worker
    
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
