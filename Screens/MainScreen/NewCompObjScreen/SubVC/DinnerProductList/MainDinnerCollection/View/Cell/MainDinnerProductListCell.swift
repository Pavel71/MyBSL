//
//  MainDinnerProductListCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 16.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

enum PickerViewSegment {
  
  case insulin
  case portion
}


class MainDinnerProductListCell: BaseProductListCell {
  
  static let cellId = "MainDinnerProductListCell.Id"
  

  
  // Pickers
  
  var insulinPickerView = InsulinPickerView()
  var portionPickerView = PortionPickerView()
  
  // CLousers
  
  var didBeginEditingTextField: TextFieldPassClouser?
  
  var didPortionTextFieldEditing: TextFieldPassClouser?
  var didInsulinTextFieldEditing: TextFieldPassClouser?
  
  
  var didChangeInsulinFromPickerView: TextFieldPassClouser?
  var didChangePortionFromPickerView: TextFieldPassClouser?
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    
    
    portionTextField.delegate = self
    insulinTextField.delegate = self
    
    // Set Picker View
    portionTextField.inputView = portionPickerView
    insulinTextField.inputView = insulinPickerView
    
    
    portionPickerView.passValueFromPickerView = {[weak self] value in
      
      
      self?.portionTextField.text = "\(Int(value))"
      self?.didChangePortionFromPickerView!(self!.portionTextField)
    }
    
    insulinPickerView.passValueFromPickerView = {[weak self] value in
      self?.insulinTextField.text = "\(value)"
      self?.didChangeInsulinFromPickerView!(self!.insulinTextField)
    }
    
//    pickerView.delegate = self
//    pickerView.dataSource = self
    
  }
  
  
  func setViewModel(viewModel: ProductListViewModelCell) {
    
    super.setViewModel(viewModel: viewModel,withInsulinTextFields: true)

    
  }
  
  
  // MARK: Work with Portion TextFields
  
  private func workWithPortionTextField(isPreviosDinner:Bool) {
    
    updateTextFieldIsPreviosDinner(
      textField: portionTextField,
      isPreviosDinner: isPreviosDinner
    )
    
  }
  
  // MARK: Work With ActualInsulin Fields
  
  private func workWithActualInsulinFields(
    viewModel:ProductListViewModelCell,
    isPreviosDinner: Bool
  ) {
    
    insulinTextField.text = viewModel.insulinValue == nil ? "" : "\(floatTwo: viewModel.insulinValue!)"

    
   //      updateTextFieldIsPreviosDinner(textField: insulinTextField, isPreviosDinner: isPreviosDinner)
    
  }
  
  // MARK: Update TextFields in Previos DInner
  private func updateTextFieldIsPreviosDinner(
    textField: CustomValueTextField,
    isPreviosDinner: Bool) {
    
    textField.isUserInteractionEnabled = !isPreviosDinner
    textField.textColor = isPreviosDinner ? .darkGray : #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.withCornerLayer = !isPreviosDinner
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}


// MARK: TextFields Delegate

extension MainDinnerProductListCell: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {

    switch textField {

    case insulinTextField:

      didInsulinTextFieldEditing!(textField)
      
      
//      setDefaultInsulinValue()
    case portionTextField:

      didPortionTextFieldEditing!(textField)
//      setDefaultPortionValue()
    default: break

    }

  }

  
  func textFieldDidBeginEditing(_ textField: UITextField) {
  
    // Отправляем в main Controller
    didBeginEditingTextField!(textField)
  }
  
}

// MARK: Accessuary View Signals

extension MainDinnerProductListCell {

  
  @objc private func doneButtonAction() {
    print("Done Button")
    self.endEditing(true)
  }
}
