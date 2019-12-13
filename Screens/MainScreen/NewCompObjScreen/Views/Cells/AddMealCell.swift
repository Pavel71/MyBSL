//
//  MealCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class AddMealCell: UITableViewCell {
  
  static let cellId = "AddMealCell"
  
  let titleLabel: UILabel = {
    
    let label = UILabel()
    label.text          = "Прием пищи"
    label.font          = UIFont.systemFont(ofSize: 18, weight: .semibold)
    label.textColor     = .white
    label.textAlignment = .center
    return label
    
  }()
  
  // Switcher Stack
  let needMealLable = CustomLabels(font: .systemFont(ofSize: 16), text: "Добавьте обед:")
  
  var mealSwitcher: UISwitch = {
    let switcher = UISwitch()
    switcher.isOn               = false
    switcher.tintColor          = .red
    switcher.backgroundColor    = .red
    switcher.layer.cornerRadius = 16
//    switcher.onTintColor     = .red
    return switcher
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    needMealLable.textAlignment = .left
    
    setUpViews()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up Views

extension AddMealCell {
  
  private func setUpViews() {
    
    
    let containerView = UIView()
    
    containerView.addSubview(mealSwitcher)
    mealSwitcher.centerInSuperview()
    
    let switcherStackView = UIStackView(arrangedSubviews: [
    needMealLable,containerView
    ])
    switcherStackView.distribution = .fillEqually
    switcherStackView.spacing = 5
    
    let overAllStackView = UIStackView(arrangedSubviews: [
    titleLabel,
    switcherStackView
    
    ])
    titleLabel.constrainHeight(constant: 20)
    overAllStackView.distribution = .fill
    overAllStackView.axis         = .vertical
    overAllStackView.spacing      = 10
    
    addSubview(overAllStackView)
    
    var cellPadding    = NewCompansationObjConstants.Cell.paddingInCell
    cellPadding.bottom = 15
    overAllStackView.fillSuperview(padding: cellPadding)
  }
}
