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
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    
    return label
  }()
  
  private let carboLabel: UILabel = {
    let label = UILabel()
    
    
    label.font = Constants.Font.valueFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = .center
    
    label.numberOfLines = 0
    return label
  }()
  
  private let portionLabel: UILabel = {
    let label = UILabel()
    
    
    label.font = Constants.Font.valueFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = .center
    
    label.numberOfLines = 0
    return label
  }()
  
  // Попробую сделать с категорией продукта посмотрю что выйдет
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
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
    
    let containerView = UIView()
    containerView.addSubview(chooseImageView)
    containerView.contentMode = .center
    chooseImageView.centerInSuperview(size: .init(width: 20, height: 20))

    let leftVerticalStackView = UIStackView(arrangedSubviews: [
      nameLabel,
      categoryLabel
      ])
    leftVerticalStackView.axis = .vertical
    leftVerticalStackView.spacing = 2

    leftStackView = UIStackView(arrangedSubviews: [
      containerView,leftVerticalStackView
      ])
    leftStackView.spacing = 2
    containerView.constrainWidth(constant: 30)

    rightStackView = UIStackView(arrangedSubviews: [
      portionLabel,
      carboLabel
      ])
    rightStackView.spacing = 2
    rightStackView.distribution = .fillEqually

//    carboLabel.constrainWidth(constant: 30)

    let stackView = UIStackView(arrangedSubviews: [
      leftStackView,rightStackView
      ])

    stackView.distribution = .fillEqually
    stackView.spacing = 2
//    stackView.alignment = .center

    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.cellMargin)
    
    
    
    
    
    
//    handSetConstrints()

  }
  
  
  private func handSetConstrints() {
    
    
    let containerView = UIView()
    containerView.addSubview(chooseImageView)
    containerView.contentMode = .center
    chooseImageView.centerInSuperview(size: .init(width: 20, height: 20))
    
    let leftVerticalStackView = UIStackView(arrangedSubviews: [
      nameLabel,
      categoryLabel
      ])
    leftVerticalStackView.axis = .vertical
    leftVerticalStackView.spacing = 2
    
    leftStackView = UIStackView(arrangedSubviews: [
      containerView,leftVerticalStackView
      ])
    leftStackView.spacing = 2
    containerView.constrainWidth(constant: 30)
    
    addSubview(leftStackView)
    leftStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
    

    addSubview(carboLabel)
    carboLabel.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10))
    
    addSubview(portionLabel)
    portionLabel.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: carboLabel.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5))
    
    
    
    leftStackViewTrailingConstraintToPortion = leftStackView.trailingAnchor.constraint(equalTo: portionLabel.leadingAnchor)
    leftStackViewTrailingConstraintToPortion.isActive = true
    
    leftStackViewTrailingConstraintToCarbo = leftStackView.trailingAnchor.constraint(equalTo: carboLabel.leadingAnchor)
    leftStackViewTrailingConstraintToCarbo.isActive = false
    
  }
  
  
  func setViewModel(viewModel:MenuFoodListCellViewModelable, isFavoritsSegment: Bool) {
    
    nameLabel.text = viewModel.name
    carboLabel.text = viewModel.carboOn100Grm
    categoryLabel.text = viewModel.category
    
    
    portionLabel.text = viewModel.portion
    
    
    // здесь мне нужно растенуть левый stack до CarboLabel а в другом случае до PortionLabel
//    portionLabel.isHidden = !isFavoritsSegment
    portionLabel.alpha = isFavoritsSegment ? 1:0
    
    
//    if isFavoritsSegment {
//      leftStackViewTrailingConstraintToPortion.isActive = false
//      leftStackViewTrailingConstraintToCarbo.isActive = true
//    } else {
//      leftStackViewTrailingConstraintToPortion.isActive = true
//      leftStackViewTrailingConstraintToCarbo.isActive = false
//    }
    

    
    chooseImageView.image = viewModel.isChoosen ? #imageLiteral(resourceName: "circular-shape-silhouette").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate)

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
