//
//  CustomTextField.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  
  let padding: CGFloat
  
  
  init(padding: CGFloat, placeholder: String, cornerRaduis: CGFloat) {
    self.padding = padding
    super.init(frame: .zero)
    
    backgroundColor = .white
    self.placeholder = placeholder
    layer.cornerRadius = cornerRaduis
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Метод отвечает за гранизыц печати в текстФилде
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 0, height: 40)
  }
  
}
