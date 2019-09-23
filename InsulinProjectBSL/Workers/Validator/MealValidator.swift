//
//  MealValidator.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 12/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealValidator: Validateble {

  var isValidCallBack: ((Bool) -> Void)?
  
  var isValidate: Bool! {
    didSet {
      isValidCallBack!(isValidate)
    }
  }
  
  var name: String? { didSet {checkForm()} }
  var typeOfMeal: String? { didSet {checkForm()} }
  
  func checkForm() {
    isValidate = name?.isEmpty == false && typeOfMeal?.isEmpty == false
  }
  
  func setDefault() {
    name = nil
    typeOfMeal = nil
  }
  
  func setFieldsFromViewModel(viewModel: NewMealViewModelable) {
    name = viewModel.name
    typeOfMeal = viewModel.typeOfMeal
  }
  
  
}
