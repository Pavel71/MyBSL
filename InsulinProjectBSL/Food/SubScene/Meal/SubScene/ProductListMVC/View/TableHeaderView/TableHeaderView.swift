//
//  TableHeaderView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 16/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductListTableHeaderView: UIView {
  
  static let height: CGFloat = 30
  
  let headerLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 20)
    label.textColor = .lightGray
    label.text = "Добавьте пожалуйста продукты!"
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(headerLabel)
    headerLabel.fillSuperview()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
