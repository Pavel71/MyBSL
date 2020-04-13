//
//  LearnByCorrectionVM.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

// Нам нужно также знать какой уровень сахар человек будет считать оптимальным для себя! Нужно дать ему возможность выбрать!


class LearnByCorrectionVM {
  
  
  // MARK: Validate
  
  var isFillAllFields = false {
    
    didSet {
      didUpdateValidForm!(isFillAllFields)
    }
    
  }
  var didUpdateValidForm: ((Bool) -> Void)?
  
  
  // MARK: Sugar Insulin Models
  
  var tableData: [LearnByCorrectionModal] =
  [
    LearnByCorrectionModal(sugar: 9.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 12.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 15.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 18.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 21.0, correctionInsulin: nil),
  ]
  
  // MARK: Sugar LEvel Models
  
  var sugarLevelVM = SugarLevelModel(
    lowerSliderValue: 4.5,
    higherSliderValue: 7.5)
  
  
  
  func addInsulinInObject(insulinValue: Double, index: Int) {
    
    tableData[index].correctionInsulin = insulinValue
    
    checkAllCorrectionFiedls()
  }
  
  
  func checkAllCorrectionFiedls() {
    
    
    isFillAllFields = tableData.filter {$0.correctionInsulin == nil}.isEmpty
    
  }
  
  
  
}


  
  
//}
// MARK: Work with sugarLevelVM

extension LearnByCorrectionVM {
  
  func updateSugarLevelVM(sugarLevelModel: SugarLevelModel) {
    sugarLevelVM.lowerSliderValue  = sugarLevelModel.lowerSliderValue
    sugarLevelVM.higherSliderValue = sugarLevelModel.higherSliderValue
  }
}
