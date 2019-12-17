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
    default:break
    }
  }
  
  private func throwViewModelToVC() {
    viewController?.displayData(viewModel: .setViewModel(viewModel: viewModel))
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
    
    let productListVM = NewProductListViewModel(
      cells: [])
    
    return AddMealCellModel(cellState     : .defaultState,
                            productListVM : productListVM)
  }
  
  private func getDefaultSugarCellVM() -> SugarCellModel {
    
    return SugarCellModel()
  }
  
  
  
  
  
}


