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
  
  static let locator = ServiceLocator.shared
  
  static  func getSugarVM(sugar: String) -> SugarCellModel {
  
   return updateCompansationLabelAndCellState(sugar: sugar)
    
  }
  
  static private func updateCompansationLabelAndCellState(sugar: String) -> SugarCellModel {
    
    
    guard let sugarCorrectorWorker:ShugarCorrectorWorker = locator.getService() else { fatalError()}
    
    var sugarCellVm = SugarCellModel()
    
    
        
    // Если пришла пустая строка то ставим ячейку по дефолту
    guard sugar.isEmpty == false else {
      sugarCellVm.cellState          = .currentLayer
      sugarCellVm.compansationString = nil
      sugarCellVm.correctionImage    = nil
      sugarCellVm.currentSugar       = nil
      return sugarCellVm
    }
        
    let sugarFloat = (sugar as NSString).floatValue
    
    sugarCellVm.currentSugar = sugarFloat
    
    let wayCorrectPosition = sugarCorrectorWorker.getWayCorrectPosition(sugar: sugarFloat)
    
    sugarCellVm.sugarState = wayCorrectPosition
    
    switch wayCorrectPosition {
    case .dontCorrect:
      sugarCellVm.compansationString   = "Сахар в норме"
      sugarCellVm.cellState            = .currentLayerAndCorrectionLabel
      sugarCellVm.correctionImage      = #imageLiteral(resourceName: "anesthesia")
      sugarCellVm.correctionSugarKoeff = 0
      
      
    case .correctDown:
      sugarCellVm.compansationString = "Сахар выше нормы! нужна коррекция инсулином!"
      sugarCellVm.cellState          = .currentLayerAndCorrectionLayer
      sugarCellVm.correctionImage    = #imageLiteral(resourceName: "anesthesia")
      
      // Здесь мне нужно расчитать коррекцию автоматически!
      
    case .correctUp:
      sugarCellVm.compansationString = "Сахар ниже нормы! нужна коррекция углеводами!"
      sugarCellVm.cellState          = .currentLayerAndCorrectionLayer
      sugarCellVm.correctionImage    = #imageLiteral(resourceName: "candy")
    default:break
    }
    
    return sugarCellVm
    
  }
  
}


