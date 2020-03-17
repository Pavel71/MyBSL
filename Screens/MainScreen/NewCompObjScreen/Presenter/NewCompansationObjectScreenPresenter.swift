//
//  NewCompansationObjectScreenPresenter.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol NewCompansationObjectScreenPresentationLogic {
  func presentData(response: NewCompansationObjectScreen.Model.Response.ResponseType)
}

class NewCompansationObjectScreenPresenter: NewCompansationObjectScreenPresentationLogic {
  
  weak var viewController: NewCompansationObjectScreenDisplayLogic?
  
  
  // Флаг будет братся из настроек юзера
  
  var isAutoCalculateInsulin = true
  // ViewModel
  private var viewModel: NewCompObjViewModel!
  
  private var mlWorkerByCorrection = MLWorker(typeWeights: .correctionSugar)
  private var mlWorkerByFood       = MLWorker(typeWeights: .insulinByFood)
  
  func presentData(response: NewCompansationObjectScreen.Model.Response.ResponseType) {
    
    catchViewModelResponse(response: response)
    workWithProductListRequest(response: response)
  }
  
  
  
}

// MARK: Catch View Model Requests
extension NewCompansationObjectScreenPresenter {
  
  
  private func catchViewModelResponse(response: NewCompansationObjectScreen.Model.Response.ResponseType) {
    
    switch response {
      
      case .getBlankViewModel:
        
        viewModel = getBlankViewModel()
        
        throwViewModelToVC()
      
      case .convertCompObjRealmToVM(let compObjRealm):
        
        viewModel = convertCompObjRealmToVM(compObjRealm:compObjRealm)
        throwViewModelToVC()
      
      case .updateCurrentSugarInVM(let sugar):
        
        setSugarData(sugar: sugar)
       
        throwViewModelToVC()
        
      case .updateAddMealStateInVM(let isNeed):
        updateMealCellState(isNeed: isNeed)
        
        throwViewModelToVC()
        
      case .updatePlaceInjection(let place):
        updatePlaceInjectionInVM(place: place)
        throwViewModelToVC()
        
      case .passCompansationObjRealmToVC(let compObjRealm):
        viewController?.displayData(viewModel: .passCompansationObjRealmtToMainViewController(compObjRealm: compObjRealm))
      
    default:break
    }
  }
  
  // MARK: Work With Product List Requests
  
  private func workWithProductListRequest(response: NewCompansationObjectScreen.Model.Response.ResponseType) {
    
    switch response {

      
        // Добавить продукты
      case .addProductsInProductListVM(let products):
        
        addProductsInVM(products: products)
        
        throwViewModelToVC()
        // Удалить продукты
      case .deleteProductsInProductListVM(let products):
        
        deleteProductsFromVM(products: products)
        
        throwViewModelToVC()
      
      // Обновить Порцию
    case .updatePortionInProduct(let portion, let index):
      // Здесь нам нужно не только обновить но сделать предсказание инсулина!
      
      updatePortionField(portion: portion, index: index)
      throwViewModelToVC()
      
    case .updateInsulinByPerson(let insulin, let index):
      updateInsulinField(insulinValue: insulin, index: index)
      throwViewModelToVC()
      
    default:break
    }
    
  }
  
  private func throwViewModelToVC() {
    
    viewController?.displayData(viewModel: .setViewModel(viewModel: viewModel))
  }
  
}


// MARK: Convert CompObjRealmToVM

extension NewCompansationObjectScreenPresenter {
  
  private func convertCompObjRealmToVM(compObjRealm:CompansationObjectRelam) -> NewCompObjViewModel {
    
    
    let viewModel = ConvertCompObjRealmToVMWorker.convertCompObjRealmToVM(compObjRealm: compObjRealm)

    
    return viewModel
    
  }
  
}


// MARK: Woek With Sugar VM
extension NewCompansationObjectScreenPresenter {
  
  private func setSugarData(sugar: String) {
      
     viewModel.sugarCellVM = SugarCellVMWorker.getSugarVM(sugar: sugar)
     updateMeallCellSwitcherEnabled(isEnabled: !sugar.isEmpty)
    
    if sugar.isEmpty { // Если поле сахара пустое то и убираем обед! так как без сахара нельзя
      updateMealCellState(isNeed: false)
      updateEnabledSaveButton(isEnabled: false)
    }
    
    
    switch viewModel.sugarCellVM.cellState {
    case .currentLayerAndCorrectionLabel:
      // Сюда попадаем если сахар в норме!
      
      if viewModel.addMealCellVM.cellState == .productListState {
        
        updateEnabledSaveButton(isEnabled: viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false)
      } else {
        
        updateEnabledSaveButton(isEnabled: false)
      }
      
    case .currentLayerAndCorrectionLayer:
      
      // Сюда попоадаем если у нас сахар в не нормы!
      
      let predictSugarCompansation = mlWorkerByCorrection.getPredict(testData: [Float(viewModel.sugarCellVM.currentSugar!)])
      
      viewModel.sugarCellVM.correctionSugarKoeff = predictSugarCompansation.first!
      
      if viewModel.addMealCellVM.cellState == .productListState {
        
        updateEnabledSaveButton(isEnabled: viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false)
      } else {
        
        updateEnabledSaveButton(isEnabled: true)
      }
    default:break
    }

    updateResultViewModel()
    setInjectionCellState()
  }
  
  
}

