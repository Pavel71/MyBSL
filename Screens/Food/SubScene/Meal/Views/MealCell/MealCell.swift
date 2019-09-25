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
  
  var products: [ProductViewModel] {get set}
}


// Cell

class MealCell: UITableViewCell {
  
  static let cellId = "mealCellId"
  private var mealId: String = ""
  
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
  
  var productListViewController = ProductListInMealViewController()

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

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
    
    let expandButtonImage = isExpand ? #imageLiteral(resourceName: "up-arrow").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "angle-arrow-down").withRenderingMode(.alwaysTemplate)

    self.expandedButton.setImage(expandButtonImage, for: .normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}




