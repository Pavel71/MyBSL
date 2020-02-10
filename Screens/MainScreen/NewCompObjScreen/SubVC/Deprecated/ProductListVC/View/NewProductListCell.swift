//
//  NewProductListCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class NewProductListCell: BaseProductListCell {
  
  static let cellId = "NewProductListCell"
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  
  
  override func setViewModel(
    viewModel: ProductListViewModelCell,
    withInsulinTextFields: Bool) {
    
    
    let portionString = String(viewModel.portion)
    let carboInPortion = String(viewModel.carboInPortion)

    nameLabel.text = viewModel.name
    portionTextField.text = portionString
    carboInPortionLabel.text = carboInPortion
    
    insulinTextField.isHidden = !withInsulinTextFields
    correctInsulinTextField.isHidden = !withInsulinTextFields
    
  }
  
  
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
  
}
