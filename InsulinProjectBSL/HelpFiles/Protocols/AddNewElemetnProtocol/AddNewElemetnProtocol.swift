//
//  AddNewElemetnProtocol.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 11/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol Validator {
  
}


protocol AddNewElementProtocol: UIView {
  
  var validator: Validator {get set}
  
  func hideViewOnTheRightCorner()
  func clearAllFieldsInView()
  func set()
  func getViewModel()
  
}
