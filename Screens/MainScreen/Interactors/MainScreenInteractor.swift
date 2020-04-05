//
//  MainScreenInteractor.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainScreenBusinessLogic {
  func makeRequest(request: MainScreen.Model.Request.RequestType)
}

class MainScreenInteractor: MainScreenBusinessLogic {

  var presenter: MainScreenPresentationLogic?
  
//  let dayRealmManager = DayRealmManager()
  let newDayRealmManager = NewDayRealmManager.shared
  
  
  
  func makeRequest(request: MainScreen.Model.Request.RequestType) {
    
    catchRealmRequests(request: request)
    catchViewModelRequests(request: request)
    
  }
  
  private func passDayRealmToConvertInVMInPresenter() {
    
//    let updateDay = dayRealmManager.getCurrentDay()
    
     let day = newDayRealmManager.getCurrentDay()
     presenter?.presentData(response: .prepareViewModel(realmData: day))
   }
  
}

// MARK: Work With Realm DB

extension MainScreenInteractor {
  
  private func catchRealmRequests(request: MainScreen.Model.Request.RequestType) {
    
    switch request {
      
    case .setSugarVM(let sugarViewModel):

      let sugarRealm = convertToSugarRealm(sugarVM: sugarViewModel)
      // Сохранил сахара в базе данных
      
      newDayRealmManager.addNewSugarId(sugarId: sugarRealm.id)
      SugarRealmManager.shared.addOrUpdateNewSugarRealm(sugarRealm: sugarRealm)

      passDayRealmToConvertInVMInPresenter()
      // Просто передаю модель
      
      
    case .addCompIdAndSugarIdinDay(let compObjId,let sugarId):
      
      newDayRealmManager.addNewCompObjId(compObjId: compObjId)
      
      
      
      
      newDayRealmManager.addNewSugarId(sugarId: sugarId)
      
      passDayRealmToConvertInVMInPresenter()
      
      
    case .deleteCompansationObj(let compObjId):
      
      newDayRealmManager.deleteCompObjById(compObjId: compObjId)
      newDayRealmManager.deleteSugarByCompObjId(sugarCompObjId: compObjId)

      passDayRealmToConvertInVMInPresenter()
      
    case .getCompansationObj(let compObjId):
      
      guard let compObj = CompObjRealmManager.shared.fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId) else {return}
      
      presenter?.presentData(response: .passCompansationObj(compObj: compObj))

    case .checkLastDayInDB:
      // Если true то мы ничего не трогаем и возвращаем нашу модель как есть
      
      if newDayRealmManager.isNowLastDayInDB() == false {
        print("Сегодняшнего дня нет в базе поэтому добавляю новый день")
        newDayRealmManager.addBlankDay()
      }
      
      passDayRealmToConvertInVMInPresenter()
      
      
    case .reloadDay:
      
      passDayRealmToConvertInVMInPresenter()
      
    default:break
    }
    
    
    
  }
  
 
}


// MARK: Work With VIew Model

extension MainScreenInteractor {
  
  private func catchViewModelRequests(request: MainScreen.Model.Request.RequestType) {
    
    switch request {
    case .getBlankViewModel:
      
      // MARK: TO DO Change methods
//      dayRealmManager.getTestsObjects()
      newDayRealmManager.addBlankDay()
      passDayRealmToConvertInVMInPresenter()
      
    default:break
    }
  }
}

// MARK: Convert ViewModels to RealmObjects
extension MainScreenInteractor {
  
  
  // Это если мы просто добавляем Передать Сахар
  private func convertToSugarRealm(sugarVM: SugarViewModel) -> SugarRealm {
    
    
    return SugarRealm(
      time: sugarVM.time,
      sugar: sugarVM.sugar,
      dataCase: sugarVM.dataCase,
      compansationObjectId: sugarVM.compansationObjectId)
  }
  
  

  
}



