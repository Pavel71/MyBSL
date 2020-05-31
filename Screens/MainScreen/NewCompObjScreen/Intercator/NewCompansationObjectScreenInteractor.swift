//
//  NewCompansationObjectScreenInteractor.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol NewCompansationObjectScreenBusinessLogic {
  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType)
}

class NewCompansationObjectScreenInteractor: NewCompansationObjectScreenBusinessLogic {
  
  var presenter: NewCompansationObjectScreenPresentationLogic?
  // если приходит Объект для обновления
  var updateCompObj    : CompansationObjectRelam!
  var updateSugarRealm : SugarRealm!
  
  
  // For Work with Realm
  
  var compRealmManager    : CompObjRealmManager!
  var sugarRealmManager   : SugarRealmManager!
  var newDayRealmManager  : NewDayRealmManager!
  
  var insulinSupplyWorker : InsulinSupplyWorker!
  var userDefaultsWorker  : UserDefaultsWorker!
  var convertWorker       : ConvertorWorker!
  
  // For Work wit FireStore
  
  var addService          : AddService!
  var updateService       : UpdateService!
  var deleteService       : DeleteService!
  var butchWritingService : ButchWritingService!
  
  
  init() {
    let locator = ServiceLocator.shared
    
    compRealmManager    = locator.getService()
    sugarRealmManager   = locator.getService()
    newDayRealmManager  = locator.getService()
    
    insulinSupplyWorker = locator.getService()
    userDefaultsWorker  = locator.getService()
    convertWorker       = locator.getService()
    
    
    addService          = locator.getService()
    updateService       = locator.getService()
    deleteService       = locator.getService()
    butchWritingService = locator.getService()

  }

  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    
    catchViewModelRequest(request: request)
    workWithProductList(request: request)
  }
  
}

// MARK: Catch View Model Requests

extension NewCompansationObjectScreenInteractor {
  
  private func catchViewModelRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    switch request {
      
    case .getBlankViewModel:
      presenter?.presentData(response: .getBlankViewModel)
      
    case .updateCompansationObject(let compObjRealm):
      
      // вот здесь мы обновляем его и тут можем сохранить в оперативочку
      
      updateCompObj    = compObjRealm
      updateSugarRealm = sugarRealmManager.fetchSugarByCompansationId(sugarCompObjId: compObjRealm.id)
      
      // можно как вариант заказать здесь sugarRealmкоторый мы будим обновлять! и не композить себе мозг!
      
      presenter?.presentData(response: .convertCompObjRealmToVM(compObjRealm: compObjRealm))
      
    case .passCurrentSugar(let sugar):
      presenter?.presentData(response: .updateCurrentSugarInVM(sugar: sugar))
      
    case .passCopmansationSugarInsulin(let compansatSugarInsulin):
      presenter?.presentData(response: .updateCopmansationSugarInsulin(compInsulin: compansatSugarInsulin))
      
    case .passIsNeedProductList(let isNeed):
      presenter?.presentData(response: .updateAddMealStateInVM(isNeed: isNeed))
      
    case .updatePlaceInjection(let place):
      presenter?.presentData(response: .updatePlaceInjection(place: place))
      
    case .saveCompansationObjectInRealm(let viewModel):
      
      let totalInsulinNow = viewModel.resultFooterVM.totalInsulin

      if updateCompObj != nil && updateSugarRealm != nil {
        
        
        // 1. Обновляем Текущий CompObj
        // 2. Обновляем Текущий Sugar
        // 3. Обновляем Insulin Value
        // 4. Обновляем предыдущий compObj
        
        writeDataToRealmThenUpdateCompObj(viewModel: viewModel, totalInsulinNow: totalInsulinNow)
        
        writeDataToFireStoreThenUpdateCompObj()
         

        self.updateCompObj    = nil
        self.updateSugarRealm = nil

        presenter?.presentData(response: .passSignalToReloadMainScreen)
        
        // Проще отсюда послать сигнал что все обновленно!

      } else {
        // Создаем новые объекте
        let compObj    = convertWorker.convertViewModelToCompObjRealm(viewModel: viewModel)
        let sugarRealm = convertWorker.convertCompObjRealmToSugarRealm(compObj: compObj)
        
        
        writeAllDataToRealmThenAddCompObj(
          compObj      : compObj,
          sugarRealm   : sugarRealm,
          totalInsulin : totalInsulinNow)
        // MARK: Start Ml Learning
        // Пусть эта работа идет в Асинхронном потоке! Так как мы взаимодействуем с Реалмом то можем взять только main.async
        DispatchQueue.main.async {
          // Метод запускающий обучение по данным
          
          self.presenter?.presentData(response: .learnMlForNewData)
          
                  // 1. Добавляем CompObj
                 // 2. Добавляем  Sugar
                 // 3. Обновляем Insulin Value
                 // 4. Обновляем предыдущий compObj
                 // 5. Добавляем id в Day
          
          self.writeDataToFireStoreThenAddCompObj(sugarRealm: sugarRealm, compObj: compObj)
          // Здесь ошибка! Так нельзя делать! У нас есть кейс когда предыдущего дня нет!
          // Без нормальных тестов мне пипец!
          
       
          
        }

        presenter?.presentData(response: .passSignalToReloadMainScreen)
        
      }
      
    default:break
    }
    
  }
  

  
  // MARK: Work With Product List
  
  private func workWithProductList(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    switch request {
      
      
    case .addProductsInProductList(let products):
      
      presenter?.presentData(response: .addProductsInProductListVM(products: products))
      
    case .deleteProductsFromProductList(let products):
      presenter?.presentData(response: .deleteProductsInProductListVM(products: products))
      
      
    case .updatePortionInProduct(let portion, let index):
      
      presenter?.presentData(response: .updatePortionInProduct(portion: portion, index: index))
    case .updateInsulinByPerson(let insulin, let index):
      presenter?.presentData(response: .updateInsulinByPerson(insulin: insulin, index: index))
      
    default:break
    }
    
  }
  
  
}

  // MARK: Realm
