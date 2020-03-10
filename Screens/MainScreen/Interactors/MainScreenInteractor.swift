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
  
  private func passDayRealmToConvertInVMInPresenter(dayRealm: DayRealm) {
     presenter?.presentData(response: .prepareViewModel(realmData: dayRealm))
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
      guard let updateDay = dayRealmManager.getCurrentDay() else {
        return print("Нет Current Day")}

      passDayRealmToConvertInVMInPresenter(dayRealm: updateDay)
      // Просто передаю модель
      
      
    case .setCompansationObjVM(let viewModel):
      
      let compansationObjRealm = convertToCompansationObjRealm(viewModel: viewModel)
      
      // потом добавить в день
      
      // потом получить новый день
      
      // потом отравить его на главный контроолер
      
      // и все добавление будет работать!
      
    default:break
    }
    
    
    
  }
  
 
}


// MARK: Work With VIew Model

extension MainScreenInteractor {
  
  private func catchViewModelRequests(request: MainScreen.Model.Request.RequestType) {
    
    switch request {
    case .getViewModel:
      print("Нужно загрузить данные из реалма!")
//      let data = dayRealmManager.getDummyRealmData()
      let blankDay = dayRealmManager.getBlankDayObject()
      
      passDayRealmToConvertInVMInPresenter(dayRealm: blankDay)
      
    default:break
    }
  }
}

// MARK: Convert ViewModels to RealmObjects
extension MainScreenInteractor {
  
  private func convertToSugarRealm(sugarVM: SugarViewModel) -> SugarRealm {
    
    
    
    return SugarRealm(
      time: sugarVM.time,
      sugar: sugarVM.sugar,
      dataCase: sugarVM.dataCase,
      compansationObjectId: sugarVM.compansationObjectId)
  }
  
  
  private func convertToCompansationObjRealm(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {
    
    // итак я тут имею 2 модели sugar  and Meal Model
    
    let sugarRealm        = prepareSugarVM(viewModel: viewModel)
    
    let compansationRealm = prepareCompansationObj(viewModel: viewModel)
  }
  
}

// MARK: Work WIth CompansationObject Realm
extension MainScreenInteractor {
  
  
  private func prepareSugarVM(viewModel: NewCompObjViewModel) -> SugarRealm? {
    
    
    guard let sugar = viewModel.sugarCellVM.currentSugar else {return nil}
    
    var dataCase: ChartDataCase
    
    switch viewModel.sugarCellVM.sugarState {
    case .correctDown:
      dataCase = .correctInsulinData
    case .correctUp:
      dataCase = .correctCarboData
    
    default:
      dataCase = .mealData
    }
    
    return SugarRealm(
      time     : Date(),
      sugar    : Double(sugar),
      dataCase : dataCase ,
      compansationObjectId: "a")
  }
  
  
  
  private func prepareCompansationObj(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {
    
    // Мне вообщем нужно все это обдумать и написать более точно Возможно стоит собрать модель Транспортную которая и будет содержать все бе все необходимы объекты! Сейчас доставвать все из этой модели не очнеь удобно!
    
    
    viewModel.resultFooterVM
    
    // Мне нужно поле тип объекта
    // Нужно общее поле Сахар
    // Нужно поле Общая дозировка инсулина
    // Нужно поле общее кол-во карбо
    
    // По типу объекта я буду создавать либо это с продуктами либо это коррекция высокого сахара!
    
    let compansationObjectRealm = CompansationObjectRelam(
      typeObject: ,
    sugarBefore: <#T##Double#>,
    totalCarbo: <#T##Double#>,
    totalInsulin: <#T##Double#>)
    
    return compansationObjectRealm
  }
  
}