// MARK: Work With InjectionCellVM
extension NewCompansationObjectScreenPresenter {
  
  private func setInjectionCellState() {
    // Если показываем обеды или сахар завышен то в этом случае покажи ячейку с местом укола
    
    let injectionCellState : InjectionPlaceCellState = viewModel.addMealCellVM.cellState == .productListState || viewModel.sugarCellVM.cellState == .currentLayerAndCorrectionLayer ? .showed : .hidden
    viewModel.injectionCellVM.cellState = injectionCellState
  }
  
  private func updatePlaceInjectionInVM(place: String) {
    
    viewModel.injectionCellVM.titlePlace = place
  }
  
}





// MARK: Work With ProductListVM

extension NewCompansationObjectScreenPresenter {
  
  
  private func updateMeallCellSwitcherEnabled(isEnabled: Bool) {
    viewModel.addMealCellVM.isSwitcherIsEnabled = isEnabled
  }
  
  private func updateMealCellState(isNeed: Bool) {
//    AddMealVMWorker.changeNeedProductList(isNeed: isNeed, viewModel: &viewModel)
    
    viewModel.addMealCellVM.cellState = isNeed ? .productListState : .defaultState
       
    if isNeed == false {
      // если обед не нужен то очистим все продукты
      viewModel.addMealCellVM.dinnerProductListVM.productsData.removeAll()
      calculateResultViewModelInProductList()
    }
    
    if viewModel.addMealCellVM.cellState == .productListState {
      updateEnabledSaveButton(isEnabled: viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false)
    } else {
      
      let isSugarCorrectCopm = viewModel.sugarCellVM.cellState == .currentLayerAndCorrectionLayer
      
      updateEnabledSaveButton(isEnabled: isSugarCorrectCopm)
    }

    updateResultViewModel()
    setInjectionCellState()
  }
  
  private func convertProductRealmToProductListVMData(product:ProductRealm) -> ProductListViewModel {
    
    
    let insulinValue = isAutoCalculateInsulin ? mlWorkerByFood.getPredict(testData: [product.carboInPortion]).first! : nil
    
    // ПО сути здесь уже мы можем сделать первый расчет! Но это пока не особо важно!
      
    return ProductListViewModel(
      correctInsulinValue : nil,
      insulinValue        : insulinValue,
      isFavorit           : product.isFavorits,
      carboIn100Grm       : product.carboIn100grm,
      category            : product.category,
      name                : product.name,
      portion             : product.portion)
  }
  
  
  private func addProductsInVM(products:[ProductRealm]) {
    
    let productsVM = products.map(convertProductRealmToProductListVMData)
    
    viewModel.addMealCellVM.dinnerProductListVM.productsData.insert(
          contentsOf:productsVM,
          at: 0)
    // Пересчитываем резалт
    calculateResultViewModelInProductList()
    
  }
  
  // Delete
  
  private func deleteProductsFromVM(products:[ProductRealm]) {
    
    let newData = products.map(convertProductRealmToProductListVMData)
    
    viewModel.addMealCellVM.dinnerProductListVM.productsData
      .removeAll(where: { newData.contains($0) })
    // пересчитываем резалт
    calculateResultViewModelInProductList()
    
  }
  
  private func updateInsulinField(insulinValue: Float, index: Int) {
    viewModel.addMealCellVM.dinnerProductListVM.productsData[index].insulinValue = insulinValue
    calculateResultViewModelInProductList()
  }
  
  // Update Portion
  
  private func updatePortionField(portion: Int, index: Int) {
    
    viewModel.addMealCellVM.dinnerProductListVM.productsData[index].portion = portion
    
    if isAutoCalculateInsulin {
      getPredictUnsulinByProduct(index: index)
    }
    
    calculateResultViewModelInProductList()
  }
  
  private func getPredictUnsulinByProduct(index: Int) {
     let testData = viewModel.addMealCellVM.dinnerProductListVM.productsData[index].carboInPortion
      let predictInsulin = mlWorkerByFood.getPredict(testData: [Float(testData)])
     
     viewModel.addMealCellVM.dinnerProductListVM.productsData[index].insulinValue = predictInsulin.first
     
  }
    
 
    
    
  
  
  
  // MARK: Calculate Results ProductList In Dinner

