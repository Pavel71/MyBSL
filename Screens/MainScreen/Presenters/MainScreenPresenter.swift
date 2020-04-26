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
  
  
  let sugarRealmManager : SugarRealmManager!
  let compObjRealmManger: CompObjRealmManager!
  
  let newDayRealmManger : NewDayRealmManager!
  let userDefaults = UserDefaults.standard
  
  
  init() {
    let locator = ServiceLocator.shared
    sugarRealmManager  = locator.getService()
    compObjRealmManger = locator.getService()
    newDayRealmManger  = locator.getService()
  }
  
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
      
      
      
      let dayViewModel = getViewModel(
        realmData          : realmData)
      
      viewController?.displayData(viewModel: .setViewModel(viewModel: dayViewModel))

    default: break
    }
  }
}


//MARK: Work with Realm Data

extension MainScreenPresenter {
  
  // MAin View Model
  private func getViewModel(realmData : DayRealm) -> MainScreenViewModel {
    
    // Test
    
    let listSugar = realmData.listSugarID.compactMap(sugarRealmManager.fetchSugarByPrimeryKey(sugarPrimaryKey:))
    
    let listCopmObj = realmData.listCompObjID.compactMap(compObjRealmManger.fetchCompObjByPrimeryKey(compObjPrimaryKey:))
    
    // Charts
    let chartViewModel = ChartVCViewModel(
      chartEntryModels : listSugar.map(ChartVMWorker.getChartViewModel)
    )

    let collectionVCVM = CollectionVCVM(
      cells: listCopmObj.map(CompansationObjCollectionWorker.getCellViewModel))
    // InsulinSupply
    
    // По идеи я буду это брать юзер дефолтсе так как в реалме сохранять это бессмысленно!
    // Здесь мне нужно делать перерасчет каждый раз убавлять сумму инсулина из компенсатион обжетк
    
    let dayVM = DayVM(
      curentDate: realmData.date,
      chartVCVM: chartViewModel,
      collectionVCVM: collectionVCVM)
    
    // Эти 2 объекта получают информацию не зависимо ото дня! - это общая информация!
    let insulinSupplyVM = getInsulinSupplyVM()
    let mainNavBarVM    = getMainNavBarVM(realmDay: realmData)
     

    return MainScreenViewModel(

      mainNavBarVm    : mainNavBarVM,
      dayVM           : dayVM,
      insulinSupplyVM : insulinSupplyVM
      
    )
  }
  
  
  
  // MARK: Calendar VM
  
  private func getMainNavBarVM(
    realmDay           : DayRealm
  ) -> MainNavBarVM {
    
    // Здесь мне нужно сделать запрос к базе данных полуичить все дни в текущем месяце которые есть у нас в заполненных!
    
//    let datesinThisMoth = DayRealmManager().getDaysInThisMonth()
   let lastSevenDates = newDayRealmManger.fetchLastSevenDaysDate()
    
   let mainNavBarVM = MainNavBarVM(
    lastSevenDays : lastSevenDates,
    titleDate     : realmDay.date)
    
    return mainNavBarVM
  }
  
  
  // MARK: Insulin SUpply VM
  private func getInsulinSupplyVM() -> InsulinSupplyViewModel {
    
    let insulinSupplyValue = userDefaults.integer(forKey: UserDefaultsKey.insulinSupplyValue.rawValue)
    
    return InsulinSupplyViewModel(insulinSupply: Float(insulinSupplyValue))
  }
  
  
  
 
  
  
  
}
