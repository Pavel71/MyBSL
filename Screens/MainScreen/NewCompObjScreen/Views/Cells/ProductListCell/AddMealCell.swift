//
//  MealCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol AddMealCellable {
  
  var isSwitcherIsEnabled  : Bool {get set}
  var cellState            : AddMealCellState        {get set}
  var dinnerProductListVM  : ProductListInDinnerViewModel {get set}
}


enum AddMealCellState {
  case defaultState
  case productListState
}


class AddMealCell: UITableViewCell {
  

  
  // MARK: Properties
  
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
  var addMealButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "food").withRenderingMode(.alwaysOriginal), for: .normal)
    return b
  }()
  
  var didPassSwitcherValueClouser: ((Bool) -> Void)?
  
  var mealSwitcher: UISwitch = {
    let switcher = UISwitch()
    switcher.isOn               = false
    switcher.tintColor          = .red
    switcher.backgroundColor    = .red
    switcher.layer.cornerRadius = 16
    
    return switcher
  }()
  
  // Product List
//  var productListViewController = NewProductListVC()
  let productListViewController = ProductListInDinnerViewController()
  
  // Add Product Button
  let addNewProductInMealButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor.white
    button.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    return button
  }()
  
  // Properties
  var switcherStackView: UIStackView!
//  var cellState: AddMealCellState = .defaultState
  var showMenuController: EmptyClouser?
  
  // MARK: Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    mealSwitcher.addTarget(self, action: #selector(handleSwitcher), for: .valueChanged)
//    needMealLable.textAlignment = .left
    addMealButton.addTarget(self, action: #selector(handleAddMealButton), for: .touchUpInside)
    
    setUpViews()
    setProductListHidden(isHidden: true)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set ViewModels

extension AddMealCell {
  
  func setViewModel(viewModel: AddMealCellable) {
    
    // Активируем свитчер только когда сахар будет заполнен!
    mealSwitcher.isEnabled = viewModel.isSwitcherIsEnabled
    
    switch viewModel.cellState {
      
    case .defaultState:
      setProductListHidden(isHidden: true)
      mealSwitcher.isOn = false
      
    case .productListState:
      
      setProductListHidden(isHidden: false)
      mealSwitcher.isOn = true
      
      productListViewController.setViewModel(viewModel: viewModel.dinnerProductListVM)

    }
 
  }
  
  private func setProductListHidden(isHidden: Bool) {
    productListViewController.view.isHidden = isHidden
    addNewProductInMealButton.isHidden      = isHidden
  }

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
    addNewProductInMealButton.layer.cornerRadius = ProductListCellHeightWorker.addButtonHeight / 2
    
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
//    productListViewController.view.constrainHeight(constant: ProductListCellHeightWorker.productListHeight)
    
    overAllStackView.distribution = .fill
    overAllStackView.axis         = .vertical
    overAllStackView.spacing      = 10
    
    addSubview(overAllStackView)

    overAllStackView.fillSuperview(padding: ProductListCellHeightWorker.padding)
  }
  
  // Switecher Row
  
  private func setUpSwitcher() {
    
    let containerView = UIView()
    
    containerView.addSubview(mealSwitcher)
    mealSwitcher.centerInSuperview()
    
    switcherStackView = UIStackView(arrangedSubviews: [
    addMealButton,containerView
    ])
    addMealButton.constrainHeight(constant: SugarCellHeightWorker.valueHeight)
    addMealButton.constrainWidth(constant: SugarCellHeightWorker.valueHeight)
    switcherStackView.spacing      = 20
    switcherStackView.distribution = .fill
//    switcherStackView.distribution = .fillEqually
//    switcherStackView.spacing = 5
    
  }
}

//MARK:  Catch Signals
extension AddMealCell {
  
  @objc private func handleAddNewProduct() {
    showMenuController!()
  }
  
  @objc private func handleSwitcher(switcher: UISwitch) {
    
    didPassSwitcherValueClouser!(switcher.isOn)
  }
  
  @objc private func handleAddMealButton() {
    print("Meal Button")
  }
}
