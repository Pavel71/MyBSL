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
  var updateCompObj: CompansationObjectRelam!
  
  
  // For Work with Realm
  
  var compRealmManager  = CompObjRealmManager.shared
  var sugarRealmManager = SugarRealmManager.shared

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
      
      updateCompObj = compObjRealm
      
      presenter?.presentData(response: .convertCompObjRealmToVM(compObjRealm: compObjRealm))
      
    case .passCurrentSugar(let sugar):
      presenter?.presentData(response: .updateCurrentSugarInVM(sugar: sugar))
      
    case .passIsNeedProductList(let isNeed):
      presenter?.presentData(response: .updateAddMealStateInVM(isNeed: isNeed))
      
    case .updatePlaceInjection(let place):
      presenter?.presentData(response: .updatePlaceInjection(place: place))
      
    case .saveCompansationObjectInRealm(let viewModel):
      
      
      // Пришла модель с обнволенными данными!
      // Мы должны проверить что у нас туту Новый объект или Update?
      

      if updateCompObj != nil {
        
        print("Update")
        
        updatingCompObj(viewModel: viewModel)
        updatingSugarRealm(compObj: updateCompObj)
        
        
        self.updateCompObj = nil
        
        presenter?.presentData(response: .updateSugarRealmAndCompObjSucsess)
        
        // Проще отсюда послать сигнал что все обновленно!

      } else {
        // Создаем новые объекте
        let compObj    = convertViewModelToCompObjRealm(viewModel: viewModel)
        let sugarRealm = convertModelToSugarRealm(compObj: compObj)
        saveCompObjToRealm(compObj  : compObj)
        saveSugarToRealm(sugarRealm : sugarRealm)
        
        // MARK: Start Ml Learning
        // Пусть эта работа идет в Асинхронном потоке! Так как мы взаимодействуем с Реалмом то можем взять только main.async
        DispatchQueue.main.async {
          // Метод запускающий обучение по данным
          
          self.presenter?.presentData(response: .learnMlForNewData)
          
        }
        
        
        
        presenter?.presentData(response: .passCompObjIdAndSugarRealmIdToVC(compObjId: compObj.id, sugarRealmId: sugarRealm.id))
        
      }
      

      
    default:break
    }
    
  }
  
  
  
  
  
  // MARK: Save Data to Realm
  private func saveCompObjToRealm(compObj: CompansationObjectRelam) {

    compRealmManager.addOrUpdateNewCompObj(compObj: compObj)
  }
  
  private func saveSugarToRealm(sugarRealm: SugarRealm) {
    sugarRealmManager.addOrUpdateNewSugarRealm(sugarRealm: sugarRealm)
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

// MARK: Update CurrentObjects

extension NewCompansationObjectScreenInteractor {
  
  typealias TransportTuple = (sugarBefore: Double, typeObjectEnum: TypeCompansationObject, insulinCarbo: Double, insulinCorrect: Double, totalCarbo: Double, placeInjections: String, productsRealm: [ProductRealm])
  
  
  // MARK: Get Transport Tuple
  private func getTransportTuple(viewModel: NewCompObjViewModel) -> TransportTuple {
    
    let sugarBefore  = Double(viewModel.sugarCellVM.currentSugar!).roundToDecimal(2)
    let typeObject   = viewModel.resultFooterVM.typeCompansationObject
    //    let totalInsulin = Double(viewModel.resultFooterVM.totalInsulin).roundToDecimal(2)
    let insulinCarbo = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumInsulinFloat).roundToDecimal(2)
    let insulinCorrect = Double(viewModel.sugarCellVM.correctionSugarKoeff ?? 0).roundToDecimal(2)
    let totalCarbo   = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumCarboFloat).roundToDecimal(2)
    let placeInjections = viewModel.injectionCellVM.titlePlace
    
    let productsVM = viewModel.addMealCellVM.dinnerProductListVM.productsData
    
    let productsRealm = productsVM.map(converToProductRealm)
    
    // Set Total Carbo in Products
    productsRealm.forEach { (product) in
      product.setPercentageCarboInMeal = totalCarbo
    }
    
    
    let transportTuple:TransportTuple = (
                          sugarBefore     : sugarBefore,
                          typeObjectEnum  : typeObject,
                          insulinCarbo    : insulinCarbo,
                          insulinCorrect  : insulinCorrect,
                          totalCarbo      : totalCarbo,
                          placeInjections : placeInjections,
                          productsRealm   : productsRealm)
    return transportTuple
  }
  
  private func updatingSugarRealm(compObj: CompansationObjectRelam) {
    
    SugarRealmManager.shared.updateSugarRealmByCompObj(compObj: compObj)

  }
  
  private func updatingCompObj(viewModel: NewCompObjViewModel) {

    let transportTuple = getTransportTuple(viewModel: viewModel)
    
   
    compRealmManager.updateCompObj(
      transportTuple : transportTuple,
      compObjId      : updateCompObj.id)
    
    // После обновления и записи в реамл я получу обновленный объект
    updateCompObj = compRealmManager.fetchCompObjByPrimeryKey(compObjPrimaryKey: updateCompObj.id)
  }
  
}


// MARK: Convert To RealmCompansationObj

extension NewCompansationObjectScreenInteractor {

  
  
  private func convertViewModelToCompObjRealm(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {

    
    let transportTuple = getTransportTuple(viewModel: viewModel)
    
    
    let compansationObjectRealm = CompansationObjectRelam(
      typeObject                  : transportTuple.typeObjectEnum,
      sugarBefore                 : transportTuple.sugarBefore,
      insulinOnTotalCarbo         : transportTuple.insulinCarbo,
      insulinInCorrectionSugar    : transportTuple.insulinCorrect,
      totalCarbo                  : transportTuple.totalCarbo,
      placeInjections             : transportTuple.placeInjections)

    
    compansationObjectRealm.listProduct.append(objectsIn: transportTuple.productsRealm)
    
 
    
    return compansationObjectRealm
    
    
  }
  
  
  
  
  
  private func converToProductRealm(viewModel: ProductListViewModel) -> ProductRealm {
    
    
    // просто сюда нужно передать общее кол-во углеводов в обеде! и все будет нормально
    return ProductRealm(
      name                  : viewModel.name,
      category              : viewModel.category,
      carboIn100Grm         : viewModel.carboIn100Grm,
      isFavorits            : viewModel.isFavorit,
      portion               : viewModel.portion ,
      actualInsulin         : viewModel.insulinValue!.roundToDecimal(2))
  }
  
}

// MARK: Convert Model to SugarRealm

extension NewCompansationObjectScreenInteractor {
  
  func convertModelToSugarRealm(compObj: CompansationObjectRelam) -> SugarRealm {
    
    let sugar = compObj.sugarBefore
    
    let dataCase = getChartDataCase(compObj: compObj)
    
    return SugarRealm(
      time                 : Date(),
      sugar                : sugar.roundToDecimal(2),
      dataCase             : dataCase ,
      compansationObjectId : compObj.id)
  }
  
  private func getChartDataCase(compObj: CompansationObjectRelam) -> ChartDataCase {
    
    // Будет возвращать что у нас обед всегда когда есть обед
    guard compObj.listProduct.isEmpty else {return .mealData}
    
    switch compObj.correctSugarPosition {
      
    case .correctDown:
      return .correctInsulinData
    case .correctUp:
      return .correctCarboData
      
    default:
      return .sugarData
    }

  }
  
  
}









