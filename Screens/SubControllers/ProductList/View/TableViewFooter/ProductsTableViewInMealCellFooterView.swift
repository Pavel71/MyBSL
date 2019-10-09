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
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpResultView()
  }
  
  private func setUpResultView() {
    
    addSubview(resultsView)
    resultsView.fillSuperview()
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
