//
//  FoodValidator.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 26/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol Validateble {
  
  var isValidCallBack: ((Bool) -> Void)? {get set}
  var isValidate: Bool! {get set}
  func checkForm()
  func setDefault()
  
  
}


class FoodValidator: Validateble {

  var name: String? { didSet {checkForm()} }
  var category: String? { didSet {checkForm()} }
  var carbo: String? { didSet {checkForm()} }
  var massa: String? { didSet {checkForm()} }
  
  
  var isFavorit: Bool = false { didSet {checkForm()} }
  var isValidCallBack: ((Bool) -> Void)?
  
  // Каждый раз как будет сетится это значение передай информацию контроллеру
  var isValidate: Bool! {
    didSet {
      isValidCallBack!(isValidate)
    }
  }
  
  // Alert
  var alertString: String?
  
  
  func checkForm() {
    // проверка на то что не пустые значения
    
    if isFavorit { // если в фавориты то добавить массу обязательным пунктом
      isValidate = name?.isEmpty == false && category?.isEmpty == false && carbo?.isEmpty == false && massa?.isEmpty == false
    } else {
      isValidate = name?.isEmpty == false && category?.isEmpty == false && carbo?.isEmpty == false
    }
    
  }
  

  
  func setDefault() {
    name = nil
    category = nil
    carbo = nil
    massa = nil
    isFavorit = false
  }
  
  func setFieldsFromViewModel(viewModel: NewProductViewModelable) {
    name = viewModel.name!
    category = viewModel.category!
    carbo = viewModel.carbo!
    massa = viewModel.massa!
    isFavorit = viewModel.isFavorits
  }
  
  func checkCarboAndMassa() {
    alertString = nil
    checkCarbo()
    checkMassa()
  }
  
  func checkCarbo(){
    
    guard let carboInt = Int(carbo!) else {
      alertString = "Данные введены не коректно"
      return
      
    }
    if carboInt > 100 {
      alertString = "В 100 гр. продукта не может быть больше 100гр. углеводов!"
    }
  }
  
  func checkMassa() {
    
    if massa != nil {
      
      guard let massaInt = Int(massa!) else {
        alertString = "Данные введены не коректно"
        return
      }
      
      if massaInt > 1000 {
        alertString = "Убедитесь что данные по массе продукта верны!"
      }
      
    }
   
  }
}
