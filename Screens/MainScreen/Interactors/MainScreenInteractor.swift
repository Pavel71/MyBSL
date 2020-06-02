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

  
  // Realm and UserDefaults
  
  let newDayRealmManager  : NewDayRealmManager!
  let insulinSupplyWorker : InsulinSupplyWorker!
  let compObjRealmManager : CompObjRealmManager!
  let sugarRealmManger    : SugarRealmManager!
  
  let userDefaultsWorker  : UserDefaultsWorker!
  let convertWorker       : ConvertorWorker!
  
  // FireStore
  let updateService        : UpdateService!
  let addService           : AddService!
  let deleteService        : DeleteService!
  let butchWrittingService : ButchWritingService!
  let fetchService         : FetchService!
 
  // MARK: Init
  
  init() {
    
    let locator = ServiceLocator.shared
    
    newDayRealmManager   = locator.getService()
     
    insulinSupplyWorker  = locator.getService()
    compObjRealmManager  = locator.getService()
    sugarRealmManger     = locator.getService()
     
    userDefaultsWorker   = locator.getService()
    convertWorker        = locator.getService()
     
    updateService        = locator.getService()
    addService           = locator.getService()
    deleteService        = locator.getService()
    butchWrittingService = locator.getService()
    fetchService         = locator.getService()
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

// MARK: Work With VIew Model

extension MainScreenInteractor {
  
  private func catchViewModelRequests(request: MainScreen.Model.Request.RequestType) {
    
    switch request {

      
    case .setInsulinSupplyValue(let insulinSupplyValue):

      userDefaultsWorker.setInsulinSupplyValue(insulinSupply: insulinSupplyValue)
      
      self.updateService.updateInsulinSupplyDataInFireBase(supplyInsulin: insulinSupplyValue)
      passDayRealmToConvertInVMInPresenter()
      
    default:break
    }
  }
}

// MARK: Work With Realm DB

extension MainScreenInteractor {
  
  private func catchRealmRequests(request: MainScreen.Model.Request.RequestType) {
    
    switch request {
      
    case .setSugarVM(let sugarViewModel):

      let sugarRealm = convertWorker.convertToSugarRealm(sugarVM: sugarViewModel)
      // Сохранил сахара в базе данных
      
      newDayRealmManager.addNewSugarId(sugarId: sugarRealm.id)
      sugarRealmManger.addOrUpdateNewSugarRealm(sugarRealm: sugarRealm)
      
      
      self.addNewSugarToFireStore(sugarRealm: sugarRealm, dayId: newDayRealmManager.getCurrentDay().id)

      passDayRealmToConvertInVMInPresenter()
      // Просто передаю модель
      
      
      
      // MARK: Delete COmpObj
    case .deleteCompansationObj(let compObjId):
      
      guard
        let compObj = compObjRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId),
        let deleteSugarId = newDayRealmManager.fetchSugarIdByCompObjId(compObjId: compObjId)
        
      else {return}
      
      // 1. Удалить Sugar
      // 2. Уадлить CompObj
      // 3. Обновить PrevCompObj Если он есть
      // 3. Удалить ID из Day
      // 4. расчитать  Insulin Supply
      
      deleteDataAfterDeletiedCompObj(compObj: compObj, sugarId: deleteSugarId)

      
      
      // здесь нам нужно все таки получить обновленную модель дня и впиздюшить ее
      writtingDataToFireStoreAfterDeleteCompobj(compObjId: compObjId, sugarId: deleteSugarId)

      passDayRealmToConvertInVMInPresenter()
      
    case .getCompansationObj(let compObjId):
      
      guard let compObj = compObjRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId) else {return}
      
      presenter?.presentData(response: .passCompansationObj(compObj: compObj))
      
      // MARK: CheckLastDayInDB
    case .checkLastDayInDB:
      
     checkDayInRealm()
      
    case .selectDayByCalendar(let date):
      // нам приходит запрос выбрать предыдущий день
      newDayRealmManager.setDayByDate(date: date)
      passDayRealmToConvertInVMInPresenter()
      
    case .reloadDay:
      
      passDayRealmToConvertInVMInPresenter()
      
    case .setFirstDayToFireStore:
      let day = newDayRealmManager.getCurrentDay()
      let dayNetwork = convertWorker.convertDayRealmToDayNetworkLayer(dayRealm: day)
      addService.addDayToFireStore(dayNetworkModel: dayNetwork)

    default:break
    }
    
    
    
  }
  
 
}

// MARK: Work With Realm

extension MainScreenInteractor {
  
  private func deleteDataAfterDeletiedCompObj(
    compObj : CompansationObjectRelam,
    sugarId : String) {
    
    let totalInsulin = compObj.totalInsulin.toFloat()

    deleteCompobjAndSugarFromRealm(compObjId: compObj.id, sugarId: sugarId)
    
    insulinSupplyWorker.setNewInsulinSupplyToUserDefaults(totalInsulin: totalInsulin, updatedType: .delete)
  }
  
  private func deleteCompobjAndSugarFromRealm(compObjId:String,sugarId:String) {
    
    newDayRealmManager.deleteCompObjById(compObjId: compObjId)
    newDayRealmManager.deleteSugarByCompObjId(sugarId: sugarId)
    
  }
  
  private func checkDayInRealm() {
    
    if newDayRealmManager.isNowLastDayInDB() == false { // в Реалме нет дня
      
      let newDay = self.newDayRealmManager.addBlankDay()
      
      DispatchQueue.main.async {
        self.saveDayInFireStore(dayRealm: newDay)
      }
      
      
    } else { // В Реалме есть день!
      print("Сегодня есть в базе, просто сетим его")
      // Есть сегодняшний день то сетим его в current
      newDayRealmManager.setDayByDate(date: Date())
      
    }
    passDayRealmToConvertInVMInPresenter()
    
  }
  
}

