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
    
    catchSimpleResponse(response: response)
  
  }
  
}

// MARK: Catch Simple Response

extension MainScreenPresenter {
  
  private func catchSimpleResponse(response: MainScreen.Model.Response.ResponseType) {
    switch response {
    case .passCompansationObj(let compObj):
      viewController?.displayData(viewModel: .throwCompansationObjectToUpdate(compObj: compObj))
    default:break
    }
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
      chartEntryModels : realmData.listSugar.map(ChartVMWorker.getChartViewModel)
    )
    
    
    let collectionVCVM = CollectionVCVM(
      cells: realmData.listDinners.map(CompansationObjCollectionWorker.getCellViewModel))
    // InsulinSupply
    
    // По идеи я буду это брать юзер дефолтсе так как в реалме сохранять это бессмысленно!
    // Здесь мне нужно делать перерасчет каждый раз убавлять сумму инсулина из компенсатион обжетк
    let date = DateWorker.shared.getDayMonthYear(date: realmData.date)
    let dayVM = DayVM(
      curentDate: date,
      chartVCVM: chartViewModel,
      collectionVCVM: collectionVCVM)
    
    // Эти 2 объекта получают информацию не зависимо ото дня! - это общая информация!
    let insulinSupplyVM = getInsulinSupplyVM()
    let calendarVM = getCalendarVM(realmDay: realmData)
     
   
    
    
    
    
    return MainScreenViewModel(
//      dayDate         : date,
      dayVM           : dayVM,
      insulinSupplyVM : insulinSupplyVM,
      calendarVM      : calendarVM
    )
  }
  
  
  private func getCalendarVM(realmDay: DayRealm) -> CalendarVM {
    
    // Здесь мне нужно сделать запрос к базе данных полуичить все дни в текущем месяце которые есть у нас в заполненных!
    
    let datesinThisMoth = DayRealmManager().getDaysInThisMonth()
    
    let calendarVM      = CalendarVM(
         dates: datesinThisMoth,
         selectDay: realmDay.date)
    
    return calendarVM
  }
  
  private func getInsulinSupplyVM() -> InsulinSupplyViewModel {
    InsulinSupplyViewModel(insulinSupply: 300)
  }
  
  
  
 
  
  
  
}
