//
//  SaveButtonValidator.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation

// Класс будет отвечать за валидацию кнопки сохранить в зависимости от разных параметров
class SaveButtonValidator {
  
  
  var isValid: Bool = false
  
  var isSugarFieldNotEmpty = false
  var sugarCorrection: CorrectInsulinPosition = .progress {didSet {checkValidButton()}}
  var isProductListNotEmtpy = false {didSet{checkValidButton()}}
  
  
  func checkValidButton() {
    
    if sugarCorrection == .correctDown && isSugarFieldNotEmpty {
      isValid = true
    } else {
      
      isValid = isProductListNotEmtpy && isSugarFieldNotEmpty
      
    }
    
    
    
  }
  
}
