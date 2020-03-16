//
//  BaseProductListCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

protocol ProductListViewModelCell {
  
  var name: String {get set}
  var portion: Int {get set }
  var carboInPortion: Int {get}
  
  
  var insulinValue: Float? {get set}
  var correctInsulinValue: Float? {get set}
}

class BaseProductListCell: UITableViewCell {
  
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.Font.textFont
    label.textColor = Constants.Text.textColorDarkGray
    label.numberOfLines = 0
    return label
  }()
  
  var portionTextField: CustomValueTextField = {
    let textField = CustomValueTextField()
    textField.font = Constants.Font.valueFont
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.textAlignment = .center

    return textField
  }()
  
  let insulinTextField: CustomValueTextField = {
    let textField = CustomValueTextField(placeholder: "", cornerRadius: 10)
    textField.font = Constants.Font.valueFont
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    textField.textAlignment = .center
    
    return textField
  }()
  
//  let correctInsulinTextField: CustomValueTextField = {
//    let textField = CustomValueTextField(placeholder: "", cornerRadius: 10)
//    textField.font = Constants.Font.valueFont
//    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//    textField.textAlignment = .center
//
//    return textField
//  }()
  
  
  let carboInPortionLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.Font.valueFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = .center
    return label
  }()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    
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
  
  
  func setViewModel(viewModel: ProductListViewModelCell,withInsulinTextFields: Bool = false) {
    
    let portionString  = String(viewModel.portion)
    let carboInPortion = String(viewModel.carboInPortion)
    let insulinValue   = viewModel.insulinValue ?? 0
    
    nameLabel.text           = viewModel.name
    portionTextField.text    = portionString
    carboInPortionLabel.text = carboInPortion
    
    insulinTextField.isHidden = !withInsulinTextFields
    insulinTextField.text     = "\(floatTwo: insulinValue)"
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}

