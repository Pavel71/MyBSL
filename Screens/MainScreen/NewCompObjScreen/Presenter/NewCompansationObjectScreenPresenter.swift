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
  
  
  // ViewModel
  var viewModel: NewCompObjViewModel!
  
  func presentData(response: NewCompansationObjectScreen.Model.Response.ResponseType) {
    catchViewModelResponse(response: response)
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
      
      SugarCellVMWorker.updateCurrentSugarVM(sugar: sugar, viewModel: &viewModel)
      throwViewModelToVC()
      
    case .updateAddMealStateInVM(let isNeed):
      
      AddMealVMWorker.changeNeedProductList(isNeed: isNeed, viewModel: &viewModel)
      throwViewModelToVC()
      
      
    case .addProductsInProductListVM(let products):
      
    addProductsInVM(products: products)
    
      throwViewModelToVC()
      
    case .deleteProductsInProductListVM(let products):
      
      deleteProductsFromVM(products: products)
      
      throwViewModelToVC()
      
      
    default:break
    }
  }
  
  private func throwViewModelToVC() {
    viewController?.displayData(viewModel: .setViewModel(viewModel: viewModel))
  }
  
}



// MARK: Work With ProductListVM

extension NewCompansationObjectScreenPresenter {
  
  private func convertProductRealmToProductListVMData(product:ProductRealm) -> ProductListViewModel {
      
    return ProductListViewModel(
      correctInsulinValue : nil,
      insulinValue        : nil,
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
  
  private func deleteProductsFromVM(products:[ProductRealm]) {
    
    let newData = products.map(convertProductRealmToProductListVMData)
    
    viewModel.addMealCellVM.dinnerProductListVM.productsData
      .removeAll(where: { newData.contains($0) })
    // пересчитываем резалт
    calculateResultViewModel()
  }
  
  
  // MARK: Calculate Results ProductList In Dinner

  // When add New Product or delete we should calculate Again

    
    private func calculateResultViewModel() {
      
      let productsData = viewModel.addMealCellVM.dinnerProductListVM.productsData
      
      let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
      
      // Set
      viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel = resultViewModel

    }
    
    
    // May i'll create footer Worker Class
//    private func calculateTotalInsulin() {
//
//      let sumInsulinByProduct = getNewDinnerViewModel().productListInDinnerViewModel.resultsViewModel.sumInsulinValue
//      let correctionInsulin = getNewDinnerViewModel().shugarTopViewModel.correctInsulinByShugar
//      let totalInsulin = correctionInsulin + (sumInsulinByProduct as NSString).floatValue
//
//      mainViewModel.setTotalInsulin(totalInsulin: totalInsulin)
//
//
//    }
    
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


