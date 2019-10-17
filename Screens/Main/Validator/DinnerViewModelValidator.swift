//
//  DinnerViewModelValidator.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

class DinnerViewModelValidator: Validateble {
  
  
  // Этот Валидатор нужно базировать в Main! потомучто ряд полей приходят из main + перенаправлять потом в 3 ячейку!
  
  // Fields Validate
  
  var shugarBeforeValue: String? {didSet {checkForm()}}
  
  // просто 2 свойства не помогут
  var insulinValue: String? {didSet {checkForm()}}
  var portion: String? {didSet {checkForm()}}
  
  
  //1. Сделать валидатора для каждого продукта тоесть я создаю столько же валидаторов сколько и продуктов и каждый отчитывается 1ому большому валидатору!
  
  
  
  
  // предположим я знаю сколько у меня продуктов на заполнение нужно проверить!
  
  
  var placeInjection: String? {didSet {checkForm()}}
//  var train: String?  // Это пока под вопросом!
  
  
  
  var isValidCallBack: ((Bool) -> Void)?
  
  var isValidate: Bool! {
    didSet {
      isValidCallBack!(isValidate)
    }
  }
  
  func checkForm() {
    isValidate = shugarBeforeValue?.isEmpty == false && insulinValue?.isEmpty == false && portion?.isEmpty == false && placeInjection?.isEmpty == false
    
  }
  
  func setDefault() {
    shugarBeforeValue = nil
    insulinValue = nil
    portion = nil
    placeInjection = nil
  }
  
  
}
