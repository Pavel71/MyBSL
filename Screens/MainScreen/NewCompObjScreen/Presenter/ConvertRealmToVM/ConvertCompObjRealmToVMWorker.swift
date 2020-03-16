//
//  ConvertCompObjRealmToVMWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.03.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Class Отвечает за преобразование объекта из CompObjRealm to NewCompVM


final class ConvertCompObjRealmToVMWorker {
  
  // Нужно прописать всю логику заполнения модели из реалм объекта и все Остальное должно работать сразу же!
  
  static func convertCompObjRealmToVM(compObjRealm:CompansationObjectRelam) -> NewCompObjViewModel {
    
    let sugarCellVM      = convertToSugarCellVM(sugarBefore: String(compObjRealm.sugarBefore))
    let addMealCellModel = convertToAddMealCellModel(compObjRealm: compObjRealm)
    let injectionCellVM  = convertToInjectionVM(compObjRealm: compObjRealm)
    
    let resultFooterVM   = convertToResultFooterModel(compObjRealm: compObjRealm)
    
    return NewCompObjViewModel(
      isUpdated               : true,
      updatedId               : compObjRealm.id,
      sugarCellVM             : sugarCellVM,
      addMealCellVM           : addMealCellModel,
      injectionCellVM         : injectionCellVM,
      resultFooterVM          : resultFooterVM,
      isValidData             : true)
  }
  
  

 
  
}


// MARK: Convert to Sugar VM
extension ConvertCompObjRealmToVMWorker {
  private static func convertToSugarCellVM(sugarBefore:String) -> SugarCellModel {
    
    
    return SugarCellVMWorker.getSugarVM(sugar: sugarBefore)

  }
}

// MARK: Convert to AddMeal VM
extension ConvertCompObjRealmToVMWorker {
  
   
   private static func convertToAddMealCellModel(compObjRealm:CompansationObjectRelam) -> AddMealCellModel {
     
     let isSwitcherIsEnabled = compObjRealm.listProduct.isEmpty == false
     let cellState:AddMealCellState = isSwitcherIsEnabled ? .productListState : .defaultState
     
    let resultVM = getResultVM(compObjRealm:compObjRealm )
    
    let productRealm: [ProductListViewModel] = compObjRealm.listProduct.map(getProductListVM)
     
     let dinnerProductListVm = ProductListInDinnerViewModel(
       resultsViewModel : resultVM,
       productsData     : productRealm)
     
     return AddMealCellModel(
       isSwitcherIsEnabled : isSwitcherIsEnabled,
       cellState           : cellState,
       dinnerProductListVM : dinnerProductListVm)
   }
  
  
  private static func getResultVM(compObjRealm:CompansationObjectRelam) -> ProductListResultsViewModel {
    
      let resultPortion = compObjRealm.listProduct.map{$0.portion}.reduce(0, +)
      let resultCarbo   = compObjRealm.listProduct.map{$0.carboInPortion}.reduce(0, +)
      let resultInsulin = compObjRealm.listProduct.map{$0.actualInsulin}.reduce(0, +)
      
      return ProductListResultsViewModel(
        sumCarboValue   : String(resultCarbo),
        sumPortionValue : String(resultPortion),
        sumInsulinValue : String(resultInsulin))
  }
  
  private static func getProductListVM(productRealm: ProductRealm) -> ProductListViewModel {
    
    return ProductListViewModel(
      correctInsulinValue : productRealm.actualInsulin,
      insulinValue        : productRealm.actualInsulin,
      isFavorit           : productRealm.isFavorits,
      carboIn100Grm       : productRealm.carboIn100grm,
      category            : productRealm.category,
      name                : productRealm.name,
      portion             : productRealm.portion)
  }
}


// MARK: Convert To Injection Place
extension  ConvertCompObjRealmToVMWorker {
  
  private static func convertToInjectionVM(compObjRealm:CompansationObjectRelam) -> InjectionPlaceModel {
    
    let injectionCellState: InjectionPlaceCellState = compObjRealm.listProduct.isEmpty ? .hidden : .showed
    
    return InjectionPlaceModel(cellState: injectionCellState, titlePlace: "Some")
  }
}

// MARK: Convert To ResultFooterModel

extension  ConvertCompObjRealmToVMWorker {
  
  
  private static func convertToResultFooterModel(compObjRealm:CompansationObjectRelam) -> ResultFooterModel {
    
    let resultMessage = getresultMessage(resultInsulin: compObjRealm.totalInsulin)
    let totalInsulinValue = String(compObjRealm.totalInsulin)
    let resultViewState: ResultFooterViewState   = .showed
    let typeObject                               = compObjRealm.typeObjectEnum
    
    return ResultFooterModel(
    message                : resultMessage,
    totalInsulinValue      : totalInsulinValue,
    viewState              : resultViewState,
    typeCompansationObject : typeObject)
  }
  
  
  private static func getresultMessage(resultInsulin: Double) -> String {
    var message : String
    
    if resultInsulin < 0.0 {
      message = "Добавьте продукт"
    } else if resultInsulin == 0.0 {
      message = "Все норм"
    } else {
      message = "Инсулина"
    }
    return message
  }
}
