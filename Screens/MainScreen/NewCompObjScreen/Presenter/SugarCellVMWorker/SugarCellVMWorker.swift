//
//  SugarVMWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


// Класс отвеает за работу с моделью SugarVM

class SugarCellVMWorker {
  
  
  static  func updateCurrentSugarVM(
    sugar: String,
    viewModel: inout NewCompObjViewModel) {
    
    viewModel.sugarCellVM.currentSugar = sugar == "" ? nil : (sugar as NSString).floatValue
    
    updateCompansationLabelAndCellState(sugar: sugar,viewModel:&viewModel)
    
  }
  
  static private func updateCompansationLabelAndCellState(sugar: String,viewModel:inout NewCompObjViewModel) {
        
    // Если пришла пустая строка то ставим ячейку по дефолту
    guard sugar.isEmpty == false else {
      viewModel.sugarCellVM.cellState          = .currentLayer
      viewModel.sugarCellVM.compansationString = nil
      viewModel.sugarCellVM.correctionImage    = nil
      return
    }
        
    let sugarFloat = (sugar as NSString).floatValue
    let wayCorrectPosition = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: sugarFloat)
    
    viewModel.sugarCellVM.sugarState = wayCorrectPosition
    
    switch wayCorrectPosition {
    case .dontCorrect:
      viewModel.sugarCellVM.compansationString = "Сахар в норме"
      viewModel.sugarCellVM.cellState          = .currentLayerAndCorrectionLabel
      viewModel.sugarCellVM.correctionImage    = nil
    case .correctDown:
      viewModel.sugarCellVM.compansationString = "Сахар выше нормы! нужна коррекция инсулином!"
      viewModel.sugarCellVM.cellState          = .currentLayerAndCorrectionLayer
      viewModel.sugarCellVM.correctionImage    = #imageLiteral(resourceName: "anesthesia")
      
      // Здесь мне нужно расчитать коррекцию автоматически!
      
    case .correctUp:
      viewModel.sugarCellVM.compansationString = "Сахар ниже нормы! нужна коррекция углеводами!"
      viewModel.sugarCellVM.cellState          = .currentLayerAndCorrectionLayer
      viewModel.sugarCellVM.correctionImage    = #imageLiteral(resourceName: "candy")
    default:break
    }
    
  }
  
}