// MARK: Work with FireStore
extension MainScreenInteractor {

//  private func checkDayInFireStore()  {
//    print("Сегодняшнего дня нет в базе поэтому добавляю новый день")
//
//     fetchService.checkDayByDateInFireStore { (result) in
//       switch result {
//       case .failure(let error):
//         print(error)
//       case .success(let dayNetworkModel):
//
//         if let dayNetwrokM =  dayNetworkModel { // Есть в FireStore
//           print("Сегодня есть в FireStore",dayNetwrokM)
//           // Нужно загрузить его отсюда! и передать в Реалм
//
//         } else { // Нет в FireStore
//
//          self.checkDayInRealm() // проверить реалм
//         }
//
//       }
//
//     }
//  }
  
  
  private func writtingDataToFireStoreAfterDeleteCompobj(
    compObjId: String,
    sugarId:String) {
    
    let dayRealm = newDayRealmManager.getCurrentDay()
      
    let prevCompObj  = compObjRealmManager.fetchLastCompObj()
         
    butchWrittingDeleteCompObj(compObjId: compObjId, sugarId: sugarId, dayRealm: dayRealm, prevCompObj: prevCompObj)
  }
  
  private func butchWrittingDeleteCompObj(
    compObjId       : String,
    sugarId         : String,
    dayRealm        : DayRealm,
    prevCompObj     : CompansationObjectRelam?) {
    
    let insulinSupply = userDefaultsWorker.getInsulinSupply()
    let userDefData   = [UserDefaultsKey.insulinSupplyValue.rawValue : insulinSupply]
    
    let dayNetwrok    = convertWorker.convertDayRealmToDayNetworkLayer(dayRealm: dayRealm)
    
    if let prevComp = prevCompObj {
      let prevNetwrok = convertCompObjRealmToCompObjNetworkModel(compObj: prevComp)
      
      butchWrittingService.writtingDataAfterDeletingCompObj(
        compObjId         : compObjId,
        sugarId           : sugarId,
        dayNetwrokModel   : dayNetwrok,
        userDefaltsData   : userDefData,
        prevCompObjUpdate : prevNetwrok)

      
    } else {
      butchWrittingService.writtingDataAfterDeletingCompObj(
      compObjId         : compObjId,
      sugarId           : sugarId,
      dayNetwrokModel   : dayNetwrok,
      userDefaltsData   : userDefData)
    }

  }

  func saveDayInFireStore(dayRealm: DayRealm) {
    let dayNetworkModel = convertWorker.convertDayRealmToDayNetworkLayer(dayRealm: dayRealm)
    addService.addDayToFireStore(dayNetworkModel: dayNetworkModel)
  }
  
 
  
  func deleteCompObjFromFireStore(compObjId: String) {
    deleteService.deleteCompObjFromFireStore(compObjId: compObjId)
  }
  
  func deleteSugarFromFireStore(sugarId: String) {

    deleteService.deleteSugarFromFireStore(sugarId: sugarId)
  }
  
  private func addNewSugarToFireStore(sugarRealm: SugarRealm,dayId: String) {
    
    let sugarNetworkModel = convertWorker.convertToSugarNetworkModel(sugarRealm: sugarRealm)
     
     // Здесь нам нужен батч по добавлению сахара в коллекцию + обновление Дня
    
    butchWrittingService.writtingSugarToFIreStoreAndSugarIdToDay(
      sugarNetwrokModel: sugarNetworkModel, updateDayID: dayId)
     
     
   }
   
  
}


// MARK: Convert CompObjRealm To NetwrokModel
extension MainScreenInteractor {
  

  private func convertCompObjRealmToCompObjNetworkModel(compObj: CompansationObjectRelam) -> CompObjNetworkModel {
    
    let listProd : [ProductNetworkModel] = compObj.listProduct.map(convertProductsRealmToProductNetworkModel)
    
    return CompObjNetworkModel(
      id                           : compObj.id,
      typeObject                   : compObj.typeObject,
      sugarBefore                  : compObj.sugarBefore,
      sugarAfter                   : compObj.sugarAfter,
      userSetInsulinToCorrectSugar : compObj.userSetInsulinToCorrectSugar,
      sugarDiffToOptimaForMl       : compObj.sugarDiffToOptimaForMl,
      insulinToCorrectSugarML      : compObj.insulinToCorrectSugarML,
      timeCreate                   : compObj.timeCreate.timeIntervalSince1970,
      compansationFase             : compObj.compansationFase,
      insulinOnTotalCarbo          : compObj.insulinOnTotalCarbo,
      totalCarbo                   : compObj.totalCarbo,
      placeInjections              : compObj.placeInjections,
      listProduct                  : listProd)
    
    
  }
  
  private func convertProductsRealmToProductNetworkModel(product: ProductRealm) -> ProductNetworkModel {
    return ProductNetworkModel(
      id                    : product.id,
      name                  : product.name,
      category              : product.category,
      carboIn100grm         : product.carboIn100grm,
      portion               : product.portion,
      percantageCarboInMeal : product.percantageCarboInMeal,
      userSetInsulinOnCarbo : product.userSetInsulinOnCarbo,
      insulinOnCarboToML    : product.insulinOnCarboToML,
      isFavorits            : product.isFavorits)
  }
  
}



