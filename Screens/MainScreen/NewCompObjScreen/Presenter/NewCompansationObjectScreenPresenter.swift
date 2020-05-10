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

final class NewCompansationObjectScreenPresenter: NewCompansationObjectScreenPresentationLogic {
  
  weak var viewController: NewCompansationObjectScreenDisplayLogic?
  
  
  // Флаг будет братся из настроек юзера
  
  var isAutoCalculateInsulin = true
  // ViewModel
  
  private var viewModel: NewCompObjViewModel!
  
  private var saveButtonValidator  = SaveButtonValidator()
  
  
  
  private var mlWorkerByCorrection = MLWorker(typeWeights: .correctSugarByInsulinWeights)
  private var mlWorkerByFood       = MLWorker(typeWeights: .correctCarboByInsulinWeights)
  
  private var sugarCorrectorWorker  : ShugarCorrectorWorker!
  private var compObjRealmManager   : CompObjRealmManager!
  private var dateEnriachmentWorker : DataEnrichmentWorker!
  private var userDefaultsWorker    : UserDefaultsWorker!
//  let userDefaults = UserDefaults.standard
  
  init() {
    let locator = ServiceLocator.shared
    sugarCorrectorWorker  = locator.getService()
    compObjRealmManager   = locator.getService()
    dateEnriachmentWorker = locator.getService()
    userDefaultsWorker    = locator.getService()
    
  }
  
  
  func presentData(response: NewCompansationObjectScreen.Model.Response.ResponseType) {
    
    
    workWithMachinLearning(response: response)
    catchViewModelResponse(response: response)
    workWithProductListRequest(response: response)
    
  }
  
  
  
}

// MARK: Catch View Model Requests
extension NewCompansationObjectScreenPresenter {
  
  private func workWithMachinLearning(response: NewCompansationObjectScreen.Model.Response.ResponseType) {
    

    
    switch response {
    case .learnMlForNewData:
      mlWorkerStartWoring()
    default:break
    }
  }
  
  
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
      
    case .updateCopmansationSugarInsulin(let compInsulin):
      
      updateCompSugarInsulinUserSet(compInsulin: compInsulin)
        throwViewModelToVC()
      
      case .updateAddMealStateInVM(let isNeed):
        updateMealCellState(isNeed: isNeed)
        
        throwViewModelToVC()
        
      case .updatePlaceInjection(let place):
        updatePlaceInjectionInVM(place: place)
        throwViewModelToVC()
        
    case .passCompObjIdAndSugarRealmIdToVC(let compObjId,let sugarId):
      
        viewController?.displayData(viewModel: .passCompanObjIdAndSugarRealmIdToMainVC(
          compObjRealmId: compObjId,
          sugarRealmId: sugarId))
      
    case .updateSugarRealmAndCompObjSucsess:
      viewController?.displayData(viewModel: .updateCompObjAndSugarRealmSucsess)
      
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
  
 // MARK: Get ML Predict
  
  private func updateCompSugarInsulinUserSet(compInsulin: String) {
    
    let compInsulinFloat = compInsulin.floatValue()
    
    viewModel.sugarCellVM.correctionSugarKoeff = compInsulinFloat
    
    updateResultViewModel()
    
  }
  
