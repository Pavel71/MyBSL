//
//  MealCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 30/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

//protocol MealViewModelCell {
//  var name: String {get}
//  var portion: String {get}
//}


// Protocol

protocol MealViewModelCell {
  
  var mealId: String? {get}
  
  var isExpanded: Bool {get set}
  var name: String {get set}
  var typeMeal: String {get set}
  
  var products: [ProductListViewModel] {get set}
}


// Cell

class MealCell: UITableViewCell {
  
  static let cellId = "mealCellId"
  var mealId: String = ""
  
  private let expandImageView : UIImageView =  {
    let iv = UIImageView(image: #imageLiteral(resourceName: "angle-arrow-down").withRenderingMode(.alwaysTemplate))
    
    return iv
  }()
  
  let expandedButton: UIButton = {
    let button = UIButton(type: .system)
    return button
  }()
  
  
  private let  mealTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17)
    label.numberOfLines = 0
    return label
  }()
  
  private let  mealTypeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.numberOfLines = 1
    return label
  }()
  
  
  let addNewProductInMealButton: UIButton = {
    let button = UIButton(type: .system)
    button.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor.white
    button.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    return button
  }()
  
  var productListViewController = ProductListInMealViewController()

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
//    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
//    backgroundColor = .clear
////    backgroundColor = .white
//    
//    productListViewController.view.backgroundColor = .red

    let vertiaclStackView = UIStackView(arrangedSubviews: [

      mealTitleLabel,
      mealTypeLabel
      ])

    vertiaclStackView.axis = .vertical
    vertiaclStackView.distribution = .fill
    
    let rightStackView = UIStackView(arrangedSubviews: [
      expandedButton // portionLabel
      ])

    rightStackView.constrainWidth(constant: Constants.Meal.Cell.expandButtonWidth)
    rightStackView.distribution = .fill
    

    let overAllStackView = UIStackView(arrangedSubviews: [
      vertiaclStackView,rightStackView

      ])
    
    
    overAllStackView.distribution = .fill

    let stackViewWithTableView = UIStackView(arrangedSubviews: [
      overAllStackView,
      productListViewController.view,

      ])
    
    stackViewWithTableView.distribution = .fill
    stackViewWithTableView.axis = .vertical
    
    
    
    addSubview(stackViewWithTableView)
    stackViewWithTableView.fillSuperview(padding: Constants.Meal.Cell.margin)
    
    setUpAddButton()
    
  }
  
  private func setUpAddButton() {
    
    addNewProductInMealButton.addTarget(self, action: #selector(handleAddNewProductInMeal), for: .touchUpInside)
    
    
    
    addSubview(addNewProductInMealButton)
    addNewProductInMealButton.anchor(top: productListViewController.view.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -35, left: 0, bottom: 0, right: 0))
    addNewProductInMealButton.centerXAnchor.constraint(equalTo: productListViewController.view.centerXAnchor).isActive = true
    
    
    addNewProductInMealButton.constrainHeight(constant: Constants.ProductList.TableFooterView.addButtonHeight)
    addNewProductInMealButton.constrainWidth(constant: Constants.ProductList.TableFooterView.addButtonHeight)
    
    
  }
  
  var didAddNewProductInmeal: ((String) -> Void)?
  @objc private func handleAddNewProductInMeal() {
    
    print("Add New Product")
    didAddNewProductInmeal!(mealId)
    
  }
  

  
  func getMealId() -> String {
    return mealId
  }
  
  func setViewModel(viewModel: MealViewModelCell) {
    
    mealTitleLabel.text = viewModel.name
    mealTypeLabel.text = viewModel.typeMeal
    
    // Возможно здесь она не должна идти
    guard let mealId = viewModel.mealId else {return}
    self.mealId = mealId

    let productListViewModel = ProductListInMealViewModel(mealId: self.mealId, productsData: viewModel.products)
    
    productListViewController.setViewModel(viewModel: productListViewModel)
    expanded(isExpand: viewModel.isExpanded)
  
  }
  
  
  func expanded(isExpand: Bool) {
    
    productListViewController.view.isHidden = !isExpand
    addNewProductInMealButton.isHidden = !isExpand
    
    let expandButtonImage = isExpand ? #imageLiteral(resourceName: "up-arrow").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "angle-arrow-down").withRenderingMode(.alwaysTemplate)

    self.expandedButton.setImage(expandButtonImage, for: .normal)
  }
  
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    addNewProductInMealButton.clipsToBounds = true
    addNewProductInMealButton.layer.cornerRadius = Constants.ProductList.TableFooterView.addButtonHeight / 2
    
    addNewProductInMealButton.layer.shadowColor = UIColor.black.cgColor
    addNewProductInMealButton.layer.shadowOffset  = .init(width: 0, height: 3)
    addNewProductInMealButton.layer.shadowOpacity = 0.7
    addNewProductInMealButton.layer.shadowRadius = 3
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}




