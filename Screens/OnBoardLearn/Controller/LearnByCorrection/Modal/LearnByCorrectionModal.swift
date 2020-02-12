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
  
  
  
  static func getTestData() -> [LearnByCorrectionModal] {
    
    return [
      LearnByCorrectionModal(sugar: 9.0, correctionInsulin: nil),
      LearnByCorrectionModal(sugar: 12.0, correctionInsulin: nil),
      LearnByCorrectionModal(sugar: 15.0, correctionInsulin: nil),
      LearnByCorrectionModal(sugar: 18.0, correctionInsulin: nil),
      LearnByCorrectionModal(sugar: 21.0, correctionInsulin: nil),
    ]
  }
  
}
