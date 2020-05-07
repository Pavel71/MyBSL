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


  let newDayRealmManager  : NewDayRealmManager!
  let insulinSupplyWorker : InsulinSupplyWorker!
  let compObjRealmManager : CompObjRealmManager!
  let sugarRealmManger    : SugarRealmManager!
  let updateService       : UpdateService!
  let userDefaultsWorker  : UserDefaultsWorker!
    
  
  
  init() {
    
    let locator = ServiceLocator.shared
    
    newDayRealmManager  = locator.getService()
    
    insulinSupplyWorker = locator.getService()
    compObjRealmManager = locator.getService()
    sugarRealmManger    = locator.getService()
    updateService       = locator.getService()
    userDefaultsWorker  = locator.getService()
  }
  
  func makeRequest(request: MainScreen.Model.Request.RequestType) {

    catchRealmRequests(request: request)
    catchViewModelRequests(request: request)
    
  }
  
  private func passDayRealmToConvertInVMInPresenter() {
    
    
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
      sugarRealmManger.addOrUpdateNewSugarRealm(sugarRealm: sugarRealm)

      passDayRealmToConvertInVMInPresenter()
      // Просто передаю модель
      
      
    case .addCompIdAndSugarIdinDay(let compObjId,let sugarId):
      
      newDayRealmManager.addNewCompObjId(compObjId: compObjId)

      newDayRealmManager.addNewSugarId(sugarId: sugarId)
      
      passDayRealmToConvertInVMInPresenter()
      
      
    case .deleteCompansationObj(let compObjId):
      
      guard let compObj = compObjRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId) else {return}
      let totalInsulin = compObj.totalInsulin
      
      newDayRealmManager.deleteCompObjById(compObjId: compObjId)
      newDayRealmManager.deleteSugarByCompObjId(sugarCompObjId: compObjId)
      
      updateInsulinSupplyValue(totalInsulin: totalInsulin.toFloat(), updatedType: .delete)
      
    

      passDayRealmToConvertInVMInPresenter()
      
    case .getCompansationObj(let compObjId):
      
      guard let compObj = compObjRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId) else {return}
      
      presenter?.presentData(response: .passCompansationObj(compObj: compObj))

    case .checkLastDayInDB:
      // Если true то мы ничего не трогаем и возвращаем нашу модель как есть
      
      
      if newDayRealmManager.isNowLastDayInDB() == false {
        print("Сегодняшнего дня нет в базе поэтому добавляю новый день")
        newDayRealmManager.addBlankDay()
      } else {
        print("Сегодня есть в базе, просто сетим его")
        // Есть сегодняшний день то сетим его в current
        newDayRealmManager.setDayByDate(date: Date())
      }
      
      passDayRealmToConvertInVMInPresenter()
      
      
    case .selectDayByCalendar(let date):
      // нам приходит запрос выбрать предыдущий день
      newDayRealmManager.setDayByDate(date: date)
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
      
    case .setInsulinSupplyValue(let insulinSupplyValue):
      
      setInsulinSupplyValueInUserDefaults(insulinSupply: insulinSupplyValue)
      
      
      print("Пошло обновление в FireBase Insulin Supply")
      self.updateService.updateInsulinSupplyDataInFireBase(supplyInsulin: insulinSupplyValue)
      
     
      
      passDayRealmToConvertInVMInPresenter()
      
    default:break
    }
  }
}

// MARK: Update Insulin Supply Value

extension MainScreenInteractor {
  
  private func setInsulinSupplyValueInUserDefaults(insulinSupply: Int) {
    
    userDefaultsWorker.setInsulinSupplyValue(insulinSupply: insulinSupply)
    
  }
  
  private func updateInsulinSupplyValue(
    totalInsulin: Float,
    updatedType: InsulinSupplyWorker.InsulinSupplyCalculatedType) {
    
    insulinSupplyWorker.updateInsulinSupplyValue(
      totalInsulin         : totalInsulin,
      updatedType          : updatedType)
    
    
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



