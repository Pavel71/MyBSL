//
//  MenuFoodListCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 17/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MenuFoodListCellViewModelable {
  
  var name: String {get}
  var carboOn100Grm: String {get}
  var portion: String {get}
  var category: String {get}
  
  var isFavorit: Bool {get}
  var isChoosen: Bool {get}
  
  
}

class MenuFoodListCell: UITableViewCell {
  
  static let cellId = MenuFoodListCell.description()
  
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.numberOfLines = 0
    
    label.textColor = .white
    return label
  }()
  
  private let carboLabel: UILabel = {
    let label = UILabel()

    label.font = Constants.Font.valueFont

    label.textAlignment = .center
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  private let portionLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.Font.valueFont
    label.textAlignment = .center
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  // Попробую сделать с категорией продукта посмотрю что выйдет
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  let chooseImageView: UIImageView = {
    
    let iv = UIImageView(image: #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate))
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    
    return iv
  }()
  
 
  
  
  var leftStackView: UIStackView!
  var rightStackView: UIStackView!
  var leftStackViewTrailingConstraintToPortion: NSLayoutConstraint!
  var leftStackViewTrailingConstraintToCarbo: NSLayoutConstraint!
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    backgroundColor = .clear
    
    let containerView = UIView()
    containerView.addSubview(chooseImageView)
    containerView.contentMode = .center
    chooseImageView.centerInSuperview(size: .init(width: 20, height: 20))

    let leftVerticalStackView = UIStackView(arrangedSubviews: [
      nameLabel,
      categoryLabel,
      
      ])
    leftVerticalStackView.axis = .vertical
    leftVerticalStackView.spacing = 2

    leftStackView = UIStackView(arrangedSubviews: [
      containerView,leftVerticalStackView
      ])
    leftStackView.spacing = 2
    containerView.constrainWidth(constant: 30)
    
    
    rightStackView = UIStackView(arrangedSubviews: [
    carboLabel,portionLabel
    ])
    
    carboLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    portionLabel.constrainWidth(constant: Constants.ProductList.labelValueWidth)
    rightStackView.distribution = .fill
    
    
    let generalStackView = UIStackView(arrangedSubviews: [leftStackView,rightStackView])
    
    generalStackView.distribution = .fill

    addSubview(generalStackView)
    generalStackView.fillSuperview(padding: Constants.cellMargin)


  }

  
  
  func setViewModel(viewModel:MenuFoodListCellViewModelable, isFavoritsSegment: Bool) {
    
    nameLabel.text     = viewModel.name
    carboLabel.text    = viewModel.carboOn100Grm
    categoryLabel.text = viewModel.category
    
    
    portionLabel.text = viewModel.portion
    
  

    
    chooseImageView.image = viewModel.isChoosen ? #imageLiteral(resourceName: "circular-shape-silhouette").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate)

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
