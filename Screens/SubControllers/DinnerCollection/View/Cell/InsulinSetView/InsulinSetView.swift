//
//  InsulinSetView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class InsulinSetView: UIView {
  
  
  
  static let height: CGFloat = 60
  
  let insulinTitleLabel = CustomLabels(font: .systemFont(ofSize: 18), text: "Введите дозировку под обед")
  
  let insulinValueTextField = CustomValueTextField(placeholder: "2.5", cornerRadius: 10)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    insulinValueTextField.keyboardType = .decimalPad
    let stackView = UIStackView(arrangedSubviews: [
      insulinTitleLabel,insulinValueTextField
      ])
    insulinValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.fillSuperview()
    
//    addDoneButtonOnKeyboard()
  }
  
//  func addDoneButtonOnKeyboard(){
//
//    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//    doneToolbar.barStyle = .default
//
//    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//    let done: UIBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//    let items = [flexSpace, done]
//    doneToolbar.items = items
//    doneToolbar.sizeToFit()
//
//    shugarValueTextField.inputAccessoryView = doneToolbar
//  }
//
//  @objc func doneButtonAction(){
//    shugarValueTextField.resignFirstResponder()
//    // Сработает делегат и все будет норм!
//    print("Tap Done Button")
//  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
