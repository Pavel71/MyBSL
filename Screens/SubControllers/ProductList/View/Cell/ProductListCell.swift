//
//  ProductsInMealCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 02/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol ProductListViewModelCell {
  
  var name: String {get set}
  var portion: Int {get set }
  var carboInPortion: Int {get}
  var insulinValue: Float? {get set}
}

class ProductListCell: UITableViewCell {
  
  static let cellID = "Product Cell"

  
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.Font.textFont
    label.textColor = Constants.Text.textColorDarkGray
    label.numberOfLines = 0
    return label
  }()
  
  let portionTextField: UITextField = {
    let textField = CustomValueTextField()
    textField.font = Constants.Font.valueFont
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.textAlignment = .center
    textField.layer.borderColor = UIColor.lightGray.cgColor
    
    
    return textField
  }()
  
  let insulinTextField: UITextField = {
    let textField = CustomValueTextField(placeholder: "", cornerRadius: 10)
    textField.font = Constants.Font.valueFont
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.textAlignment = .center
    
    return textField
  }()
  

  let carboInPortionLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.Font.valueFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = .center
    return label
  }()
  
  
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
  
  
  // CLousers
  
  var didPortionTextFieldEditing: TextFieldPassClouser?
  var didInsulinTextFieldEditing: TextFieldPassClouser?
  var didBeginEditingTextField: TextFieldPassClouser?
  var didChangeInsulinFromPickerView: TextFieldPassClouser?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    
    portionTextField.keyboardType = .numberPad
    insulinTextField.keyboardType = .decimalPad
    
    portionTextField.delegate = self
    insulinTextField.delegate = self
    
    // Set Picker View
    insulinTextField.inputView = pickerView
    pickerView.delegate = self
    pickerView.dataSource = self
    
    let stackView = UIStackView(arrangedSubviews: [
      nameLabel,carboInPortionLabel,portionTextField,insulinTextField
      ])

    carboInPortionLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    portionTextField.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    insulinTextField.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    
    stackView.distribution = .fill
    stackView.spacing = 5
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.ProductList.marginCell)
    
    
  }
  
  
  // По сути здесь нужно узнавать если с инсулином то засеть еще и инсулин
  // То что эта ячейка юзает и в диннер и в меню это не парвельно конечно нужно создать базовый класс для ячеек и потом добавлять что то в них или убавлять!

  func setViewModel(viewModel: ProductListViewModelCell,withInsulinTextFields: Bool, isPreviosDinner: Bool = false) {
    
    let portionString = String(viewModel.portion)
    let carboInPortion = String(viewModel.carboInPortion)
    
    nameLabel.text = viewModel.name
    portionTextField.text = portionString
    carboInPortionLabel.text = carboInPortion
    
    insulinTextField.isHidden = !withInsulinTextFields
    portionTextField.isUserInteractionEnabled = !isPreviosDinner
    portionTextField.textColor = isPreviosDinner ? .lightGray : #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    // Здесь нужна логика установки Insulina!
    

    

  }
  


  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  var resultCompTens: Float = 0
  var resultCompSimple: Float = 0
  var resultComDrob: Float = 0
}


extension ProductListCell: UIPickerViewDelegate, UIPickerViewDataSource {
  
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
      resultCompTens = Float(pickerData[component][row]) as! Float
    case 1:
      resultCompSimple = Float(pickerData[component][row]) as! Float
    case 2:
      resultComDrob = Float(pickerData[component][row]) as! Float
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

extension ProductListCell: UITextFieldDelegate {
  
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


