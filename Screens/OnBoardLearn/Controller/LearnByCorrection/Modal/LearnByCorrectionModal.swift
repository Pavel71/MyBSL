//
//  LearnByCorrectionModal.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Модель должна обеспечить сбор тестируемых данных!

struct LearnByCorrectionModal:LearnByCorrectionSugarCellable {
  
  var sugar             : Double
  var correctionInsulin : Double?

}


// MARK: Models

struct SugarLevelModel {

  var lowerSliderValue : CGFloat // min = 4.5 == 0
  
  var higherSliderValue: CGFloat // max = 15.0 == 1
  
  // Короче тут должна быть еще матиматика - Так как нам приходят значения от 0 до 1 мне нужно это как то поделить что такое 1 и что такое 0
  
//  static let low  : Double = 4.5
  static let high : Double = 15.0
  
//  var diff = {high - low}
  
  var sugarLowerLevel: Double {
    (SugarLevelModel.high * Double(lowerSliderValue)).roundToDecimal(1)
  }
  
  var sugarHigherLevel: Double {
    (SugarLevelModel.high * Double(higherSliderValue)).roundToDecimal(1)
  }
  
  var optimalSugarLevel: Double {
    (sugarLowerLevel + sugarHigherLevel) / 2
  }
}
