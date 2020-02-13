//
//  LearnByCorrectionVM.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



class LearnByCorrectionVM {
  
  
  var isFillAllFields = false {
    
    didSet {
      didUpdateValidForm!(isFillAllFields)
    }
    
  }
  var didUpdateValidForm: ((Bool) -> Void)?
  
  var tableData: [LearnByCorrectionModal] =
  [
    LearnByCorrectionModal(sugar: 9.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 12.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 15.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 18.0, correctionInsulin: nil),
    LearnByCorrectionModal(sugar: 21.0, correctionInsulin: nil),
  ]
  
  
  
  func addInsulinInObject(insulinValue: Double, index: Int) {
    
    tableData[index].correctionInsulin = insulinValue
    
    checkAllCorrectionFiedls()
  }
  
  
  func checkAllCorrectionFiedls() {
    
    
    isFillAllFields = tableData.filter {$0.correctionInsulin == nil}.isEmpty
    
  }
  
  
  
}
