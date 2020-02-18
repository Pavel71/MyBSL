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
        
      case .updateCurrentSugarInVM(let sugar):
        
        setSugarData(sugar: sugar)
       
        throwViewModelToVC()
        
      case .updateAddMealStateInVM(let isNeed):
        
        AddMealVMWorker.changeNeedProductList(isNeed: isNeed, viewModel: &viewModel)
        throwViewModelToVC()
    
    default:break
    }
  }
  
  
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


// MARK: Woek With Sugar VM
extension NewCompansationObjectScreenPresenter {
  
  private func setSugarData(sugar: String) {
    
     SugarCellVMWorker.updateCurrentSugarVM(sugar: sugar, viewModel: &viewModel)
    
    // Сахар выше нормы мы должны его компенсировать
    if viewModel.sugarCellVM.cellState == .currentLayerAndCorrectionLayer {
      let predictSugarCompansation = mlWorkerByCorrection.getPredict(testData: [Float(viewModel.sugarCellVM.currentSugar!)])
      viewModel.sugarCellVM.correctionSugarKoeff = predictSugarCompansation.first!
    }
  }
  
  
}


// MARK: Work With ProductListVM

extension NewCompansationObjectScreenPresenter {
  
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
    calculateResultViewModel()
  }
  
  // Delete
  
  private func deleteProductsFromVM(products:[ProductRealm]) {
    
    let newData = products.map(convertProductRealmToProductListVMData)
    
    viewModel.addMealCellVM.dinnerProductListVM.productsData
      .removeAll(where: { newData.contains($0) })
    // пересчитываем резалт
    calculateResultViewModel()
  }
  
  private func updateInsulinField(insulinValue: Float, index: Int) {
    viewModel.addMealCellVM.dinnerProductListVM.productsData[index].insulinValue = insulinValue
    calculateResultViewModel()
  }
  
  // Update Portion
  
  private func updatePortionField(portion: Int, index: Int) {
    
    viewModel.addMealCellVM.dinnerProductListVM.productsData[index].portion = portion
    
    if isAutoCalculateInsulin {
      getPredictUnsulinByProduct(index: index)
    }
    
    calculateResultViewModel()
  }
  
  private func getPredictUnsulinByProduct(index: Int) {
     let testData = viewModel.addMealCellVM.dinnerProductListVM.productsData[index].carboInPortion
      let predictInsulin = mlWorkerByFood.getPredict(testData: [Float(testData)])
     
     print(predictInsulin,"Predict insulin when update")
     viewModel.addMealCellVM.dinnerProductListVM.productsData[index].insulinValue = predictInsulin.first
     
  }
    
 
    
    
  
  
  
  // MARK: Calculate Results ProductList In Dinner

  // When add New Product or delete we should calculate Again

    
    private func calculateResultViewModel() {
      
      let productsData = viewModel.addMealCellVM.dinnerProductListVM.productsData
      
      let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
      
      // Set
      viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel = resultViewModel

    }
    
    
    
}


//MARK: Get Blank ViewModel

extension NewCompansationObjectScreenPresenter {
  
  private func getBlankViewModel() -> NewCompObjViewModel {
    
    let sugarCellVM   = getDefaultSugarCellVM()
    let addMealCellVM = getDefaultAddmealCellVM()
    return NewCompObjViewModel(sugarCellVM   : sugarCellVM,
                               addMealCellVM : addMealCellVM)
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


