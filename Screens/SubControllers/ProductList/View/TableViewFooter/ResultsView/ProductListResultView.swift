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
  

  lazy var resultTitle = createResultLabel(name: "Всего:",fontSize: 20)
  
  lazy var carboResultLabel = createResultLabel(name: nil, fontSize: 18)
  lazy var portionResultLabel = createResultLabel(name: nil, fontSize: 18)
  lazy var insulinResultLabel = createResultLabel(name: nil, fontSize: 18)
  
  
  func createResultLabel(name: String?,fontSize: CGFloat) -> UILabel {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: fontSize)
    label.text = name ?? ""
    label.textColor = .lightGray
    label.textAlignment = .center
    return label
  }
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    resultTitle.textAlignment = .left
    
    let stackView = UIStackView(arrangedSubviews: [
      resultTitle,carboResultLabel,portionResultLabel,insulinResultLabel
      ])
    
    carboResultLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    portionResultLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    insulinResultLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.ProductList.marginCell)
    stackView.alignment = .top
    stackView.distribution = .fill
    stackView.spacing = 5
  }
  
  func setViewModel(viewModel:ProductListResultViewModelable, withInsulin: Bool = true) {
    
    carboResultLabel.text = viewModel.sumCarboValue
    portionResultLabel.text = viewModel.sumPortionValue
    insulinResultLabel.text = viewModel.sumInsulinValue
    
    if !withInsulin {
      insulinResultLabel.isHidden = true
    }
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
