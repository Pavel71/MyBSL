//
//  MenuFoodListheaderInSection.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 18/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class MenuFoodListheaderInSectionView: UIView {
  
//  static let height: CGFloat = 30
  
  let sectionNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 18)
    label.textColor = UIColor.lightGray
    label.text = "Наименование:"
    return label
  }()
  
  private let carboLabel: UILabel = {
    let label = UILabel()

    label.numberOfLines = 0
    label.font = UIFont(name: "DINCondensed-Bold", size: 16)
    label.text = "Углеводы на 100гр."
    label.textColor = UIColor.lightGray

    label.textAlignment = .center
    return label
  }()
  
  private let portionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    
    label.font = UIFont(name: "DINCondensed-Bold", size: 16)
    label.text = "Порция"
    label.textColor = UIColor.lightGray
    
    label.alpha = 0
    label.textAlignment = .center
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
    
    
    let rightStackView = UIStackView(arrangedSubviews: [
      portionLabel,
      carboLabel
      ])
    
    rightStackView.distribution = .fillEqually
    rightStackView.spacing = 2
    
    let stackView = UIStackView(arrangedSubviews: [
      sectionNameLabel,
      rightStackView
      ])

    
    stackView.distribution = .fillEqually
    stackView.spacing = 2
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.cellMargin)
    
  }
  
  func showPortionLabel(isFavoritsSegment:Bool) {
    portionLabel.alpha = isFavoritsSegment ? 1:0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

