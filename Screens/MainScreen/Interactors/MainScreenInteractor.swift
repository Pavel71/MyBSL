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
  
  //  var realTimeLocker : Int = 0
  //  var listnerLocker  : Int = 0
  
  
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
    print("Listnera Day Нет")
    

    
    listnerService.setDayListner { (result) in
      
      self.presenter?.presentData(response: .showLoadingMessage(message: "Идет обновление данных"))
      
      switch result {
      case .failure(let error):
        print("Day Listner Error",error.localizedDescription)
        
      case .success((let daysModels,let serverChangeType,let userDefaultsModel)):
        
        if serverChangeType == .modifided {
          print("Modifided Day")
          
          self.addDataToRealm(models: daysModels)
          self.userDefaultsWorker.setDataToUserDefaults(userDefaultsNetwrokModel: userDefaultsModel)
        }
        
        print("Обновить экранчик")
        self.passDayRealmToConvertInVMInPresenter()
        
        
        self.presenter?.presentData(response: .showOffLoadingMessage)
        
      }
    }
  }
  
  private func addDataToRealm(models: [DayNetworkModel]) {
    
    // Вообщем здесь мне нужно Когда приходит день с такойже датой как у меня нужно его заменить
    
    var daysRealm    = [DayRealm]()
    var compobjRealm = [CompansationObjectRelam]()
    var sugarRealm   = [SugarRealm]()
    
    models.forEach { (model) in
      let (day,compObj,sugarObj) = self.convertWorker.convertDayNetworkModelsToRealm(dayNetworkModel: model)
      daysRealm.append(day)
      compobjRealm.append(contentsOf: compObj)
      sugarRealm.append(contentsOf: sugarObj)
      
    }
    // теперь нужно отсортировать данные или просто их разобрать и добавить сразу отсортерованными
    print("Setim дни")
    newDayRealmManager.setDaysToRealm(days: daysRealm)
    compObjRealmManager.setCompObjsToRealm(compObjs: compobjRealm)
    sugarRealmManger.setSugarToRealm(sugars: sugarRealm)
    
    
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
      
      
      print("добавили день Realm")
      let newDay = self.newDayRealmManager.addBlankDay()
      let newDayNetworkModel = self.getDayDataToSetFireStore(dayRealm: newDay)
      print("Добавили день в FireStore")
      
      
      self.addDayToFireStore(dayNetwork: newDayNetworkModel)
      //        addDayTransaction(dayNetwork: newDayNetworkModel)
      
      
    } else { // В Реалме есть день!
      print("Сегодня есть в базе, просто сетим его")
      // Есть сегодняшний день то сетим его в current
      newDayRealmManager.setDayByDate(date: Date())
      
      //      realTimeLocker = 0
      passDayRealmToConvertInVMInPresenter()
    }
    
    
  }
  
}

// MARK: Work with FireStore
extension MainScreenInteractor {
  
  
  
  private func addDayToFireStore(dayNetwork: DayNetworkModel) {
    self.addService.addDayToFireStore(dayNetworkModel: dayNetwork){result in
      
      switch result {
      case .success(let firestoreDayNetwokModel):
        
        // Если модель nil то дня в базе нет!
        guard let networkModel = firestoreDayNetwokModel else {
          return self.passDayRealmToConvertInVMInPresenter()
        }
        print("перезаписываем день")
        let (realmDay,compObjs,sugarObjs) = self.convertWorker.convertDayNetworkModelsToRealm(dayNetworkModel: networkModel)
        // Вообщем происходит бага при создание второго такого же дня! Это из за частых повторений запростов- это надо как то решить
        self.newDayRealmManager.replaceCurrentDay(replaceDay: realmDay)
        self.compObjRealmManager.setCompObjsToRealm(compObjs: compObjs)
        self.sugarRealmManger.setSugarToRealm(sugars: sugarObjs)
        
      case .failure(let error):
        print("Some Error",error)
      }
      self.passDayRealmToConvertInVMInPresenter()
    }
    
  }
  
  
  
  private func writtingDataToFireStoreAfterDeleteCompobj() {
    
    let dayRealm = newDayRealmManager.getCurrentDay()
    
    // Здесь просто Обновить день
    
    let dayNetwrok    = getDayDataToSetFireStore(dayRealm: dayRealm)
    let insulinSupply = userDefaultsWorker.getInsulinSupply()
    let userDefData   = [UserDefaultsKey.insulinSupplyValue.rawValue : insulinSupply]
    
    let prevDayRealm  = getPreviosDayToUpdateInFireStore(currentDay: dayRealm)
    
    
    butchWrittingThenDeleteCompObj(
      dayNetwork       : dayNetwrok,
      userDefaultsData : userDefData,
      prevDayRealm     : prevDayRealm)
  }
  
  private func butchWrittingThenDeleteCompObj(
    dayNetwork       : DayNetworkModel,
    userDefaultsData :[String:Any],
    prevDayRealm     : DayRealm?) {
    
    if let prevDayReal = prevDayRealm {
      let prevDayNetworkModel = getDayDataToSetFireStore(dayRealm: prevDayReal)
      
      butchWrittingService.writingDataAfterUpdateCompobj(
        dayNetwrokModel     : dayNetwork,
        userDefaultsData    : userDefaultsData,
        prevDayNetwrokModel : prevDayNetworkModel)
    } else {
      butchWrittingService.writingDataAfterUpdateCompobj(
        dayNetwrokModel     : dayNetwork,
        userDefaultsData    : userDefaultsData,
        prevDayNetwrokModel : nil)
    }
    
  }
  
  private func getPreviosDayToUpdateInFireStore(currentDay: DayRealm) -> DayRealm? {
    var prevDay: DayRealm?
    if currentDay.listCompObjID.count == 1 {
      prevDay = newDayRealmManager.fetchAllDays().dropLast().last
    }
    return prevDay
  }
  
  
  
  
  
  private func addNewSugarToFireStore(day: DayRealm) {
    
    //    let sugarNetworkModel = convertWorker.convertToSugarNetworkModel(sugarRealm: sugarRealm)
    let day = getDayDataToSetFireStore(dayRealm: day)
    
    // Тут мы просто обновим день! Добавив в него SugarRealm
    
    updateService.updateDayToFireStore(dayNetworkModel: day)    // Здесь нам нужен батч по добавлению сахара в коллекцию + обновление Дня
    
    
    
  }
  
  
}






