//
//  NewSugarDataView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class NewSugarDataView: AddNewElementView {
  
  
  
   static let sizeView : CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 160)
    
    // Labels
    
    
    
    let sugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар:")
    let correctionLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Коррекция:")
 
    // TextFields
    lazy var sugarTextField = createTextField(
      padding      : 5,
      placeholder  : "7.4",
      cornerRaduis : 10,
      selector     : #selector(textDidChanged))
  

  
  let correctionTextFieldWithButton = CustomCategoryTextField(
    padding: 5,
    placeholder: "0.5",
    cornerRaduis: 10,
    imageButton: #imageLiteral(resourceName: "robot32").withRenderingMode(.alwaysOriginal)
  )
  

  
  
  // Switch
  let activeOn: UISwitch = {
     let st = UISwitch()
     st.isOn        = false
     st.tintColor   = Constants.Color.lightBlueBackgroundColor
     st.onTintColor = Constants.Color.darKBlueBackgroundColor
     st.addTarget(self, action: #selector(handleSwitchActive), for: .valueChanged)
     return st
   }()
   

  
  var didTapSaveButtonClouser   : EmptyClouser?
  var didTapCancelButtonCLouser : EmptyClouser?
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureTextFields()
    
  
//    correctionTextField.rightView        = robotButton
//    correctionTextField.rightView?.frame = .init(x: 0, y: 0, width: 20, height: 20)
//    correctionTextField.rightViewMode    = .always
    
    setUpViews()
    
  }
  
  private func configureTextFields() {
    
    sugarTextField.keyboardType                 = .decimalPad
    sugarTextField.addDoneButtonOnKeyboard()
    
    correctionTextFieldWithButton.keyboardType  = .decimalPad
    correctionTextFieldWithButton.addDoneButtonOnKeyboard()
    correctionTextFieldWithButton.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    correctionTextFieldWithButton.rightButton.addTarget(self, action: #selector(handleRobotButton), for: .touchUpInside)
    
    correctionTextFieldWithButton.isHidden = true
    correctionTextFieldWithButton.alpha    = 0
    
  }
  
  // Clear Fields
  
  func clearAllFieldsInView() {
    sugarTextField.text = ""
  }
  
  // MARK: Handle Save and Cancel Button
  override func handleSaveButton() {
     didTapSaveButtonClouser!()
   }
   
   override func handleCancelButton() {
     self.superview?.endEditing(true)
     clearAllFieldsInView()
     didTapCancelButtonCLouser!()
   }
  

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}


// MARK: Set Up Views


extension NewSugarDataView {
  
  private func setUpViews() {
    
    let titleStackView = UIStackView(arrangedSubviews: [
    sugarLabel,
    correctionLabel
    ])
    titleStackView.spacing      = 5
    titleStackView.distribution = .fillEqually
    titleStackView.axis         = .vertical
    
//    let containerView = UIView()
//    containerView.addSubview(activeOn)
//    activeOn.centerInSuperview()
    
    let activeteCorrectTextFieldStackView = UIStackView(arrangedSubviews: [
    activeOn,correctionTextFieldWithButton
    ])
    
    activeteCorrectTextFieldStackView.spacing   = 5
    activeteCorrectTextFieldStackView.alignment = .center
    
    
    let textFieldStackView = UIStackView(arrangedSubviews: [
    sugarTextField,
    activeteCorrectTextFieldStackView
    ])
    
    textFieldStackView.spacing      = 5
    textFieldStackView.distribution = .fillEqually
    textFieldStackView.axis         = .vertical
    
    let middleStackView = UIStackView(arrangedSubviews: [
    titleStackView,textFieldStackView
    ])
    middleStackView.spacing      = 5
    middleStackView.distribution = .fillEqually
    
    let buttonStackView = getBottomButtonStackView()
    
    let overAllStackView = UIStackView(arrangedSubviews: [
    titleLabel,
    middleStackView,
    buttonStackView
    ])
    overAllStackView.spacing = 5
    overAllStackView.axis = .vertical
    
    titleLabel.constrainHeight(constant: 30)
    buttonStackView.constrainHeight(constant: 40)
    
    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
   
    
  }
  
  
  
}


// MARK: Handle RobotButton
extension NewSugarDataView {
  
  @objc private func handleRobotButton() {
    print("Robot Button")
  }
  
}

// MARK:Handle  Switch

extension NewSugarDataView {
  
  @objc private func handleSwitchActive(activatSwitch: UISwitch) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.correctionTextFieldWithButton.isHidden = !activatSwitch.isOn
      self.correctionTextFieldWithButton.alpha    =  activatSwitch.isOn ? 1 : 0
    }, completion: nil)
    
  }
  
}

// MARK: TextField Delegate

extension NewSugarDataView {
  // MARK: Text Did Change
   
   @objc private func  textDidChanged(textField: UITextField) {
     
     guard let text = textField.text else {return}
     // Передаем в модельку данные
     switch textField {
       
     case sugarTextField:
       print("TextField Change")
       
     default: break
     }
     
     
     
   }
}
