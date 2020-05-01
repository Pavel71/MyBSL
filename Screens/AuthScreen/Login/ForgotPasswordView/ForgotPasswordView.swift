//
//  ForgotPasswordView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



class ForgotPasswordView: AddNewElementView {
  
  static let sizeView : CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 160)
  
  lazy var inputEmaiTextField = createTextField(
    padding: 10,
    placeholder: "Email",
    cornerRaduis: 10,
    selector: #selector(emailTextFieldEditing))
  
  lazy var bottomButtonsStackView = getBottomButtonStackView()
  
  
  
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    titleLabel.text = "Введите email для восстановления пароля"
    titleLabel.numberOfLines = 0

    configureTextFields()
    
    setUpViews()
    
  }
  
  
  // Configure TextFields
  private func configureTextFields() {
    inputEmaiTextField.delegate       = self
    inputEmaiTextField.keyboardType   = .emailAddress

    
  }
  
  // Clear Fields
  
  func clearAllFieldsInView() {
    inputEmaiTextField.text = ""
//    newSugarViewValidator.setDefault()
  }
  
  // MARK: Handle Save and Cancel Button
  
  var didTapSaveButtonClouser: StringPassClouser?
  override func handleSaveButton() {
   
    
    guard let email = inputEmaiTextField.text else {return}
    didTapSaveButtonClouser!(email)
    handleCancelButton()
    
  }
  
  var didTapCancelButtonCLouser: EmptyClouser?
  override func handleCancelButton() {
    
    self.superview?.endEditing(true)
    
    clearAllFieldsInView()
    didTapCancelButtonCLouser!()
  }
  
  var didInputEmailChanging: StringPassClouser?
  @objc private func emailTextFieldEditing(textField: UITextField) {
    guard let text = textField.text else {return}
    didInputEmailChanging!(text)
    // Нужно настроить валидацию того что емаил корректный
  }
  
  func validateInputEmailToResetPasswordTextField(isCanSave: Bool) {
     
     okButton.isEnabled         = isCanSave
     
     if isCanSave {
       okButton.backgroundColor =  #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
       okButton.setTitleColor(.white, for: .normal)
     } else {
       okButton.backgroundColor =  .lightGray
       okButton.setTitleColor(.black, for: .disabled)
     }
   }
  
  
  

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up Views
extension ForgotPasswordView {
  
  private func setUpViews() {
    
    let verticalStackView = VerticalStackView(arrangedSubviews: [
    titleLabel,
    inputEmaiTextField,
    bottomButtonsStackView
    ], customSpacing: 10)
    
    bottomButtonsStackView.constrainHeight(constant: 40)
    
    verticalStackView.distribution = .fill
    
    addSubview(verticalStackView)
    verticalStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
  
//  private func setUpGradientlayer() {
//
//    let topColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
//    let bottomColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor ]
//    gradientLayer.locations = [0,1]
//
//    layer.addSublayer(gradientLayer)
//
//
//  }
  
}