  private func setSugarData(sugar: String) {
    
    
    viewModel.sugarCellVM = SugarCellVMWorker.getSugarVM(sugar: sugar)
    
    updateMeallCellSwitcherEnabled(isEnabled: !sugar.isEmpty)
    
    // Все таки думаю что лучше считать корректировку по сахару для всех
    
    if sugar.isEmpty == false,let currentSugar = viewModel.sugarCellVM.currentSugar {
      
      
      let test = sugarCorrectorWorker.getSugasrTrainData(currentSugar: currentSugar.toDouble())
      
      
      
      // Добавим проверку на то что тест не отклоняется от идела на много
      // Если отклоняется то уже просим сделать предсказание
      var predictInsulin:Float?
      
      if case 0...0.3 = test {
        predictInsulin = 0
      } else {
        let predictInsulinArray = mlWorkerByCorrection.getPredict(testData: [test])
        predictInsulin = predictInsulinArray.first
      }

      guard let predInsul = predictInsulin  else {return}
      
      
      let signCompansation:Float = currentSugar < sugarCorrectorWorker.optimalSugarLevel.toFloat() ? -1.0 : 1.0
      
      viewModel.sugarCellVM.correctionSugarKoeff = predInsul * signCompansation
      viewModel.addMealCellVM.dinnerProductListVM.compansationSugarInsulin = predInsul * signCompansation
    }
    
    checkSaveButton()

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

// MARK: Work With Meal Cell

extension NewCompansationObjectScreenPresenter {
  
  
  private func updateMeallCellSwitcherEnabled(isEnabled: Bool) {
    viewModel.addMealCellVM.isSwitcherIsEnabled = isEnabled
  }
  
  private func updateMealCellState(isNeed: Bool) {

    
    viewModel.addMealCellVM.cellState = isNeed ? .productListState : .defaultState
       
    if isNeed == false {
      // если обед не нужен то очистим все продукты
      viewModel.addMealCellVM.dinnerProductListVM.productsData.removeAll()
      calculateResultViewModelInProductList()
      
    }
    
    
    checkSaveButton()
    updateResultViewModel()
    setInjectionCellState()
  }
  
  private func convertProductRealmToProductListVMData(product:ProductRealm) -> ProductListViewModel {
    
    
    let insulinValue = isAutoCalculateInsulin ? mlWorkerByFood.getPredict(testData: [product.carboInPortion]).first! : nil
    
    // ПО сути здесь уже мы можем сделать первый расчет! Но это пока не особо важно!
      
    return ProductListViewModel(
      id                  : product.id,
      correctInsulinValue : nil,
      insulinValue        : insulinValue,
      isFavorit           : product.isFavorits,
      carboIn100Grm       : product.carboIn100grm,
      category            : product.category,
      name                : product.name,
      portion             : product.portion,
      totalCarboInMeal    :     0    )
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
    
     let carboData = viewModel.addMealCellVM.dinnerProductListVM.productsData[index].carboInPortion
     
    // Если углеводов нет то сетим руками 0
    
    var predictInsulin:Float?
    
    if  carboData != 0 {
      let predictInsulinArray = mlWorkerByFood.getPredict(testData: [Float(carboData)])
      predictInsulin = predictInsulinArray.first
    } else {
      predictInsulin = 0
    }
     
     viewModel.addMealCellVM.dinnerProductListVM.productsData[index].insulinValue = predictInsulin
     
  }
    
 
    
    
  
  
  
  // MARK: Calculate Results ProductList In Dinner

  // When add New Product or delete we should calculate Again

    
    private func calculateResultViewModelInProductList() {
      
      let productsData = viewModel.addMealCellVM.dinnerProductListVM.productsData
      
      let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
      
      // Set
      viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel = resultViewModel
      

      updateResultViewModel()

      checkSaveButton()
      
      
    }
  
//  private func setTotalCarbo
  
  // MARK: WOrk With Save Button
  private func updateEnabledSaveButton(isEnabled: Bool) {
    
    viewModel.isValidData = isEnabled
  }
  
  
   private func checkSaveButton() {
     
     let productListIsnotEmtpy = viewModel.addMealCellVM.dinnerProductListVM.productsData.isEmpty == false

     saveButtonValidator.isProductListNotEmtpy = productListIsnotEmtpy
     saveButtonValidator.isSugarFieldNotEmpty  = viewModel.sugarCellVM.currentSugar != nil
     saveButtonValidator.isMealSwitcherEnabled = viewModel.addMealCellVM.cellState == .productListState
     
     if let sugarFloat = viewModel.sugarCellVM.currentSugar {
       saveButtonValidator.sugarCorrection = sugarCorrectorWorker.getWayCorrectPosition(sugar: sugarFloat)
     }
     
     updateEnabledSaveButton(isEnabled: saveButtonValidator.isValid)
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
//      resultStateByMealState()
      
    case .correctUp:
      

      let resultInsulin = getTotalInsulin()
      
      let message = getresultMessage(resultInsulin: resultInsulin)
      
      viewModel.resultFooterVM.viewState = .showed
      viewModel.resultFooterVM.message   = message
      viewModel.resultFooterVM.totalInsulinValue     = "\(floatTwo: getTotalInsulin())"
      viewModel.resultFooterVM.typeCompansationObject = .correctSugarByCarbo
      
      
    case .correctDown:
      
      viewModel.resultFooterVM.viewState = .showed
      viewModel.resultFooterVM.message   = "Инсулина"
      viewModel.resultFooterVM.totalInsulinValue     = "\(floatTwo: getTotalInsulin())"
      viewModel.resultFooterVM.typeCompansationObject = .correctSugarByInsulin
      
      
    default:break
    }
    
    resultStateByMealState()
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
      viewModel.resultFooterVM.typeCompansationObject = .mealObject
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
      totalInsulinValue      : "",
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
      productsData: [], compansationSugarInsulin: 0)
    
    return AddMealCellModel(cellState           : .defaultState,
                            dinnerProductListVM : dinnerProductList)
  }
  
