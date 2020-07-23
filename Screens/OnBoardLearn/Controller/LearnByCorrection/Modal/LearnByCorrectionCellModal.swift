//
//  LearnByCorrectionModal.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Модель должна обеспечить сбор тестируемых данных!

struct LearnByCorrectionCellModal:LearnByCorrectionSugarCellable {
  
  var sugar             : Double
  var correctionInsulin : Double?

}


struct LearnByCorrectionModel {
  
  var sugarLevelModel : SugarLevelModel
  var metrics         : SugarMetric
  
  var tableData = [LearnByCorrectionCellModal]()
  
  private let mmolTableData =  [
         LearnByCorrectionCellModal(sugar: 9.0, correctionInsulin: nil),
         LearnByCorrectionCellModal(sugar: 12.0, correctionInsulin: nil),
         LearnByCorrectionCellModal(sugar: 15.0, correctionInsulin: nil),
         LearnByCorrectionCellModal(sugar: 18.0, correctionInsulin: nil),
         LearnByCorrectionCellModal(sugar: 21.0, correctionInsulin: nil),
     ]
  private let mgdlTableData =  [
      LearnByCorrectionCellModal(sugar: 162, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 216, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 270, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 324, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 378, correctionInsulin: nil),
  ]
  
  init(metric : SugarMetric,lowerSliderValue:CGFloat,higherSliderValue:CGFloat) {
    
    
    self.metrics  = metric
    
    // MARK: Sugar LEvel Models
    
    
    let sugarLevelMaxValue : Float
    switch metric {
    case .mmoll:
      self.tableData.append(contentsOf: mmolTableData)
      sugarLevelMaxValue = 15
    case .mgdl :
      self.tableData.append(contentsOf: mgdlTableData)
      sugarLevelMaxValue = 15 * 18
    }
    
    self.sugarLevelModel = SugarLevelModel(
    lowerSliderValue  : lowerSliderValue,
    higherSliderValue : higherSliderValue,
    maxValue          : sugarLevelMaxValue)
    
  }
  

}


// MARK: Models

struct SugarLevelModel {

  var lowerSliderValue : CGFloat = 0.3 // min = 4.5 == 0
  
  var higherSliderValue: CGFloat = 0.5 // max = 15.0 == 1
  
  var maxValue         : Float
  
  // Короче тут должна быть еще матиматика - Так как нам приходят значения от 0 до 1 мне нужно это как то поделить что такое 1 и что такое 0
  
//  static let low  : Double = 4.5
//  static var high : Float = 15.0
  
//  var diff = {high - low}
  
  var sugarLowerLevel: Float {
    (maxValue * Float(lowerSliderValue))
  }
  
  var sugarHigherLevel: Float {
    (maxValue * Float(higherSliderValue))
  }
  
  var optimalSugarLevel: Float {
     (sugarLowerLevel + sugarHigherLevel) / 2
  }
}
