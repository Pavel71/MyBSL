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
  
//    let addNewProductInMealButton: UIButton = {
//      let button = UIButton(type: .system)
//      button.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
//      button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
//
//      button.tintColor = UIColor.white
//      button.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//
//
//
//      return button
//    }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    let stackView = UIStackView(arrangedSubviews: [
//      resultsView,
//      addNewProductInMealButton
//      ])
//    stackView.axis = .vertical
//    stackView.distribution = .fill
//    stackView.spacing = 5
//
//    resultsView.constrainHeight(constant: Constants.ProductList.TableFooterView.resultsViewHeight)
//    addNewProductInMealButton.constrainHeight(constant: Constants.ProductList.TableFooterView.addButtonHeight)
//
//
//
//    addSubview(stackView)
//    stackView.fillSuperview(padding: Constants.ProductList.marginCell)
    
    setUpResultView()
//    setUpAddButton()

  }
  
  private func setUpResultView() {
    
//    let stackView = UIStackView(arrangedSubviews: [
//      resultsView,
//      UIView()
//      ])
//    stackView.axis = .vertical
//    stackView.distribution = .fillEqually
//
//    addSubview(stackView)
//    stackView.fillSuperview(padding: Constants.ProductList.marginCell)
//    stackView.constrainHeight(constant: Constants.ProductList.TableFooterView.resultsViewHeight)
    
    
    addSubview(resultsView)
    resultsView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    resultsView.constrainHeight(constant: Constants.ProductList.TableFooterView.resultsViewHeight)
  }
  
//  private func setUpAddButton() {
//    addNewProductInMealButton.clipsToBounds = true
//    addNewProductInMealButton.layer.cornerRadius = Constants.ProductList.TableFooterView.addButtonHeight / 2
//
//    addSubview(addNewProductInMealButton)
//    addNewProductInMealButton.anchor(top: bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
//    addNewProductInMealButton.centerXAnchor.constraint(equalTo: resultsView.centerXAnchor).isActive = true
//
//
//    addNewProductInMealButton.constrainHeight(constant: Constants.ProductList.TableFooterView.addButtonHeight)
//    addNewProductInMealButton.constrainWidth(constant: Constants.ProductList.TableFooterView.addButtonHeight)
//  }
  
  
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    clipsToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
