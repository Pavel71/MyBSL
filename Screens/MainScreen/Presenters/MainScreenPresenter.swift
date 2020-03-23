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
    let insulinSupplyVM = InsulinSupplyViewModel(insulinSupply: 300)
    
    let date = DateWorker.shared.getDayMonthYear(date: realmData.date)
    return MainScreenViewModel(
      dayDate         : date,
      collectionVCVM  : collectionVCVM,
      chartVCVM       : chartViewModel,
      insulinSupplyVM : insulinSupplyVM
    )
  }
  
  
  
 
  
  
  
}
