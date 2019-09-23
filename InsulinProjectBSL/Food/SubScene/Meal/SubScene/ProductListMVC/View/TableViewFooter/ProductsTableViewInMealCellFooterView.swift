//
//  ProductsTableViewInMealCellFooterView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 12/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductsTableViewInMealCellFooterView: UIView {
  
  static let footerHeight:CGFloat = 50
  
//   Add New Product
  

//  let addNewProductLabel: UILabel = {
//    let label = UILabel()
//    label.text = "Добавить продукты:"
//    label.font = UIFont.systemFont(ofSize: 16)
//    return label
//  }()
  
    let addNewProductInMealButton: UIButton = {
      let button = UIButton(type: .system)
      button.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
      button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
      button.tintColor = UIColor.white
      button.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)

      return button
    }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    

    
    addSubview(addNewProductInMealButton)
    addNewProductInMealButton.fillSuperview(padding: Constants.Meal.ProductCell.margin)
    
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    clipsToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
