//
//  MainMenuProductListCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class MainMenuProductListCell: BaseProductListCell {
  
  static let cellId = "CellId"
  

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    portionTextField.isUserInteractionEnabled = false
    portionTextField.backgroundColor = .clear
    portionTextField.withCornerLayer = false
    
    portionTextField.textColor = .white
    carboInPortionLabel.textColor = .white
    nameLabel.textColor = .white
  }

  
  
  override func setViewModel(viewModel: ProductListViewModelCell,withInsulinTextFields: Bool = false) {
    super.setViewModel(viewModel: viewModel, withInsulinTextFields: withInsulinTextFields)
    
    // Здесь я уже пишу что нужно сделать!
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
