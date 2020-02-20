//
//  CustomLabels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


import UIKit

class CustomLabels: UILabel {
  
  
  init(font: UIFont,
       text: String,
       textColor:UIColor = .white) {
    super.init(frame: .zero)
    
    self.font = font
    self.text = text
    self.numberOfLines = 0
    
    self.textColor = textColor
    
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