  private func getDefaultSugarCellVM() -> SugarCellModel {
    
    return SugarCellModel()
  }
  
  
  
  
  
}


 // MARK:  ML Worker start Working

extension NewCompansationObjectScreenPresenter {
  
 
  
  
  private func mlWorkerStartWoring() {
    // Сначало подготовим предыдущий обед и обогатим данными его
    preparingCompObjToLearnToML()
    // Теперь мы готовы брать данные и переобучать модель - Получать обновленные веса
    
    learnByNewData()
  }
  
  private func preparingCompObjToLearnToML() {
    
    guard let compObjToLearnInMl = compObjRealmManager.fetchSecondOnTheEndCompObj() else {return}
    
    dateEnriachmentWorker.prepareCompObj(compObj: compObjToLearnInMl)
  }
  
  private func learnByNewData() {

    
    let baseSugarTrain = userDefaultsWorker.getArrayData(typeDataKey: .sugarCorrectTrainBaseData)

    let baseSugarTarget = userDefaultsWorker.getArrayData(typeDataKey: .sugarCorrectTargetBaseData)
    
    
    let baseCarboTrain  = userDefaultsWorker.getArrayData(typeDataKey: .carboCorrectTrainBaseData)
    
    let baseCarboTarget = userDefaultsWorker.getArrayData(typeDataKey: .carboCorrectTargetBaseData)
    

    print("Base Carbo",baseCarboTrain,baseCarboTarget)
    print("Base Sugar Correct",baseSugarTrain,baseSugarTarget)
    
    print("Пошло обучение Модели")
    
    var sugarTrainData  = compObjRealmManager.fetchTrainSugar()
    sugarTrainData.append(contentsOf: baseSugarTrain)
    
    var sugarTargetData = compObjRealmManager.fetchTargetSugar()
    sugarTargetData.append(contentsOf: baseSugarTarget)
    
    print(sugarTrainData,"Sugar Train Data")
    print(sugarTargetData, "sugarTargetData")
    
    // Learn and Set New Weights
    mlWorkerByCorrection.trainModelAndSetWeights(trainData: sugarTrainData, target: sugarTargetData)
    
    // Нужно прокинуть эти данные в презентер или получить их из презентера
    
    var carboTrainData  = compObjRealmManager.fetchTrainCarbo()
    print(carboTrainData,"carboTrainData")
    carboTrainData.append(contentsOf: baseCarboTrain)
    var carboTargetData = compObjRealmManager.fetchTargetCarbo()
    print(carboTargetData,"carboTargetData")
    carboTargetData.append(contentsOf: baseCarboTarget)
    
    
    
    // Learn and Set new Weights
    mlWorkerByFood.trainModelAndSetWeights(trainData: carboTrainData, target: carboTargetData)
    
  }
}


