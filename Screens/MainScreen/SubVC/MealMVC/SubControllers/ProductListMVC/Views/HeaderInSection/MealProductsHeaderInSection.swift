//
//  MealProductsHeaderInSection.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealProductsHeaderInSection: UIView {
  
  lazy  var insulinLabel : UILabel = createLabel(text: "Инсулин")
  lazy  var portionLabel : UILabel = createLabel(text: "Порция")
  lazy  var carboLabel   : UILabel = createLabel(text: "Углеводы")

  func createLabel(text: String) -> UILabel {
    let label = UILabel()
      label.font = UIFont(name: "DINCondensed-Bold", size: 15)
      label.text = text
      label.textColor = UIColor.lightGray
      label.textAlignment = .center
      return label
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up Views

extension MealProductsHeaderInSection {
  
  private func setUpViews() {
    
    let cellWidth = UIScreen.main.bounds.width - 40
    let rightStackWidth = CGFloat(cellWidth * 1.5) / 3
    
    let valueStackView = UIStackView(arrangedSubviews: [
      portionLabel,carboLabel,insulinLabel
    ])
    valueStackView.constrainWidth(constant: rightStackWidth)
    valueStackView.distribution = .fillEqually
    
    
    let stackView = UIStackView(arrangedSubviews: [
    
      UIView(),valueStackView
    ])
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
}
