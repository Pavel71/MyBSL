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
  
  // TextFields
  lazy var sugarTextField = createTextField(
    padding      : 5,
    placeholder  : "7.4",
    cornerRaduis : 10,
    selector     : nil)
  
  
  
  
  // CLousers
  var didTapSaveButtonClouser   : ((SugarViewModel) -> Void)?
  var didTapCancelButtonCLouser : EmptyClouser?
  
  // Validator
  var newSugarViewValidator = NewSugarViewValidator()
  
  // Custom Picker View
  let sugarPickerView = SugarPickerView(frame: .init(x: 0, y: 0, width: 0, height: 200))
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .orange
    
    setValidatorClouser()
    configureTextFields()
//    configurePickerView()
    setUpViews()
    
  }
  
  private func setValidatorClouser() {
    newSugarViewValidator.isValidCallBack = {[weak self] isCanSave in
      self?.validateSugarTextField(isCanSave:isCanSave)
      
    }
  }
  
  // Configure PickerView
//  private func configurePickerView() {
//    sugarTextField.inputView    = sugarPickerView
//    // Set Clouser
//    sugarPickerView.passValueFromPickerView = {[weak self] sugar in
//      self?.catchValueFromPickerView(value: sugar)
//       }
//  }
  // Configure TextFields
  private func configureTextFields() {
    sugarTextField.delegate       = self
    sugarTextField.keyboardType   = .decimalPad
    sugarTextField.addDoneButtonOnKeyboard()
   
    
  }
  
  // Clear Fields
  
  func clearAllFieldsInView() {
    sugarTextField.text = ""
    newSugarViewValidator.setDefault()
  }
  
  // MARK: Handle Save and Cancel Button
  override func handleSaveButton() {
   
    let sugarVM = getSugarViewModel()
    // Здесь мне нужно собрать моделичку и отправить е в контроллер для передачи данных
    didTapSaveButtonClouser!(sugarVM)
    handleCancelButton()
    
  }
  
  override func handleCancelButton() {
    self.superview?.endEditing(true)
    clearAllFieldsInView()
    didTapCancelButtonCLouser!()
  }
  
  // MARK: Get ViewModel
  
  private func getSugarViewModel() -> SugarViewModel {
    let sugarFloat = (sugarTextField.text! as NSString).doubleValue
    
    return SugarViewModel(dataCase: .sugarData, sugar: sugarFloat, time: Date())
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
      
    ])
    titleStackView.spacing      = 5
    titleStackView.distribution = .fillEqually
    titleStackView.axis         = .vertical
    
    
    let textFieldStackView = UIStackView(arrangedSubviews: [
      sugarTextField,
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




// MARK: Validate TextField

extension NewSugarDataView {
  
  private func validateSugarTextField(isCanSave: Bool) {
    
    okButton.isEnabled         = isCanSave
    
    if isCanSave {
      okButton.backgroundColor =  #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      okButton.setTitleColor(.white, for: .normal)
    } else {
      okButton.backgroundColor =  .lightGray
      okButton.setTitleColor(.black, for: .disabled)
    }
  }
  
}


// MARK: TextField Delegate
extension NewSugarDataView {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let sugar = textField.text else {return}
    let sugarFloat = (sugar as NSString).doubleValue
    catchValueFromPickerView(value: sugarFloat)
  }
  
}

// MARK: Picker View Value Catch
extension NewSugarDataView {
  
  private func catchValueFromPickerView(value: Double) {
    
    if  value != 0 {
      newSugarViewValidator.sugar = String(value)
      sugarTextField.text         = String(value)
    } else {
      newSugarViewValidator.sugar = ""
      sugarTextField.text         = ""
    }
    
  }
  
}









//       let correctionPosition = newSugarViewValidator.getWayCompansation()
//
//       switch correctionPosition {
//         case .correctDown:
//          print("Показать коррекцию с шприцом и текстфилдом с роботом для вводва коррекции инсулина")
//         case .correctUp:
//          print("Показать Коррекцию и картинку с продуктом + кнопку переход к добавлению обеда")
//         case .dontCorrect:
//          print("ничего не делаем! просто подтверждаем валидацию и разрешаем сохранить")
//         default: break
//      }
