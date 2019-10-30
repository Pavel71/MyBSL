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
  
  // Picker View
  let pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.backgroundColor = .white
    pickerView.frame = CGRect(x: 0, y: 0, width: 0, height: 250)
    return pickerView
  }()
  
  var currentPickerSegment: PickerViewSegment!
  
  
  let pickerPortionData = [
    ["0","100","200","300","400","500","600","700","800","900","1000"],
    ["0","10","20","30","40","50","60","70","80","90"],
    ["0","1","2","3","4","5","6","7","8","9"]
  ]
  
  let pickerInsulinData = [
    ["0.0","10.0","20.0","30.0","40.0","50.0","60.0","70.0","80.0","90.0","100.0"],
    ["0.0","0.5","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5","7.0","7.5","8.0","8.5","9.0","9.5"],
    ["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9"]
  ]
  
  // Picker View
  
  // Results Insulin
  var resultInsulinCompTens: Float = 0
  var resultInsulinCompSimple: Float = 0
  var resultInsulinComDrob: Float = 0
  
  // Results Portion
  var resultPortionCompTens: Float = 0
  var resultIPortionCompSimple: Float = 0
  var resultPortionComHundred: Float = 0
  
  
  // CLousers
  
  var didBeginEditingTextField: TextFieldPassClouser?
  
  var didPortionTextFieldEditing: TextFieldPassClouser?
  var didInsulinTextFieldEditing: TextFieldPassClouser?
  
  
  var didChangeInsulinFromPickerView: TextFieldPassClouser?
  var didChangePortionFromPickerView: TextFieldPassClouser?
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    portionTextField.keyboardType = .numberPad
    insulinTextField.keyboardType = .decimalPad
    
    portionTextField.delegate = self
    insulinTextField.delegate = self
    
    // Set Picker View
    portionTextField.inputView = pickerView
    insulinTextField.inputView = pickerView
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
  }
  
  
  func setViewModel(viewModel: ProductListViewModelCell, withInsulinTextFields: Bool = true, isPreviosDinner: Bool) {
    
    super.setViewModel(viewModel: viewModel, withInsulinTextFields: withInsulinTextFields)
    
    
    
    portionTextField.isUserInteractionEnabled = !isPreviosDinner
    portionTextField.textColor = isPreviosDinner ? .lightGray : #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    // При сети данных из модели мы должны их прокинуть для валидатора
//    didChangePortionFromPickerView!(portionTextField)
//    didChangePortionFromPickerView!(insulinTextField)
    
    
    guard let insulinValue = viewModel.insulinValue else {return}
    
    let insuLinString = insulinValue == 0 ? "" : "\(insulinValue)"
    insulinTextField.text = insuLinString
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

extension MainDinnerProductListCell: UIPickerViewDelegate, UIPickerViewDataSource {
  
  
  private func getDataToCurrentPickerSegment(pickerSegment: PickerViewSegment) -> [[String]] {
    
    switch pickerSegment {
    case .insulin:
      return pickerInsulinData
      
    case .portion:
      return pickerPortionData
    }
  }
  

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
    let data = getDataToCurrentPickerSegment(pickerSegment: currentPickerSegment)
    
    return data.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
     let data = getDataToCurrentPickerSegment(pickerSegment: currentPickerSegment)
    return data[component].count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let data = getDataToCurrentPickerSegment(pickerSegment: currentPickerSegment)
    
    return data[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    switch currentPickerSegment {
    case .insulin?:
      changeInsulin(component: component, row: row)
    case .portion?:
      changePortion(component: component, row: row)
    case .none:break
    }

    
  }
  
  private func changeInsulin(component: Int,row: Int) {
    switch component {
    case 0:
      
      resultInsulinCompTens = (pickerInsulinData[component][row] as NSString).floatValue
    case 1:
      resultInsulinCompSimple = (pickerInsulinData[component][row] as NSString).floatValue
    case 2:
      resultInsulinComDrob = (pickerInsulinData[component][row] as NSString).floatValue
    default:break
    }
    
    let value = resultInsulinCompTens + resultInsulinCompSimple + resultInsulinComDrob
    
    insulinTextField.text = String(value)
    
    
    // Делаем изменнеие как будто пишем текстом
    didChangeInsulinFromPickerView!(insulinTextField)
  }
  
  private func changePortion(component: Int,row: Int) {
    
    switch component {
    case 0:
      
      resultPortionComHundred = (pickerPortionData[component][row] as NSString).floatValue
    case 1:
      resultPortionCompTens = (pickerPortionData[component][row] as NSString).floatValue
    case 2:
      resultIPortionCompSimple = (pickerPortionData[component][row] as NSString).floatValue
    default:break
    }
    
    let value = resultPortionComHundred + resultPortionCompTens + resultIPortionCompSimple
    
    portionTextField.text = String(Int(value))

    // Нужно прокинуть PortionTextField срфтпу
    // Делаем изменнеие как будто пишем текстом
    
//    didChangeInsulinFromPickerView!(insulinTextField)
    didChangePortionFromPickerView!(portionTextField)
    
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
      setDefaultInsulinValue()
    case portionTextField:
      
      didPortionTextFieldEditing!(textField)
      setDefaultPortionValue()
    default: break

    }

  }
  
  private func setDefaultPortionValue() {
    resultPortionCompTens    = 0
    resultIPortionCompSimple = 0
    resultPortionComHundred  = 0
  }
   
  
  private func setDefaultInsulinValue() {
    resultInsulinCompTens   = 0
    resultInsulinCompSimple = 0
    resultInsulinComDrob    = 0
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    switch textField {
      
    case insulinTextField:
      
      currentPickerSegment = .insulin
      
    case portionTextField:
      
      currentPickerSegment = .portion
      
    default: break
      
    }
    
    pickerView.selectRow(0, inComponent: 0, animated: false)
    pickerView.selectRow(0, inComponent: 1, animated: false)
    pickerView.selectRow(0, inComponent: 2, animated: false)
    
    pickerView.reloadAllComponents()
    // Отправляем в main Controller
    didBeginEditingTextField!(textField)
  }
  
}
