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
  
//    var realTimeLocker : Int = 0
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
  
//  private func realTimeLokerAdd() {
//    realTimeLocker = 1
//  }
//
//  private func realTimeLockerFree() {
//    realTimeLocker = 0
//  }
  
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
  
  // MARK: - Set Firestore day listner
  private func setDayListner() {
    
    print("Check Lisner Day")
    
    guard  listnerService.dayListner == nil else {return}
    
    
    listnerService.setDayListner { (result) in
      
       self.presenter?.presentData(response: .showLoadingMessage(message: "Идет обновление данных"))

      switch result {
      case .failure(let error):
        print("Day Listner Error",error.localizedDescription)
        self.presenter?.presentData(response: .showOffLoadingMessage)
        self.passDayRealmToConvertInVMInPresenter()
      case .success((let daysModels,let serverChangeType,let userDefaultsModel)):
        
        if serverChangeType == .modifided {
          print("Modifided Day")
          
          self.addListnerDataToRealm(daysModels: daysModels, userDefaultsModel: userDefaultsModel)
          
        }
        
        if serverChangeType == .added {
          print("Added Days")
          // Здесь нужно проверить есть ли день в реалме с текущей датой! Если есть то удалить его
          
          // Если сегодня есть то удалим его // Это может быть из за лага в интернете! Но мы обязаны добавить день! А так отдаем приорите дню который придет из Базы данных
          self.newDayRealmManager.deleteToday()
          self.addListnerDataToRealm(daysModels: daysModels, userDefaultsModel: userDefaultsModel)

        }
        
        print("Обновить экранчик")
        self.passDayRealmToConvertInVMInPresenter()
      }
      
      self.presenter?.presentData(response: .showOffLoadingMessage)
    }
  }
  
  private func isTodayInListnerAddData(days:[DayNetworkModel])-> Bool {
    return days.filter({ (dayNetwork) -> Bool in
               dayNetwork.date == Date().onlyDate()?.timeIntervalSince1970
             }).isEmpty
  }
  
  // MARK: Add Day TO Realm
  
  
  private func addListnerDataToRealm(
    daysModels        : [DayNetworkModel],
    userDefaultsModel : [UserDefaultsNetworkModel]) {
    
    self.addDataToRealm(models: daysModels)
         
    guard let usDefModel = userDefaultsModel.first else {return}
    self.userDefaultsWorker.setDataToUserDefaults(userDefaultsNetwrokModel: usDefModel)
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

      
      
      
    case .selectDayByCalendar(let date):
      // нам приходит запрос выбрать предыдущий день
      newDayRealmManager.setDayByDate(date: date)
      passDayRealmToConvertInVMInPresenter()
      
    case .reloadDay:
      
      passDayRealmToConvertInVMInPresenter()
      
    case .addNewDay:
      // Приходит запрос на добавление нового дня!
      // 1. Проверяем есть ли сегодняшний день в базе? Если есть то отправляем сообщение что сегодня уже есть дождидесь завтрашнего дня!
      
      if newDayRealmManager.isNowLastDayInDB() {
        // в реалме есть день!
        
        presenter?.presentData(response: .showAlertMessage(title: "День есть в базе", message: "Добавьте новый день завтра"))
      } else {

        
        // Realm
        let newDayRealm = DayRealm(date: Date())
        self.newDayRealmManager.setDayToRealm(day: newDayRealm)
        self.newDayRealmManager.setCurrentDay(dayRealm: newDayRealm)
        
        // Теперь надо добавить в fireStore по транзакции!чтобы в случае обьрыва соединенния потворилось добавление!
        let newDayNetworkModel = self.getDayDataToSetFireStore(dayRealm: newDayRealm)
        self.addService.addDayToFRBWithTransaction(dayNetworkModel: newDayNetworkModel)
        
        passDayRealmToConvertInVMInPresenter()
      }

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
  
//  private func checkDayInRealm() {
//
//    guard realTimeLocker == 0 else {return} // Значит возможно к нам уже идут данные
//
//    realTimeLokerAdd()
//
//    if newDayRealmManager.isNowLastDayInDB() == false { // в Реалме нет дня
//
//      print("В реалме нет дня")
//      // Запустить процесс показа сообщения
//
//      presenter?.presentData(response: .showLoadingMessage(message: "Добавляю новый день"))
//      createDayAndAddToRealmAndFireStore()
//      //        addDayTransaction(dayNetwork: newDayNetworkModel)
//
//
//    } else { // В Реалме есть день!
//      print("Сегодня есть в базе, просто сетим его")
//      // Есть сегодняшний день то сетим его в current
//      newDayRealmManager.setDayByDate(date: Date())
//
//      realTimeLockerFree()
//      passDayRealmToConvertInVMInPresenter()
//    }
//
//
//  }
  
  
//  private func createDayAndAddToRealmAndFireStore() {
////    let newDay = self.newDayRealmManager.addBlankDay()
//
//    // Вообщем нужно добавлять день в реалм в любом слуячае! Потом проверять уже есть ли дни в FireStore или нет!
//
//    let newDayRealm = DayRealm(date: Date())
//    let newDayNetworkModel = self.getDayDataToSetFireStore(dayRealm: newDayRealm)
//    print("Проверим есть ли день в FireStore")
//
//    addDayByTransaction(dayNetwork: newDayNetworkModel, newDayRealm: newDayRealm)
//
//    // Как можно избежать! Сбегать в Базу и проверить есть ли там сегодняшний день? Если его там нет то добавить в базу и в реалм! Если он там есть то ничего не делать так как он нам подгрузится с листнером!
//
////    self.addDayToFireStore(dayNetwork: newDayNetworkModel)
//  }
  
}

