//
//  UITextField+Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

extension UITextField {
  
  convenience init(placeholder: String,cornerRadius: CGFloat) {
    self.init()
    self.placeholder = placeholder
    self.layer.cornerRadius = cornerRadius
  }
  
  
  
  func addDoneButtonOnKeyboard(){
    
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.KeyBoard.doneToolBarHeight))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(self.doneButtonAction))
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.inputAccessoryView = doneToolbar
  }
  
  @objc func doneButtonAction(){
    self.resignFirstResponder()
  }
}
