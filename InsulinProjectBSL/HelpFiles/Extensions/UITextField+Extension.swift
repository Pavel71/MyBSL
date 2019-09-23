//
//  UITextField+Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

extension UITextField {
  
  convenience init(placeholder: String,cornerRadius: CGFloat) {
    self.init()
    self.placeholder = placeholder
    self.layer.cornerRadius = cornerRadius
  }
}
