//
//  Validatable.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

protocol Validateble {
  
  var isValidCallBack: ((Bool) -> Void)? {get set}
  var isValidate: Bool! {get set}
  func checkForm()
  func setDefault()
  
  
}
