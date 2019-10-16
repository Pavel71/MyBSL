//
//  MenuMealListInCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

protocol MenuMealListCellViewModelable: MealViewModelCell {
  
  var isChoosen: Bool {get}
  
}

class MenuMealListCell: UITableViewCell {
  
  
  static let cellId = "mealCellId"
  var mealId: String = ""

  
  let expandedButton: UIButton = {
    let button = UIButton(type: .system)
    return button
  }()
  
  
  private let  mealTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  private let  mealTypeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()
  
  let chooseImageView: UIImageView = {
    
    let iv = UIImageView(image: #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate))
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    
    return iv
  }()
  
  // Для того чтобы создать на абстракциях у меня должен быть
  // 1. ProductListInMealViewController с максимальными вхождениями
  // 2. ProductListInMealViewController tableView - ячейка с максимальными вхождениями
  
  
  
  // Вообщем здесь нам нужен контроллер с упрощенными настройками без манипуляций только отображение!
  var productListViewController = MainMenuProductListViewController()
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    selectionStyle = .none
    
    expandedButton.addTarget(self, action: #selector(handleTapExpandButton), for: .touchUpInside)
    
    let containerView = UIView()
    containerView.addSubview(chooseImageView)

    chooseImageView.centerInSuperview(size: .init(width: 20, height: 20))
    containerView.constrainWidth(constant: 30)
    
    let vertiaclStackView = UIStackView(arrangedSubviews: [
      
      mealTitleLabel,
      mealTypeLabel
      ])
    
    vertiaclStackView.axis = .vertical
    vertiaclStackView.distribution = .fill

    expandedButton.constrainWidth(constant: Constants.Meal.Cell.expandButtonWidth)

    let overAllStackView = UIStackView(arrangedSubviews: [
      containerView,vertiaclStackView,expandedButton
      
      ])
    
    
    overAllStackView.distribution = .fill
    overAllStackView.spacing = 2
    
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
  
  func setViewModel(viewModel: MenuMealListCellViewModelable) {
    
    mealTitleLabel.text = viewModel.name
    mealTypeLabel.text = viewModel.typeMeal
    
    // Возможно здесь она не должна идти
    guard let mealId = viewModel.mealId else {return}
    self.mealId = mealId
    
    
    chooseImageView.image = viewModel.isChoosen ? #imageLiteral(resourceName: "circular-shape-silhouette").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate)

    
    let productListViewModel = ProductListInMealViewModel(mealId: self.mealId, productsData: viewModel.products)
    
    productListViewController.setViewModel(viewModel: productListViewModel)
    expanded(isExpand: viewModel.isExpanded)
    
  }
  
  
  
  func expanded(isExpand: Bool) {

    productListViewController.view.isHidden = !isExpand
    
    let expandButtonImage = isExpand ? #imageLiteral(resourceName: "up-arrow").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "angle-arrow-down").withRenderingMode(.alwaysTemplate)
    
    self.expandedButton.setImage(expandButtonImage, for: .normal)
  }
  
  
  
  // Buttons and Clousers
  
  var didTapExpandButtonClouser: ((UIButton) -> Void)?
  @objc private func handleTapExpandButton(button: UIButton) {
    didTapExpandButtonClouser!(button)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

