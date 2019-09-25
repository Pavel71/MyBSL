//
//  ProductListHeaderInSection.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 13/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductListHeaderInSection: UIView {
  
  static let height: CGFloat = 35
  
  
  private let  carboInPortionLabel: UILabel = {
    let label = UILabel()
    label.text = "Углеводов в порции:"
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .center
    
    return label
  }()
  
  
  private let  portionLabel: UILabel = {
    let label = UILabel()
    label.text = "Порция гр."
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .center
    
    return label
  }()
  
  private let insulinLabel: UILabel = {
    
    let label = UILabel()
    label.text = "Инсулин ед."
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
    
  }()
  
  init(frame: CGRect,withInsulinLabel: Bool) {
    super.init(frame: frame)
    
    insulinLabel.isHidden = !withInsulinLabel

    
    let stackView = UIStackView(arrangedSubviews: [
      UIView(),carboInPortionLabel,portionLabel,insulinLabel
      ])
    
    carboInPortionLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    portionLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    insulinLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    
    stackView.distribution = .fill
    stackView.spacing = 5
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.ProductList.margin)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
