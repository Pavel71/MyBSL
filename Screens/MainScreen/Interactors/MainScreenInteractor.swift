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
  let listnerService       : ListnerService!
  
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
    listnerService       = locator.getService()
  }
  
  func makeRequest(request: MainScreen.Model.Request.RequestType) {
    
    catchRealmRequests(request: request)
    catchViewModelRequests(request: request)
    catchFireStoreListnerRequests(request: request)
    
    
  }
  
  private func passDayRealmToConvertInVMInPresenter() {
    
    
    let day = newDayRealmManager.getCurrentDay()
    presenter?.presentData(response: .prepareViewModel(realmData: day))
  }
  
}

// MARK: Work With Listner

extension MainScreenInteractor {
  
  private func catchFireStoreListnerRequests(request: MainScreen.Model.Request.RequestType) {

    switch request {

    case .setFireStoreDayListner:
     
      setDayListner()

    default:break
    }

  }
  
  private func setDayListner() {
    
    print("Check Lisner Day")
    
    guard  listnerService.dayListner == nil else {return}
     print("Установим листнер")
    listnerService.setDayListner { (result) in
      switch result {
      case .failure(let error):
        print("Day Listner Error",error.localizedDescription)
        
      case .success((let model,let type)):
        
        // Запустить сообщение что мы подгружаем данные
        self.presenter?.presentData(response: .showLoadingMessage(message: "Идет обновление данных"))
        
        // и потом мне нужно получить данные из UserDefaults при такой работе!
        switch type {
        case .added,.modifided:
          print("Пришли данные с сервера Day Listner")
          self.addDataToRealm(model: model)
          // Удаление у меня не предусмотренно
        case .removed:
          print("Удалили данные")
          
        }
        print("Загрузить данные по UserDefaults")
        
        self.fetchService.fetchUserDefaultsDataFromFireStore { (result) in
          switch result {
          case .failure(let error):
            print("Fetch USer Defaults Error")
          case .success(let userDefaultsData):
            print("Данные обновленны в UserDefaults")
            self.userDefaultsWorker.setDataToUserDefaults(userDefaultsNetwrokModel: userDefaultsData)
            print("Обновить экранчик")
            self.passDayRealmToConvertInVMInPresenter()
            self.presenter?.presentData(response: .showOffLoadingMessage)
          }
        }
        
//        self.passDayRealmToConvertInVMInPresenter()
      }
    }
  }
  
