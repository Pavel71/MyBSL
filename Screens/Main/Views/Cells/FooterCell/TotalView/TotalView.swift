//
//  TotalView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class TotalView: UIView {
  
  let totalLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.text = "Всего инсулина:"
    return label
  }()
  
  let totalInsulinValue: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    label.text = "0.0"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let stackView = UIStackView(arrangedSubviews: [
      totalLabel,totalInsulinValue
      ])
    totalInsulinValue.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    stackView.spacing = 2
    addSubview(stackView)
    stackView.fillSuperview()
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