// MARK: Work with FireStore
extension MainScreenInteractor {
  
//  private func addDayByTransaction(dayNetwork: DayNetworkModel,newDayRealm: DayRealm) {
//
//    self.addService.addDayToFireStoreTransaction(dayNetworkModel: dayNetwork) {result in
//
//      switch result {
//      case .success(let isNeedSettDataToRealm):
//
//        // Я думаю что нужно поставить день в любом слуяае! А если он придет из листнера! ТО мы просто его обновим
//
//        self.newDayRealmManager.setDayToRealm(day: newDayRealm)
//        self.newDayRealmManager.setCurrentDay(dayRealm: newDayRealm)
//
////        if isNeedSettDataToRealm {
////          print("Устанавливаю данные после TransAction в Реалм")
////          self.newDayRealmManager.setDayToRealm(day: newDayRealm)
////          self.newDayRealmManager.setCurrentDay(dayRealm: newDayRealm)
////        }
//
//        // Нужно прокинуть инфу что все в порядке после установки реалм данных
//        self.realTimeLockerFree()
//        self.passDayRealmToConvertInVMInPresenter()
//
//      case .failure(_):
//        print("Пришла ошибка в транзактион")
//
//      }
//
//      self.presenter?.presentData(response: .showOffLoadingMessage)
//
//    }
//  }
  
//  private func addDayToFireStore(dayNetwork: DayNetworkModel) {
//
//    self.addService.addDayToFireStore(dayNetworkModel: dayNetwork){result in
//
//      switch result {
//      case .success(let firestoreDayNetwokModel):
//
//        // Если модель nil то дня в базе нет!
//        guard let networkModel = firestoreDayNetwokModel else {
//          return self.passDayRealmToConvertInVMInPresenter()
//        }
//
//        print("Пришел день из FireStore")
//        let (realmDay,compObjs,sugarObjs) = self.convertWorker.convertDayNetworkModelsToRealm(dayNetworkModel: networkModel)
//        // Вообщем происходит бага при создание второго такого же дня! Это из за частых повторений запростов- это надо как то решить
//        self.newDayRealmManager.replaceCurrentDay(replaceDay: realmDay)
//
//
//
//        self.compObjRealmManager.setCompObjsToRealm(compObjs: compObjs)
//        self.sugarRealmManger.setSugarToRealm(sugars: sugarObjs)
//
//      case .failure(let error):
//        print("Some Error",error)
//      }
//
//      self.realTimeLockerFree()
//      self.passDayRealmToConvertInVMInPresenter()
//    }
//
//  }
  
  
  
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






