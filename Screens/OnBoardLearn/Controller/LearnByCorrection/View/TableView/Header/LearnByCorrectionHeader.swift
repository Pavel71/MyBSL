//
//  LearnByCorrectionHeader.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



class LearnByCorrectionHeader: UIView {
  
  var sugarLevelLabel: UILabel = {
    let label  = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = "Уровень сахара"
    label.textAlignment = .center
    return label
  }()
  
  var insulinValueLabel: UILabel = {
    let label           = UILabel()
    label.font          = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.text          = "Инсулин"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let stackView = UIStackView(arrangedSubviews: [
    sugarLevelLabel,
    insulinValueLabel
    ])
    stackView.spacing      = 10
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
