//
//  MainDinnerProductListCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 16.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MainDinnerProductListCell: BaseProductListCell {
  
  static let cellId = "MainDinnerProductListCell.Id"
  
  // Picker View
  let pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.backgroundColor = .white
    pickerView.frame = CGRect(x: 0, y: 0, width: 0, height: 250)
    return pickerView
  }()
  
  let pickerData = [
    ["0.0","10.0","20.0","30.0","40.0","50.0","60.0","70.0","80.0","90.0","100.0"],
    ["0.0","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5","7.0","7.5","8.0","8.5","9.0","9.5"],
    ["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9"]
  ]
  
  // Picker View
  var resultCompTens: Float = 0
  var resultCompSimple: Float = 0
  var resultComDrob: Float = 0
  
  
  // CLousers
  
  var didPortionTextFieldEditing: TextFieldPassClouser?
  var didInsulinTextFieldEditing: TextFieldPassClouser?
  var didBeginEditingTextField: TextFieldPassClouser?
  var didChangeInsulinFromPickerView: TextFieldPassClouser?
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    portionTextField.keyboardType = .numberPad
    insulinTextField.keyboardType = .decimalPad
    
    portionTextField.delegate = self
    insulinTextField.delegate = self
    
    // Set Picker View
    insulinTextField.inputView = pickerView
    pickerView.delegate = self
    pickerView.dataSource = self
    
  }
  
  
  func setViewModel(viewModel: ProductListViewModelCell, withInsulinTextFields: Bool = true, isPreviosDinner: Bool) {
    super.setViewModel(viewModel: viewModel, withInsulinTextFields: withInsulinTextFields)
    
    portionTextField.isUserInteractionEnabled = !isPreviosDinner
    portionTextField.textColor = isPreviosDinner ? .lightGray : #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

extension MainDinnerProductListCell: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return pickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    
    
    switch component {
    case 0:

      resultCompTens = (pickerData[component][row] as NSString).floatValue
    case 1:
      resultCompSimple = (pickerData[component][row] as NSString).floatValue
    case 2:
      resultComDrob = (pickerData[component][row] as NSString).floatValue
    default:break
    }
    
    let value = resultCompTens + resultCompSimple + resultComDrob
    
    insulinTextField.text = String(value)
    // Делаем изменнеие как будто пишем текстом
    didChangeInsulinFromPickerView!(insulinTextField)
    
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    switch component {
    case 1:
      return UIScreen.main.bounds.width / 2
    default:break
    }
    return UIScreen.main.bounds.width / 4
  }
  
  
  
  
}

extension MainDinnerProductListCell: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    switch textField {
      
    case insulinTextField:
      didInsulinTextFieldEditing!(textField)
      
    case portionTextField:
      didPortionTextFieldEditing!(textField)
      
    default: break
      
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditingTextField!(textField)
  }
  
}
