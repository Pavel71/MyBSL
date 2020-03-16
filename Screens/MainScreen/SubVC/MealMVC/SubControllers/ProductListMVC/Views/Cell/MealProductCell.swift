//
//  DinnerCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MealProductCellable {
  
  var name           : String {get set}
  var carboInPortion : Float  {get set}
  var portion        : Int    {get set}
  var factInsulin    : Float  {get set}
  
}

class MealProductCell: UITableViewCell {
  
  static let cellId = "DinnerCell"
  
  
  lazy var nameLabel: UILabel           = createLabel(textAligment: .left)
  lazy var carboInPortionLabel: UILabel = createLabel()
  lazy var portionLabel: UILabel        = createLabel()
  lazy var insulinLabel: UILabel        = createLabel()
  
  func createLabel(textAligment:NSTextAlignment = .center) -> UILabel {
    let label = UILabel()
    label.font = Constants.Font.textFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = textAligment
    label.numberOfLines = 0
    return label
  }
  

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set ViewModel

extension MealProductCell {
  func setViewModel(viewModel: MealProductCellable) {
    
    nameLabel.text           = viewModel.name
    carboInPortionLabel.text = String(viewModel.carboInPortion)
    portionLabel.text        = String(viewModel.portion)
    insulinLabel.text        = String(viewModel.factInsulin)
  }
}

// MARK: Set Up Views

extension MealProductCell {
  
  private func setUpViews() {
    
    
    let cellWidth = UIScreen.main.bounds.width - 40
    let rightStackWidth = CGFloat(cellWidth * 1.5) / 3
    
    let valueStackView = UIStackView(arrangedSubviews: [
      portionLabel,carboInPortionLabel,insulinLabel
    ])
    valueStackView.constrainWidth(constant: rightStackWidth)
    valueStackView.distribution = .fillEqually
    
    let stackView = UIStackView(arrangedSubviews: [
    
      nameLabel,valueStackView
    ])
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
}
