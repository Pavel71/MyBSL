//
//  MealProductsFooterView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import UIKit


//class MealProductsFooterView : ProductListResultView {
//
//}

class MealProductsFooterView : UIView {

  lazy var insulinLabel : UILabel = createLabel(text: "")
  lazy var portionLabel : UILabel = createLabel(text: "")
  lazy var carboLabel   : UILabel = createLabel(text: "")
  lazy var totalLabel   : UILabel = createLabel(text: "Всего:")

  func createLabel(text: String) -> UILabel {
    let label = UILabel()
      label.font = UIFont(name: "DINCondensed-Bold", size: 18)
      label.text = text

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

// MARK: Set View Models
extension MealProductsFooterView {

  func setViewModel(viewModel: ProductListResultViewModelable) {


    insulinLabel.text = viewModel.sumInsulinValue
    carboLabel.text   = viewModel.sumCarboValue
    portionLabel.text = viewModel.sumPortionValue
  }
}

// MARK: Set Up Views
extension MealProductsFooterView {

  private func setUpViews() {

    totalLabel.textAlignment = .left


    let cellWidth = UIScreen.main.bounds.width - 40
    let rightStackWidth = CGFloat(cellWidth * 1.5) / 3
    

    let valueStackView = UIStackView(arrangedSubviews: [
      portionLabel,carboLabel,insulinLabel
    ])
    valueStackView.constrainWidth(constant: rightStackWidth)
    valueStackView.distribution = .fillEqually
    
    // Это нужно чтобы измежять ошибки с конс трайнтами
    
    addSubview(totalLabel)
    totalLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
    
    addSubview(valueStackView)
    valueStackView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10))


//    let stackView = UIStackView(arrangedSubviews: [
//
//      totalLabel,valueStackView
//    ])
//    stackView.distribution = .fill
//
//    addSubview(stackView)
//    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))

  }
}
