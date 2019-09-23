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
    label.textAlignment = .right
    
    return label
  }()
  
  
  private let  portionLabel: UILabel = {
    let label = UILabel()
    label.text = "Порция гр."
    label.font = UIFont.systemFont(ofSize: 10)
    label.numberOfLines = 0
    label.textAlignment = .right
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let stackView = UIStackView(arrangedSubviews: [
      UIView(),carboInPortionLabel,portionLabel
      ])
    
    carboInPortionLabel.constrainWidth(constant: 60)
    portionLabel.constrainWidth(constant: 60)
    stackView.distribution = .fill
    stackView.spacing = 5
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.Meal.ProductCell.margin)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
