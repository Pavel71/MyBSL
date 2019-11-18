//
//  DinnerCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class DinnerCell: UITableViewCell {
  
  static let cellId = "DinnerCell"
  
  
//  let nameLabel: UILabel = {
//    let label = UILabel()
//    label.font = Constants.Font.textFont
//    label.textColor = Constants.Text.textColorDarkGray
//    label.numberOfLines = 0
//    return label
//  }()
  
  lazy var nameLabel: UILabel = createLabel(textAligment: .left)
  lazy var carboInPortionLabel: UILabel = createLabel()
  lazy var portionLabel: UILabel = createLabel()
  lazy var insulinLabel: UILabel = createLabel()
  
  func createLabel(textAligment:NSTextAlignment = .center) -> UILabel {
    let label = UILabel()
    label.font = Constants.Font.textFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = textAligment
    label.numberOfLines = 0
    return label
  }
  
//  var portionTextField: CustomValueTextField = {
//    let textField = CustomValueTextField()
//    textField.font = Constants.Font.valueFont
//    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//    textField.textAlignment = .center
//
//    return textField
//  }()
//
//  let insulinTextField: CustomValueTextField = {
//    let textField = CustomValueTextField(placeholder: "", cornerRadius: 10)
//    textField.font = Constants.Font.valueFont
//    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//    textField.textAlignment = .center
//
//    return textField
//  }()
//
//  let correctInsulinTextField: CustomValueTextField = {
//    let textField = CustomValueTextField(placeholder: "", cornerRadius: 10)
//    textField.font = Constants.Font.valueFont
//    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//    textField.textAlignment = .center
//
//    return textField
//  }()
//
//
//  let carboInPortionLabel: UILabel = {
//    let label = UILabel()
//    label.font = Constants.Font.valueFont
//    label.textColor = Constants.Text.textColorDarkGray
//    label.textAlignment = .center
//    return label
//  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set Up Views

extension DinnerCell {
  
  private func setUpViews() {
    
    
    let cellWidth = UIScreen.main.bounds.width - 40
    let rightStackWidth = CGFloat(cellWidth * 1.5) / 3
    
    let valueStackView = UIStackView(arrangedSubviews: [
      carboInPortionLabel,portionLabel,insulinLabel
    ])
    valueStackView.constrainWidth(constant: rightStackWidth)
    
    
    let stackView = UIStackView(arrangedSubviews: [
    
      nameLabel,valueStackView
    ])
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
}
