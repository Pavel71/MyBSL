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
      
     SugarCellVMWorker.updateCurrentSugarVM(sugar: sugar, viewModel: &viewModel)
     updateMeallCellSwitcherEnabled(isEnabled: !sugar.isEmpty)
    
    if sugar.isEmpty { // Если поле сахара пустое то и убираем обед! так как без сахара нельзя
      updateMealCellState(isNeed: false)
      updateEnabledSaveButton(isEnabled: false)
    }

    // Сахар выше нормы мы должны его компенсировать
    if viewModel.sugarCellVM.cellState == .currentLayerAndCorrectionLayer {
      
      let predictSugarCompansation = mlWorkerByCorrection.getPredict(testData: [Float(viewModel.sugarCellVM.currentSugar!)])
      
      viewModel.sugarCellVM.correctionSugarKoeff = predictSugarCompansation.first!
      // Значит будет укол добавляем поле
      
    }
    updateEnabledSaveButton(isEnabled: viewModel.sugarCellVM.sugarState == .correctDown)
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
    AddMealVMWorker.changeNeedProductList(isNeed: isNeed, viewModel: &viewModel)

    calculateResultViewModelInProductList() // пересчитыаем результат и обновляем Футер
    
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
      
      if viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false {
        
        
        updateEnabledSaveButton(isEnabled: true)
      } else {
        // нужно сделать проверку на то что мы можем сохранить только если мы делаем коррекцию Высокого сахара
        let sugarFiedlIsEmpty = viewModel.sugarCellVM.sugarState == .correctDown
        updateEnabledSaveButton(isEnabled: sugarFiedlIsEmpty)
        
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
      viewModel.resultFooterVM.value     = "\(floatTwo: getTotalInsulin())"
      
      
      
    case .correctDown:
      
      viewModel.resultFooterVM.viewState = .showed
      viewModel.resultFooterVM.message   = "Инсулина"
      viewModel.resultFooterVM.value     = "\(floatTwo: getTotalInsulin())"
      
      
      
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
      viewModel.resultFooterVM.value     = "\(floatTwo: resultInsulin)"
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
    
    return NewCompObjViewModel(sugarCellVM     : sugarCellVM,
                               addMealCellVM   : addMealCellVM,
                               injectionCellVM : injectionCellVM,
                               resultFooterVM  : resultFooterVM,
                               isValidData     : false)
  }
  
  private func getDefaultResultFooterVM() -> ResultFooterModel {
    
    return ResultFooterModel(
      message                : "",
      value                  : "",
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
      productsData: [],
      isPreviosDinner: false)
    
    return AddMealCellModel(cellState           : .defaultState,
                            dinnerProductListVM : dinnerProductList)
  }
  
  private func getDefaultSugarCellVM() -> SugarCellModel {
    
    return SugarCellModel()
  }
  
  
  
  
  
}


