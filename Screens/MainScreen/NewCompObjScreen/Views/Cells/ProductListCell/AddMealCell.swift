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
  
  // Product List
  var productListViewController = NewProductListVC()
  
  // Add Product Button
  let addNewProductInMealButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor.white
    button.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    return button
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
  
  var switcherStackView: UIStackView!
  
}

// MARK: Set Up Views

extension AddMealCell {
  
  private func setUpViews() {
    
    setUpSwitcher()
    
    setOverAllStackViews()
    setUpAddButton()
  }
  
  // ADd Products Button
  
  private func setUpAddButton() {
    
    addNewProductInMealButton.addTarget(self, action: #selector(handleAddNewProduct), for: .touchUpInside)
    
    addNewProductInMealButton.clipsToBounds = true
    addNewProductInMealButton.layer.cornerRadius = Constants.ProductList.TableFooterView.addButtonHeight / 2
    
    addSubview(addNewProductInMealButton)
    addNewProductInMealButton.anchor(top: productListViewController.view.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -25, left: 0, bottom: 0, right: 0))
    addNewProductInMealButton.centerXAnchor.constraint(equalTo: productListViewController.view.centerXAnchor).isActive = true
    
    
    addNewProductInMealButton.constrainHeight(constant: Constants.ProductList.TableFooterView.addButtonHeight)
    addNewProductInMealButton.constrainWidth(constant: Constants.ProductList.TableFooterView.addButtonHeight)
  }
  
  private func setOverAllStackViews() {
    
    let overAllStackView = UIStackView(arrangedSubviews: [
    titleLabel,
    switcherStackView,
    productListViewController.view
    ])
    titleLabel.constrainHeight(constant: ProductListCellHeightWorker.titleHeight)
    overAllStackView.distribution = .fill
    overAllStackView.axis         = .vertical
    overAllStackView.spacing      = 15
    
    addSubview(overAllStackView)

    overAllStackView.fillSuperview(padding: ProductListCellHeightWorker.padding)
  }
  
  // Switecher Row
  
  private func setUpSwitcher() {
    
    let containerView = UIView()
    
    containerView.addSubview(mealSwitcher)
    mealSwitcher.centerInSuperview()
    
    switcherStackView = UIStackView(arrangedSubviews: [
    needMealLable,containerView
    ])
    switcherStackView.distribution = .fillEqually
    switcherStackView.spacing = 5
    
  }
}

// Catch Signals
extension AddMealCell {
  
  @objc private func handleAddNewProduct() {
    print("Add new Product")
  }
}
