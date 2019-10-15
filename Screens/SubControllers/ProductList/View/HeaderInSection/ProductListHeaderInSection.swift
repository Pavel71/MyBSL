//
//  ProductListHeaderInSection.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 13/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductListHeaderInSection: UIView {
  
//  static let height: CGFloat = 35
  
  
  private let  carboInPortionLabel: UILabel = {
    let label = UILabel()
    label.text = "Углеводы"
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .center
    
    
    return label
  }()
  
  
  private let  portionLabel: UILabel = {
    let label = UILabel()
    label.text = "Порция"
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .center
    
    return label
  }()
  
  private let insulinLabel: UILabel = {
    
    let label = UILabel()
    label.text = "Инсулин"
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
    
  }()
  

  
  init(withInsulinLabel: Bool,temaColor: UIColor) {
    super.init(frame: .zero)
    
    insulinLabel.textColor = temaColor
    portionLabel.textColor = temaColor
    carboInPortionLabel.textColor = temaColor
    
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
    stackView.fillSuperview(padding: Constants.ProductList.marginCell)
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
