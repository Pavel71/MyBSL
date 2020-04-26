//
//  VerticalStackView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class VerticalStackView: UIStackView {

  
  init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
    super.init(frame: .zero)
    
    arrangedSubviews.forEach { (view) in
      addArrangedSubview(view)
    }
    
    axis = .vertical
    spacing = customSpacing
    
    
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
