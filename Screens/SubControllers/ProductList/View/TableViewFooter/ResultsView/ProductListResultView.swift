//
//  DinnerItemsResultView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// View которая будет коппировать хедар только с низу и аккамулировать рещультат все числовых textFieldof


protocol ProductListResultViewModelable {
  
  var sumCarboValue: String {get}
  var sumPortionValue: String {get}
  var sumInsulinValue: String {get}
  
}

class ProductListResultView: UIView {
  

  lazy var resultTitle = createResultLabel(name: "Всего:",fontSize: 18)
  
  lazy var carboResultLabel = createResultLabel(name: nil, fontSize: 16)
  lazy var portionResultLabel = createResultLabel(name: nil, fontSize: 16)
  lazy var insulinResultLabel = createResultLabel(name: nil, fontSize: 16)
  
  
  func createResultLabel(name: String?,fontSize: CGFloat) -> UILabel {
    let label = UILabel()

    label.font = UIFont.systemFont(ofSize: fontSize)
    label.text = name ?? ""
    label.textAlignment = .center
    return label
  }
  
  // MARK: Constraint Property
  var portionTrailingConstraint: NSLayoutConstraint!
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    
    carboResultLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    portionResultLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    insulinResultLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    

    
    addSubview(insulinResultLabel)
    insulinResultLabel.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: Constants.ProductList.marginCell.right))
    
    
    
    addSubview(portionResultLabel)
    portionResultLabel.anchor(top: topAnchor, leading:nil , bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 5))
    
    portionTrailingConstraint = portionResultLabel.trailingAnchor.constraint(equalTo: insulinResultLabel.leadingAnchor,constant: -5)
    portionTrailingConstraint.isActive = true
  

    
    addSubview(carboResultLabel)
    carboResultLabel.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: portionResultLabel.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5))
    
    addSubview(resultTitle)
    resultTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: Constants.ProductList.marginCell.left, bottom: 0, right: 0))
    
    
  }
  
  func setTextColor(color: UIColor) {
    resultTitle.textColor = color
    carboResultLabel.textColor = color
    portionResultLabel.textColor = color
    insulinResultLabel.textColor = color
  }
  
  func setViewModel(viewModel:ProductListResultViewModelable, withInsulin: Bool = true) {
    
    
    carboResultLabel.text = viewModel.sumCarboValue
    portionResultLabel.text = viewModel.sumPortionValue
    insulinResultLabel.text = viewModel.sumInsulinValue
    
    if !withInsulin {
      insulinResultLabel.isHidden = true
      
      // Выключаем старый констраинт и подключаем новый!
      portionTrailingConstraint.isActive = false
      portionResultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -Constants.ProductList.marginCell.right).isActive = true

    }

  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
