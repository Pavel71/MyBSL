//
//  CustomValueTextField.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class CustomValueTextField: UITextField {
  
  let padding: CGFloat = 5
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    textAlignment = .center
    backgroundColor = .white
    addDoneButtonOnKeyboard()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.borderWidth = 1
    layer.borderColor = UIColor.lightGray.cgColor
    
    clipsToBounds = true
    layer.cornerRadius = 10
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 0, height: 40)
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
    // Сработает делегат и все будет норм!
    print("Tap Done Button")
  }
}