extension NewCompansationObjectScreenInteractor {
  
  
  
  // MARK: Add New CompObj
  
  private func writeAllDataToRealmThenAddCompObj(
    compObj: CompansationObjectRelam,sugarRealm : SugarRealm,totalInsulin: Float) {
    
    // Update All Data In Local DB
      
      updatePrevCompObjFromDataInNewCompObj(timeCreate: compObj.timeCreate, sugarAfter: compObj.sugarBefore)
      
      saveCompObjToRealm(compObj      : compObj)
     
      saveSugarToRealm(sugarRealm     : sugarRealm)
      
      newDayRealmManager.addNewCompObjId(compObjId: compObj.id)
      newDayRealmManager.addNewSugarId(sugarId: sugarRealm.id)
      
      insulinSupplyWorker.setNewInsulinSupplyToUserDefaults(
        totalInsulin: totalInsulin,
        updatedType: .add)
    
  }
  
  // MARK: Update CompObj
  
  private func writeDataToRealmThenUpdateCompObj(
    viewModel: NewCompObjViewModel,totalInsulinNow: Float) {
    
    let totalInsulinBefore = updateCompObj.totalInsulin.toFloat()
    
    insulinSupplyWorker.setNewInsulinSupplyToUserDefaults(totalInsulin: totalInsulinBefore - totalInsulinNow, updatedType: .update)
    
    updatingCompObjInRealm(viewModel: viewModel)
    updatingSugarInRealm(updateSugarRealm: updateSugarRealm, updateCompobj: updateCompObj)
    
  }
  
  
  private func updatingSugarInRealm(
    updateSugarRealm: SugarRealm,
    updateCompobj: CompansationObjectRelam) {
    
    sugarRealmManager.updateSugarRealm(
      sugarRealm    : updateSugarRealm,
      chartDataCase : convertWorker.getChartDataCase(compObj: updateCompobj),
      sugar         : updateCompobj.sugarBefore,
      time          : updateCompobj.timeCreate)
    
    
    self.updateSugarRealm = sugarRealmManager.fetchSugarByPrimeryKey(sugarPrimaryKey: updateSugarRealm.id)

  }
  
  private func updatingCompObjInRealm(viewModel: NewCompObjViewModel) {

    let transportTuple = convertWorker.getTransportTuple(viewModel: viewModel)
    
   
    compRealmManager.updateCompObj(
      transportTuple : transportTuple,
      compObjId      : updateCompObj.id)
    
    
    // После обновления и записи в реамл я получу обновленный объект
    updateCompObj = compRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: updateCompObj.id)
  }

  private func saveCompObjToRealm(compObj: CompansationObjectRelam) {

    compRealmManager.addOrUpdateNewCompObj(compObj: compObj)
  }
  
  private func updatePrevCompObjFromDataInNewCompObj(timeCreate: Date,sugarAfter: Double) {
    compRealmManager.updatePrevCompObjWhenAddNew(timeCreateNew: timeCreate, sugarNew: sugarAfter)
  }
  
  private func saveSugarToRealm(sugarRealm: SugarRealm) {
    sugarRealmManager.addOrUpdateNewSugarRealm(sugarRealm: sugarRealm)
  }
}



 // MARK: FireStore
extension NewCompansationObjectScreenInteractor {
  
  private func writeDataToFireStoreThenUpdateCompObj() {
    
    let insulonSupply     = userDefaultsWorker.getInsulinSupply()
    let insulinSupplyData = [UserDefaultsKey.insulinSupplyValue.rawValue : insulonSupply]
    
    let prevCompObj  = compRealmManager.fetchSecondOnTheEndCompObj()

    butchWritingAllDataToFireStoreAfterUpdateCompObj(
      updateCompObjRealm  : updateCompObj,
      updateSugarRealm    : updateSugarRealm,
      userDefaultsData    : insulinSupplyData,
      prevCompObjToUpdate : prevCompObj)
  }
  
  
  
