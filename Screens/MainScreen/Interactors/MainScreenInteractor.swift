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
  
  let dayRealmManager = DayRealmManager()
  
  
  func makeRequest(request: MainScreen.Model.Request.RequestType) {
    
    catchRealmRequests(request: request)
    catchViewModelRequests(request: request)
    
  }
  
  private func passDayRealmToConvertInVMInPresenter() {
    
    let updateDay = dayRealmManager.getCurrentDay()
     presenter?.presentData(response: .prepareViewModel(realmData: updateDay))
   }
  
}

// MARK: Work With Realm DB

extension MainScreenInteractor {
  
  private func catchRealmRequests(request: MainScreen.Model.Request.RequestType) {
    
    switch request {
    case .setSugarVM(let sugarViewModel):

      let sugarRealm = convertToSugarRealm(sugarVM: sugarViewModel)
      // Сохранил сахара в базе данных
      dayRealmManager.addSugarData(sugarRealm: sugarRealm)
      // Достаем обновленный день!
      

      passDayRealmToConvertInVMInPresenter()
      // Просто передаю модель
      
      
    case .setCompansationObjRealm(let compObjRealm):
      
      // Здесь мне нужно проверить есть ли такой объект в базе данных! Если да то обнови если нет то добавь
      
      
      
      if compObjRealm.isUpdated {
        dayRealmManager.updateLastCompansationObj(compObj: compObjRealm)
      } else {
        dayRealmManager.addCompansationObjectToRealm(compObj: compObjRealm)
      }
      
      
      
      passDayRealmToConvertInVMInPresenter()
      
      
    case .deleteCompansationObj(let compObjId):
      dayRealmManager.deleteCompasationObjByID(compansationObjId: compObjId)
      // Пришел ID объекта и нам нужно понимать что мы работаем с current Day!
      passDayRealmToConvertInVMInPresenter()
      
    case .getCompansationObj(let compObjId):
      
      guard let compansationObject = dayRealmManager.getCompansationObjById(compObjId: compObjId) else {return print("Нет такого объекта")}
      
      presenter?.presentData(response: .passCompansationObj(compObj: compansationObject))
      
      
    case .checkLastDayInDB:
      
  
      // Если true то мы ничего не трогаем и возвращаем нашу модель как есть
      
      if dayRealmManager.isNowLastDayInDB() == false {
        print("Сегодняшнего дня нет в базе поэтому добавляю его пустым")
        dayRealmManager.addBlankDay()
      } else {
        print("Сегодня есть в базе просто возвращаю что есть")
        // тут нужно достать текущий день и все
      }
      
      passDayRealmToConvertInVMInPresenter()
      
    case .selectDayByCalendar(let date):
      
      
      dayRealmManager.setCurrentDayByDate(date: date)
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
      dayRealmManager.getTestsObjects()
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



