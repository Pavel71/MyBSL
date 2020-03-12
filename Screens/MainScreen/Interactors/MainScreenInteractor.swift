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
      
    
      
      let sugarRealm = prepareSugarVM(viewModel: compObjRealm)
      // Теперь нам уже приходит Compansation Object теперь его нужно слегка перебрать здесь
      
      // потом добавить в день
      dayRealmManager.addSugarData(sugarRealm: sugarRealm)
      dayRealmManager.addCompansationObjectData(currentCompObj: compObjRealm)
      // потом получить новый день
      
      
      
      // потом отравить его на главный контроолер
      passDayRealmToConvertInVMInPresenter()
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
      dayRealmManager.getBlankDayObject()
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
  
  
//  private func convertToCompansationObjRealm(viewModel: CompansationObjectRelam) -> (CompansationObjectRelam,SugarRealm) {
//
//    // итак я тут имею 2 модели sugar  and Meal Model
//
//
////    let compansationRealm = prepareCompansationObj(viewModel: viewModel)
//    let sugarRealm        = prepareSugarVM(viewModel: viewModel, mealId: compansationRealm.id)
//
//
//    return (viewModel,sugarRealm)
//
//
//
//  }
  
}

// MARK: Work WIth CompansationObject Realm
extension MainScreenInteractor {
  
  
  private func prepareSugarVM(viewModel: CompansationObjectRelam) -> SugarRealm {
    
    
    let sugar = viewModel.sugarBefore
    
    
    var dataCase: ChartDataCase
    
    switch viewModel.correctionPositionObject {
    case .correctDown:
      dataCase = .correctInsulinData
    case .correctUp:
      dataCase = .correctCarboData
    
    default:
      dataCase = .mealData
    }
    
    return SugarRealm(
      time                 : Date(),
      sugar                : sugar.roundToDecimal(2),
      dataCase             : dataCase ,
      compansationObjectId : viewModel.id)
  }
  
  
  
//  private func prepareCompansationObj(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {
//    
//    // Мне вообщем нужно все это обдумать и написать более точно Возможно стоит собрать модель Транспортную которая и будет содержать все бе все необходимы объекты! Сейчас доставвать все из этой модели не очнеь удобно!
//    
//    let sugarBefore  = Double(viewModel.sugarCellVM.currentSugar!).roundToDecimal(2)
//    let typeObject   = viewModel.resultFooterVM.typeCompansationObject
//    let totalInsulin = Double(viewModel.resultFooterVM.totalInsulin).roundToDecimal(2)
//    let totalCarbo   = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumCarboFloat).roundToDecimal(2)
//    
//    print(totalInsulin, "Total Insulin")
//    print(totalCarbo, "Total Carbo")
//    
//    
//    
//    let compansationObjectRealm = CompansationObjectRelam(
//      typeObject   : typeObject,
//      sugarBefore  : sugarBefore,
//      totalCarbo   : totalCarbo,
//      totalInsulin : totalInsulin)
//    
//    
//    // тут мне теперь нужна трансформация realmProduct
//    let productsVM = viewModel.addMealCellVM.dinnerProductListVM.productsData
//    
//    compansationObjectRealm.listProduct.append(objectsIn: productsVM.map(converToProductRealm))
//    
//    return compansationObjectRealm
//  }
//  
//  
//  private func converToProductRealm(viewModel: ProductListViewModel) -> ProductRealm {
//    
//    
//    
//    return ProductRealm(
//      name          : viewModel.name,
//      category      : viewModel.category,
//      carboIn100Grm : viewModel.carboIn100Grm,
//      isFavorits    : viewModel.isFavorit,
//      portion       : viewModel.portion ,
//      actualInsulin : viewModel.insulinValue!.roundToDecimal(2))
//  }
  
}

