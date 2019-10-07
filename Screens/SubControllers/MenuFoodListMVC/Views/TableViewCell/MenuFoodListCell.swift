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
  var isFavorit: Bool {get}
  var isChoosen: Bool {get}
}

class MenuFoodListCell: UITableViewCell {
  
  static let cellId = MenuFoodListCell.description()
  
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.numberOfLines = 0
    
    return label
  }()
  
  private let carboLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .right
    
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
    chooseImageView.fillSuperview()

    let stackView = UIStackView(arrangedSubviews: [
      containerView,nameLabel,carboLabel
      ])
    
    stackView.distribution = .fill
    stackView.spacing = 2
    stackView.alignment = .center
    
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.cellMargin)

    containerView.constrainWidth(constant: 30)
    carboLabel.constrainWidth(constant: 30)
    
    


  }
  
  
  func setViewModel(viewModel:MenuFoodListCellViewModelable) {
    nameLabel.text = viewModel.name
    carboLabel.text = viewModel.carboOn100Grm
    
    chooseImageView.image = viewModel.isChoosen ? #imageLiteral(resourceName: "circular-shape-silhouette").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate)

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
