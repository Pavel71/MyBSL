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
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = Constants.Font.valueFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = .center
    
    label.numberOfLines = 0
    return label
  }()
  
  private let portionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = Constants.Font.valueFont
    label.textColor = Constants.Text.textColorDarkGray
    label.textAlignment = .center
    
    label.numberOfLines = 0
    return label
  }()
  
  let chooseImageView: UIImageView = {
    
    let iv = UIImageView(image: #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate))
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    
    return iv
  }()
  
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let containerView = UIView()
    containerView.addSubview(chooseImageView)
    containerView.contentMode = .center
    chooseImageView.centerInSuperview(size: .init(width: 20, height: 20))
    
    let leftStackView = UIStackView(arrangedSubviews: [
      containerView,nameLabel
      ])
    leftStackView.spacing = 2
    containerView.constrainWidth(constant: 30)
    
    let rightStackView = UIStackView(arrangedSubviews: [
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


  }
  
  
  func setViewModel(viewModel:MenuFoodListCellViewModelable, isFavoritsSegment: Bool) {
    
    nameLabel.text = viewModel.name
    carboLabel.text = viewModel.carboOn100Grm
    
    portionLabel.text = viewModel.portion
    portionLabel.alpha = isFavoritsSegment ? 1:0
    
    chooseImageView.image = viewModel.isChoosen ? #imageLiteral(resourceName: "circular-shape-silhouette").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate)

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
