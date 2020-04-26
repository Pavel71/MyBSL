//
//  NewSugarViewValidator.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 04.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


class NewSugarViewValidator: Validateble {
  
  var isValidCallBack: ((Bool) -> Void)?
  
  var isValidate: Bool! {
    didSet {
      isValidCallBack!(isValidate)
    }
  }
  
  var sugar: String? { didSet {checkForm()} }
  
  var sugarCorrectorWorker: ShugarCorrectorWorker!
  
  
  init() {
    let locator  = ServiceLocator.shared
    sugarCorrectorWorker = locator.getService()
  }
  
  
  func checkForm() {
    isValidate = sugar?.isEmpty == false
    
    
    
    
    
    
    // Здесь нужен метод который проверит сахар на позицию и вернет ее!
  }
  
  func getWayCompansation() -> CorrectInsulinPosition {
    // Если данные есть
    guard let sugar = self.sugar else {return .dontCorrect}
    let sugarFloat = (sugar as NSString).floatValue
    
    return sugarCorrectorWorker.getWayCorrectPosition(sugar: sugarFloat)

  }
  
  func setDefault() {
    sugar = nil
  }
  
  
  
}
