//
//  FoodCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol FoodCellViewModel {
  
  var id: String? {get set}
  var name: String { get }
  var category: String { get }
  var isFavorit: Bool { get }
  var carbo: String { get }
  var portion: String {get}
  
}


class FoodCell: UITableViewCell {
  
  static let cellID = "FoodCell"
  private var productId: String!
  
  
  private let imageStarFavorit: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "starFill").withRenderingMode(.alwaysTemplate))
    iv.contentMode = .scaleAspectFit
    iv.tintColor = #colorLiteral(red: 0.0592937693, green: 0.4987372756, blue: 0.822627306, alpha: 1)
    return iv
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20)
    label.numberOfLines = 0
    
    return label
  }()
  
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.numberOfLines = 0
    return label
  }()
  
  private let carboLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .right
    
    label.numberOfLines = 0
    return label
  }()
  
  let massaLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .right
    label.text = "100"
    label.alpha = 0
    label.numberOfLines = 0
    return label
  }()
  
  var isFavorit: Bool = false {
    didSet {
      imageStarFavorit.alpha = isFavorit ? 1 : 0
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let verticalStackView = UIStackView(arrangedSubviews: [
      nameLabel,
      categoryLabel
      ])
    verticalStackView.axis = .vertical
    
    
    let carboStackView = UIStackView(arrangedSubviews: [imageStarFavorit,massaLabel,carboLabel])
    carboStackView.alignment = .center
    carboStackView.distribution = .fillEqually
    
    
    let horizontalStackView = UIStackView(arrangedSubviews: [
      verticalStackView,
      carboStackView
      ])
    
    verticalStackView.constrainWidth(constant: 150)
    
    addSubview(horizontalStackView)
    
    horizontalStackView.spacing = 5
    horizontalStackView.distribution = .fillProportionally
    
    
    horizontalStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: Constants.cellMargin)
    
    
  }
  
  func set(viewModel: FoodCellViewModel) {
    nameLabel.text = viewModel.name
    categoryLabel.text = viewModel.category
    carboLabel.text = viewModel.carbo
    isFavorit = viewModel.isFavorit
    productId = viewModel.id
    
  }
  
  func getProductID() -> String {
    return productId
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
