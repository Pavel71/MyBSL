//
//  FoodMealProductListCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 16.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class FoodMealProductListCell: BaseProductListCell {
  
  static let cellId = "FoodMealProductListCell.Id"
  
  // CLousers
  var didPortionTextFieldEditing: TextFieldPassClouser?
  var didBeginEditingTextField: TextFieldPassClouser?
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    portionTextField.keyboardType = .numberPad
    portionTextField.delegate = self
    
  }
  
  override func setViewModel(viewModel: ProductListViewModelCell, withInsulinTextFields: Bool = false) {
    super.setViewModel(viewModel: viewModel, withInsulinTextFields: withInsulinTextFields)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

extension FoodMealProductListCell: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    didPortionTextFieldEditing!(textField)
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditingTextField!(textField)
  }
  
}
