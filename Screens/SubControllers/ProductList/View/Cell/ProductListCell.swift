//
//  ProductsInMealCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 02/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol ProductViewModelCell {
  var name: String {get}
  var portion: String {get}
  var carboInPortion: String {get}
}

class ProductListCell: UITableViewCell {
  
  static let cellID = "Product Cell"

  
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 20)
    label.textColor = .lightGray
    label.numberOfLines = 0
    return label
  }()
  
  let portionTextField: UITextField = {
    let textField = CustomValueTextField()
    textField.font = UIFont(name: "DINCondensed-Bold", size: 18)
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.textAlignment = .center
    
    
    return textField
  }()
  
  let insulinTextField: UITextField = {
    let textField = CustomValueTextField(placeholder: "2.5", cornerRadius: 10)
    textField.font = UIFont(name: "DINCondensed-Bold", size: 18)
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.textAlignment = .center
    
    return textField
  }()
  

  let carboInPortionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 18)
    label.textColor = .lightGray
    label.textAlignment = .center
    return label
  }()
  
  
  // CLousers
  
  var didPortionTextFieldEditing: TextFieldPassClouser?
  var didInsulinTextFieldEditing: TextFieldPassClouser?
  var didBeginEditingTextField: TextFieldPassClouser?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    portionTextField.keyboardType = .numberPad
    insulinTextField.keyboardType = .decimalPad
    
    portionTextField.delegate = self
    insulinTextField.delegate = self
    
    let stackView = UIStackView(arrangedSubviews: [
      nameLabel,carboInPortionLabel,portionTextField,insulinTextField
      ])

    carboInPortionLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    portionTextField.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    insulinTextField.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    
    stackView.distribution = .fill
    stackView.spacing = 5
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.ProductList.margin)
    
    
  }
  

  func setViewModel(viewModel: ProductViewModelCell,withInsulinTextFields: Bool) {
    
    nameLabel.text = viewModel.name
    portionTextField.text = viewModel.portion
    carboInPortionLabel.text = viewModel.carboInPortion
    
    insulinTextField.isHidden = !withInsulinTextFields

  }


  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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