  // When add New Product or delete we should calculate Again

    
    private func calculateResultViewModelInProductList() {
      
      let productsData = viewModel.addMealCellVM.dinnerProductListVM.productsData
      
      let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
      
      // Set
      viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel = resultViewModel
//      resultStateByMealState()
      updateResultViewModel()
      // Каждый раз как пересчитывается резалт по обеду! Чекай кнопочку сохранить
      // Здесь нужно добавить логику того что если кнопочка
      
      // При перерасчете мы должны видеть хотябы 1 продукт
      
      if viewModel.sugarCellVM.cellState == .currentLayerAndCorrectionLayer {
        
        let isActivateMeal  = viewModel.addMealCellVM.cellState == .productListState
        let isEmptyproducts = viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false
        updateEnabledSaveButton(isEnabled: isActivateMeal && isEmptyproducts)
        
        
      } else {
        updateEnabledSaveButton(isEnabled: viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false)
      }
      
      
      
    }
  
  // MARK: WOrk With Save Button
  private func updateEnabledSaveButton(isEnabled: Bool) {
    
    viewModel.isValidData = isEnabled
  }
    
    
    
}


// MARK: Work With Result View Model

extension NewCompansationObjectScreenPresenter {
  
  private func updateResultViewModel() {
    
    // Возможно сообщение нужно формировать исходя из того какую дозировку инсулина мы получаем на выходе!

    resultStateBySugarState()
    

    
  }
  
  
  private func resultStateBySugarState() {
    
    let sugarState = viewModel.sugarCellVM.sugarState
    
    switch sugarState {
      
    case .dontCorrect:
      
      viewModel.resultFooterVM.viewState = .hidden
      resultStateByMealState()
      
    case .correctUp:
      

      let resultInsulin = getTotalInsulin()
      
      let message = getresultMessage(resultInsulin: resultInsulin)
      
      viewModel.resultFooterVM.viewState = .showed
      viewModel.resultFooterVM.message   = message
      viewModel.resultFooterVM.totalInsulinValue     = "\(floatTwo: getTotalInsulin())"
      
      
      
    case .correctDown:
      
      viewModel.resultFooterVM.viewState = .showed
      viewModel.resultFooterVM.message   = "Инсулина"
      viewModel.resultFooterVM.totalInsulinValue     = "\(floatTwo: getTotalInsulin())"
      
      
      
    default:break
    }
  }
  
  private func resultStateByMealState() {
    
    let mealState  = viewModel.addMealCellVM.cellState
    
    switch mealState {
      
    case .defaultState:
      
      viewModel.resultFooterVM.viewState = .hidden
      
    case .productListState:
      
      let resultInsulin = getTotalInsulin()
      let message = getresultMessage(resultInsulin: resultInsulin)

      viewModel.resultFooterVM.viewState = .showed
      viewModel.resultFooterVM.message   = message
      viewModel.resultFooterVM.totalInsulinValue     = "\(floatTwo: resultInsulin)"
    }
  }
  
  
  private func getresultMessage(resultInsulin: Float) -> String {
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
  

  
  private func getTotalInsulin() -> Float {
    
    let compansationBySugarInsulin = viewModel.sugarCellVM.correctionSugarKoeff ?? 0
    let compasationByCarboInsulin  = (viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumInsulinValue as NSString).floatValue
    
    return  compansationBySugarInsulin + compasationByCarboInsulin
  }
  
}


//MARK: Get Blank ViewModel

extension NewCompansationObjectScreenPresenter {
  
  private func getBlankViewModel() -> NewCompObjViewModel {
    
    let sugarCellVM     = getDefaultSugarCellVM()
    let addMealCellVM   = getDefaultAddmealCellVM()
    let injectionCellVM = getDefaultInjectionCellVM()
    let resultFooterVM  = getDefaultResultFooterVM()
    
    return NewCompObjViewModel(
      isUpdated         : false,
      updatedId         : "",
      sugarCellVM       : sugarCellVM,
      addMealCellVM     : addMealCellVM,
      injectionCellVM   : injectionCellVM,
      resultFooterVM    : resultFooterVM,
      isValidData       : false)
  }
  
  private func getDefaultResultFooterVM() -> ResultFooterModel {
    
    return ResultFooterModel(
      message                : "",
      totalInsulinValue                  : "",
      viewState              : .hidden,
      typeCompansationObject : .mealObject  )
  }
  
  private func getDefaultInjectionCellVM() -> InjectionPlaceModel {
     let injectionCellVM = InjectionPlaceModel(
      cellState: .hidden,
      titlePlace: "")
    
    return injectionCellVM
  }
  
  private func getDefaultAddmealCellVM() -> AddMealCellModel {
    
//    let productListVM = NewProductListViewModel(
//      cells: [])
    let resultBalnk = ProductListResultsViewModel(sumCarboValue: "", sumPortionValue: "", sumInsulinValue: "")
    
    let dinnerProductList = ProductListInDinnerViewModel(
      resultsViewModel: resultBalnk,
      productsData: [])
    
    return AddMealCellModel(cellState           : .defaultState,
                            dinnerProductListVM : dinnerProductList)
  }
  
  private func getDefaultSugarCellVM() -> SugarCellModel {
    
    return SugarCellModel()
  }
  
  
  
  
  
}


