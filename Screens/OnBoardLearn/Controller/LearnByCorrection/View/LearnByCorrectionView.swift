//
//  LearnByCorrectionView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

// View эакрана

class LearnByCorrectionView: UIView {
  
  var sugarLevelView = SugarLevelView()
  var tableView      = UITableView(frame: .zero, style: .plain)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up Views
extension LearnByCorrectionView {
  
  private func setUpViews() {
    
    let stackView = UIStackView(arrangedSubviews: [
      sugarLevelView,
      tableView
    ])
    
    sugarLevelView.constrainHeight(constant: 220)
    
    stackView.axis         = .vertical
    stackView.spacing      = 5
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.fillSuperview()
    
  }
  
}
