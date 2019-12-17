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
      updateCurrentSugarVM(sugar: sugar)
      throwViewModelToVC()
    default:break
    }
  }
  
  private func throwViewModelToVC() {
    viewController?.displayData(viewModel: .setViewModel(viewModel: viewModel))
  }
  
}


//MARK: Work with ViewModel

extension NewCompansationObjectScreenPresenter {
  
  private func getBlankViewModel() -> NewCompObjViewModel {
    
    let sugarCellVM = getDefaultCellVM()
    return NewCompObjViewModel(sugarCellVM: sugarCellVM)
  }
  
  private func getDefaultCellVM() -> SugarCellModel {
    
    return SugarCellModel()
  }
  
  
  // MARK: Update VM
  
  private func updateCurrentSugarVM(sugar: String) {
    
    viewModel.sugarCellVM.currentSugar = sugar == "" ? nil : (sugar as NSString).doubleValue
    
    updateCompansationLabelAndCellState(sugar: sugar)
    
  }
  
  private func updateCompansationLabelAndCellState(sugar: String) {
        
    // Если пришла пустая строка то ставим ячейку по дефолту
    guard sugar.isEmpty == false else {
      viewModel.sugarCellVM.cellState          = .currentLayer
      viewModel.sugarCellVM.compansationString = nil
      viewModel.sugarCellVM.correctionImage    = nil
      return
    }
        
    let sugarFloat = (sugar as NSString).floatValue
    let wayCorrectPosition = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: sugarFloat)
    
    switch wayCorrectPosition {
    case .dontCorrect:
      viewModel.sugarCellVM.compansationString = "Сахар в норме"
      viewModel.sugarCellVM.cellState          = .currentLayerAndCorrectionLabel
      viewModel.sugarCellVM.correctionImage    = nil
    case .correctDown:
      viewModel.sugarCellVM.compansationString = "Сахар выше нормы! нужна коррекция инсулином!"
      viewModel.sugarCellVM.cellState          = .currentLayerAndCorrectionLayer
      viewModel.sugarCellVM.correctionImage    = #imageLiteral(resourceName: "anesthesia")
    case .correctUp:
      viewModel.sugarCellVM.compansationString = "Сахар ниже нормы! нужна коррекция углеводами!"
      viewModel.sugarCellVM.cellState          = .currentLayerAndCorrectionLayer
      viewModel.sugarCellVM.correctionImage    = #imageLiteral(resourceName: "candy")
    default:break
    }
    
  }
}
