//
//  AddNewMealView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 10/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

protocol AddNewElemetnView: UIView {
  //  static var size: CGSize {get}
//  func setDefaultView()
//  var size: CGSize {get set}
  
}

class AddNewElementView: UIView, UITextFieldDelegate, AddNewElemetnView {
  
//  var size: CGSize = .zero
  
  let titleLabel = CustomLabels(font: .systemFont(ofSize: 18, weight: .heavy), text: "Введите данные пожалуйста!")
  
  
  let okButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Сохранить", for: .normal)
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .disabled)
    button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
    button.layer.cornerRadius = 10
    
    button.isEnabled = false
    
    return button
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Отменить", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    button.backgroundColor = .red
    button.layer.cornerRadius = 10
    
    return button
  }()
  


  
  // CreateTextField
  func createTextField(
    padding: CGFloat,
    placeholder: String,
    cornerRaduis: CGFloat,
    selector: Selector?) -> CustomTextField {
    
    let textField = CustomTextField(padding: padding, placeholder: placeholder,cornerRaduis: cornerRaduis)
    textField.delegate = self
    textField.textAlignment = .center
    
    guard let selector = selector else {return textField}
    textField.addTarget(self, action: selector, for: .editingChanged)
    
    return textField
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor =  #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    titleLabel.textAlignment = .center
  }
  
 
  
  
  // MARK: Bottom Buttons
  
  // CancelButton
  @objc  func handleCancelButton() {

  }
  
  // Add Button

  @objc  func handleSaveButton() {
    
  }
  

  
  
  
  func hideViewOnTheRightCorner() {

    self.transform = Constants.Animate.transformUpRightCorner
    self.alpha = 0

  }
  
  func hideViewUnderBottomInCenter() {
    self.transform = Constants.Animate.transformUnderBottomInCenter
    self.alpha = 0
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
}

// MARK: Views

extension AddNewElementView {
  
  func getBottomButtonStackView() -> UIStackView {
    
    let buttonsStackView = UIStackView(arrangedSubviews: [
      okButton,
      cancelButton
      ])
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing      = 5
    return buttonsStackView
  }
}


