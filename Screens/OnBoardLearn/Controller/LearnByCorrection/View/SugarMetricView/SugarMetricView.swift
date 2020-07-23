//
//  SugarMetricView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

// View -  отвечает за отображение в какой метрике измерятся сахар у человека

class SugarMetricView : UIView {
  

  
  let cell = ChancgeSugarMeuserCell()
  
  // MARK: Signals
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    cell.selectionStyle = .none
    
    
    
    setViews()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Views
extension SugarMetricView {
  
  func setViews() {
    
//    let vStack = UIStackView(arrangedSubviews: [
//    sugarMetricViewTitle,
//    cell
//    ])
//
//    vStack.distribution = .fillEqually
//    vStack.axis         = .vertical
    
    addSubview(cell)
    cell.fillSuperview()
  }
}
