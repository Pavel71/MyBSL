//
//  ProductsTableViewInMealCellFooterView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 12/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductsTableViewInMealCellFooterView: UIView {
  
  static let footerHeight: CGFloat = 50
  
//   Add New Product
  
  let resultsView = ProductListResultView()
  
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
    
    let stackView = UIStackView(arrangedSubviews: [
      resultsView,
      addNewProductInMealButton
      ])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 5
    
    resultsView.constrainHeight(constant: Constants.ProductList.TableFooterView.resultsViewHeight)
    addNewProductInMealButton.constrainHeight(constant: Constants.ProductList.TableFooterView.addButtonHeight)
    
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.ProductList.marginCell)
        
  }
  
  func changeHeightIsPreviosDinner(isPreviosDinner: Bool) {
    
//    addNewProductInMealButton.isHidden = isPreviosDinner
//
//    let height = isPreviosDinner ? Constants.ProductList.TableFooterView.resultsViewHeight : Constants.ProductList.TableFooterView.footerHeight
//
//    self.constrainHeight(constant: height)
    
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