  private func addDataToRealm(model: DayNetworkModel) {
    let (day,compObj,sugarObj) = self.convertWorker.convertDayNetworkModelsToRealm(dayNetworkModel: model)
    self.newDayRealmManager.setDaysToRealm(days: [day])
    sugarObj.forEach(self.sugarRealmManger.addOrUpdateNewSugarRealm(sugarRealm: ))
    compObj.forEach(self.compObjRealmManager.addOrUpdateNewCompObj(compObj:))
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
      
      
      self.addNewSugarToFireStore(day: newDayRealmManager.getCurrentDay())
      
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

      writtingDataToFireStoreAfterDeleteCompobj()
      
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
      
      let dayNetwork = getDayDataToSetFireStore(dayRealm: day)
      
      //      let dayNetwork = convertWorker.convertDayRealmToDayNetworkLayer(dayRealm: day)
      
      addDayToFireStore(dayNetwork:dayNetwork)
     
      
    default:break
    }
    
    
    
  }
  
  // MARK: Convert Day Data
  private func getDayDataToSetFireStore(dayRealm: DayRealm) -> DayNetworkModel {
    let compObjs = Array(dayRealm.listCompObjID.compactMap( compObjRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: )))
    
    let sugarObjs = Array(dayRealm.listSugarID.compactMap( sugarRealmManger.fetchSugarByPrimeryKey(sugarPrimaryKey:)))
    let dayNetwork = convertWorker.convertDayRealmToDayNetworkLayer(
      dayRealm         : dayRealm,
      listSugarRealm   : sugarObjs,
      listCompObjRealm : compObjs)
    return dayNetwork
    
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
  
  // MARK: Check Day in Realm
  
  private func checkDayInRealm() {
    
    if newDayRealmManager.isNowLastDayInDB() == false { // в Реалме нет дня
      
      let newDay = self.newDayRealmManager.addBlankDay()
      
      DispatchQueue.main.async {
        
        self.checkDayInFireStoreAndSaveOrReplace(dayRealm: newDay)
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
  
  
  private func addDayToFireStore(dayNetwork: DayNetworkModel) {
    addService.addDayToFireStore(dayNetworkModel: dayNetwork)
    
    
//    setDayListner()
    
  }
  
  
  
  private func writtingDataToFireStoreAfterDeleteCompobj() {
    
    let dayRealm = newDayRealmManager.getCurrentDay()
    
    // Здесь просто Обновить день
    
    let dayNetwrok    = getDayDataToSetFireStore(dayRealm: dayRealm)
    let insulinSupply = userDefaultsWorker.getInsulinSupply()
    let userDefData   = [UserDefaultsKey.insulinSupplyValue.rawValue : insulinSupply]
    
    
    butchWrittingThenDeleteCompObj(dayNetwork: dayNetwrok, userDefaultsData: userDefData)
  }
  
  private func butchWrittingThenDeleteCompObj(
    dayNetwork: DayNetworkModel,userDefaultsData:[String:Any]) {
    
    butchWrittingService.writingDataAfterUpdateCompobj(dayNetwrokModel: dayNetwork, userDefaultsData: userDefaultsData)
  }
  //  private func butchWrittingDeleteCompObj(
  //    compObjId       : String,
  //    sugarId         : String,
  //    dayRealm        : DayRealm,
  //    prevCompObj     : CompansationObjectRelam?) {
  //
  //    let insulinSupply = userDefaultsWorker.getInsulinSupply()
  //    let userDefData   = [UserDefaultsKey.insulinSupplyValue.rawValue : insulinSupply]
  //
  //    let dayNetwrok    = convertWorker.convertDayRealmToDayNetworkLayer(dayRealm: dayRealm)
  //
  //    if let prevComp = prevCompObj {
  //      let prevNetwrok = convertWorker.convertCompObjRealmToCompObjNetworkModel(compObj: prevComp)
  //
  //      butchWrittingService.writtingDataAfterDeletingCompObj(
  //        compObjId         : compObjId,
  //        sugarId           : sugarId,
  //        dayNetwrokModel   : dayNetwrok,
  //        userDefaltsData   : userDefData,
  //        prevCompObjUpdate : prevNetwrok)
  //
  //
  //    } else {
  //      butchWrittingService.writtingDataAfterDeletingCompObj(
  //        compObjId         : compObjId,
  //        sugarId           : sugarId,
  //        dayNetwrokModel   : dayNetwrok,
  //        userDefaltsData   : userDefData)
  //    }
  //
  //  }
  
  //MARK: CheckDay in FireStore
  
  private func checkDayInFireStoreAndSaveOrReplace(dayRealm: DayRealm) {
    
    let newDayNetworkModel = getDayDataToSetFireStore(dayRealm: dayRealm)
    
    fetchService.checkDayByDateInFireStore { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let dayNetworkModel):
        
        if let dayNetwrokM =  dayNetworkModel { // Есть в FireStore
          print("Текущий день находится в FireStore")

          let (realmDay,compObjs,sugarObjs) = self.convertWorker.convertDayNetworkModelsToRealm(dayNetworkModel: dayNetwrokM)
          
          self.newDayRealmManager.replaceCurrentDay(replaceDay: realmDay)
          compObjs.forEach(self.compObjRealmManager.addOrUpdateNewCompObj(compObj: ))
          sugarObjs.forEach(self.sugarRealmManger.addOrUpdateNewSugarRealm(sugarRealm:))
          
          self.passDayRealmToConvertInVMInPresenter()
          
        } else { // Нет в FireStore
          // Добавим
          print("Сохранем день в FireStore")
          
          self.addDayToFireStore(dayNetwork: newDayNetworkModel)

          
        }
        
      }
      
    }
    
    
    
  }
  
  
  
//  func deleteCompObjFromFireStore(compObjId: String) {
//    deleteService.deleteCompObjFromFireStore(compObjId: compObjId)
//  }
//
//  func deleteSugarFromFireStore(sugarId: String) {
//
//    deleteService.deleteSugarFromFireStore(sugarId: sugarId)
//  }
  
  private func addNewSugarToFireStore(day: DayRealm) {
    
    //    let sugarNetworkModel = convertWorker.convertToSugarNetworkModel(sugarRealm: sugarRealm)
    let day = getDayDataToSetFireStore(dayRealm: day)
    
    // Тут мы просто обновим день! Добавив в него SugarRealm
    
    updateService.updateDayToFireStore(dayNetworkModel: day)    // Здесь нам нужен батч по добавлению сахара в коллекцию + обновление Дня
    
    //    butchWrittingService.writtingSugarToFIreStoreAndSugarIdToDay(
    //      sugarNetwrokModel: sugarNetworkModel, updateDayID: dayId)
    
    
  }
  
  
}






