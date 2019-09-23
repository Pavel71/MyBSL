//
//  UiImageView + Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 18/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

extension UIImageView {
  
  var imageColor: UIColor? {
    
    set (newValue) {
      guard let image = image else { return }
      if newValue != nil {
        self.image = image.withRenderingMode(.alwaysTemplate)
        tintColor = newValue
      } else {
        self.image = image.withRenderingMode(.alwaysOriginal)
        tintColor = UIColor.clear
      }
    }
    get { return tintColor }
  }
}