  // MARK: Update CompObj
  
  private func butchWritingAllDataToFireStoreAfterUpdateCompObj(
    updateCompObjRealm  : CompansationObjectRelam,
    updateSugarRealm    : SugarRealm,
    userDefaultsData    : [String: Any],
    prevCompObjToUpdate : CompansationObjectRelam?) {
    
    let compObjNetModel   = convertWorker.convertCompObjRealmToCompObjNetworkModel(compObj: updateCompObjRealm)
    let sugarNetworkModel      = convertWorker.convertToSugarNetworkModel(sugarRealm: updateSugarRealm)
    
    
    
    if let prevComp = prevCompObjToUpdate {
      let prevNetwrok = convertWorker.convertCompObjRealmToCompObjNetworkModel(compObj: prevComp)
      
      butchWritingService.writtingDataAfterUpdatindCompObj(
      sugarNetwrokModel   : sugarNetworkModel,
      compObjNetwrokModel : compObjNetModel,
      userDefaultsData    : userDefaultsData,
      prevCompObj         : prevNetwrok)
      
    } else {
      
      butchWritingService.writtingDataAfterUpdatindCompObj(
      sugarNetwrokModel   : sugarNetworkModel,
      compObjNetwrokModel : compObjNetModel,
      userDefaultsData    : userDefaultsData)
      
    }
    
    
    
    
  }
  
  
  // MARK: Add New COmpObj
  
  
  private func writeDataToFireStoreThenAddCompObj(
    sugarRealm: SugarRealm,compObj:CompansationObjectRelam) {
    
    let prevCompobjToUpdate = self.compRealmManager.fetchSecondOnTheEndCompObj()
    // мне нужно получить день и взять его id
    
    let dayId = self.newDayRealmManager.getCurrentDay().id
    
    let userDefaultsData = self.getUserDefaultsDataToWriteFrieStoreThenAddCompObj()
    
    self.butchWrittingAllDataToFireStoreAfterAddNewCompobj(
      sugarRealm       : sugarRealm,
      compObjRealm     : compObj,
      prevCompObj      : prevCompobjToUpdate,
      updateDayID      : dayId,
      userDefaultsData : userDefaultsData)
  }
  
  private func butchWrittingAllDataToFireStoreAfterAddNewCompobj(
    sugarRealm         : SugarRealm,
    compObjRealm       : CompansationObjectRelam,
    prevCompObj        : CompansationObjectRelam?,
    updateDayID        : String,
    userDefaultsData   : [String: Any]) {
    
    let compObjNetModel   = convertWorker.convertCompObjRealmToCompObjNetworkModel(compObj:compObjRealm)
    let sugarNetworkModel = convertWorker.convertToSugarNetworkModel(sugarRealm: sugarRealm)

    
    
    
    if let prevComp = prevCompObj {
      let prevNetwrok = convertWorker.convertCompObjRealmToCompObjNetworkModel(compObj: prevComp)
      
      butchWritingService.writtingDataAfterAddNewCompObj(
        sugarNetwrokModel       : sugarNetworkModel,
        compObjNetwrokModel     : compObjNetModel,
        prevCompObjNetwrokModel : prevNetwrok,
        userDefaultsData        : userDefaultsData,
        updateDayID             : updateDayID)

      
    } else {
      
      butchWritingService.writtingDataAfterAddNewCompObj(
        sugarNetwrokModel       : sugarNetworkModel,
        compObjNetwrokModel     : compObjNetModel,
        userDefaultsData        : userDefaultsData,
        updateDayID             : updateDayID)
    }
    
    
    // Тут нужно извлечь веса для коррекции сахар + веса для коррекции инсулина + инсулин supply

    
  }
  
  private func getUserDefaultsDataToWriteFrieStoreThenAddCompObj() -> [String: Any]{
    
    let insulinSupplyValue = userDefaultsWorker.getInsulinSupply()
    let sugarsWeights      = userDefaultsWorker.getArrayData(typeDataKey: .correctSugarByInsulinWeights)
    let carboWeights       = userDefaultsWorker.getArrayData(typeDataKey: .correctSugarByInsulinWeights)
    
    let userDefaultsData:[String: Any] = [
      UserDefaultsKey.correctCarboByInsulinWeights.rawValue : carboWeights,
      UserDefaultsKey.correctSugarByInsulinWeights.rawValue : sugarsWeights,
      UserDefaultsKey.insulinSupplyValue.rawValue           : insulinSupplyValue
    ]
    return userDefaultsData
  }
  
}











