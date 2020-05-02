//
//  FoodValidator.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 26/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class FoodValidator: Validateble {
  
  
  var foodRealmManger: FoodRealmManager!

  var name: String? { didSet {
    checkForm()
    checkName()
    } }
  var category: String? { didSet {checkForm()} }
  
  var carbo: String? { didSet {
    checkForm()
    checkCarbo()
    } }
  
  var massa: String? { didSet {
    checkForm()
    checkMassa()
    }}
  
  
  var isFavorit: Bool = false { didSet {checkForm()} }
  var isValidCallBack: ((Bool) -> Void)?
  
  // Каждый раз как будет сетится это значение передай информацию контроллеру
  var isValidate: Bool! {
    didSet {
      isValidCallBack!(isValidate)
    }
  }
  
  // Alert
  var alertString: String{
    set {}
    get {
      "\(alertNameString ?? "")" + "\(alertCarboString ?? "")" + "\(alertMassaString ?? "")"
    }
  }
  
  var alertNameString  : String?
  var alertCarboString : String?
  var alertMassaString : String?
  
  init() {
    let locator = ServiceLocator.shared
    foodRealmManger = locator.getService()
  }
  
  
  func checkForm() {
    // проверка на то что не пустые значения
    
    if isFavorit { // если в фавориты то добавить массу обязательным пунктом
      isValidate = name?.isEmpty == false && category?.isEmpty == false && carbo?.isEmpty == false && massa?.isEmpty == false
    } else {
      isValidate = name?.isEmpty == false && category?.isEmpty == false && carbo?.isEmpty == false
    }
    
  }
  

  
  func setDefault() {
    name        = nil
    category    = nil
    carbo       = nil
    massa       = nil
    isFavorit   = false
    alertNameString  = nil
    alertCarboString = nil
    alertMassaString = nil
  }
  
  func setFieldsFromViewModel(viewModel: NewProductViewModelable) {
    name       = viewModel.name!
    category   = viewModel.category!
    carbo      = viewModel.carbo!
    massa      = viewModel.massa!
    isFavorit  = viewModel.isFavorits
  }
  

  
  func checkName() {
    
    guard let name = name else {return}
    
    alertNameString = foodRealmManger.isCheckProductByName(name: name) ? nil : "Продукт с таким именем уже есть!"
    
  }
  
  func checkCarbo(){
    
    guard let carbo = carbo,let carboInt = Int(carbo) else {
      alertCarboString = "Данные по углеводам некорректны"
      return
      
    }
    if carboInt > 100 {
      alertCarboString = "В 100 гр. продукта не может быть больше 100гр. углеводов!"
    } else {
      alertCarboString = nil
    }
    
  }
  
  func checkMassa() {
    
    guard let massa = massa,let massaInt = Int(massa) else {
      alertMassaString = "Данные по массе не коректно"
      return
    }
    
    if massaInt > 1000 {
      alertMassaString = "Убедитесь что данные по массе продукта верны!"
    } else {
      alertMassaString = nil
    }
   
  }
}
