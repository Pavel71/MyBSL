//
//  MenuFoodListheaderInSection.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 18/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class MenuFoodListheaderInSectionView: UIView {
  
  static let height: CGFloat = 30
  
  let sectionNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 16)
    label.textColor = UIColor.lightGray
    label.text = "Наименование:"
    return label
  }()
  
  private let rightLabel: UILabel = {
    let label = UILabel()


    label.font = UIFont(name: "DINCondensed-Bold", size: 14)
    label.text = "Углеводы на 100гр."
    label.textColor = UIColor.lightGray

    label.textAlignment = .right
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    let backGroundContanerViwe = UIView()
    backGroundContanerViwe.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    backGroundContanerViwe.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    backGroundContanerViwe.clipsToBounds = true
    addSubview(backGroundContanerViwe)
    backGroundContanerViwe.fillSuperview(padding: .init(top: 3, left: 5, bottom: 5, right: 5))
    
    
    let stackView = UIStackView(arrangedSubviews: [
      sectionNameLabel,
      rightLabel
      ])
//    rightLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
    
    
    stackView.distribution = .fillEqually
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

