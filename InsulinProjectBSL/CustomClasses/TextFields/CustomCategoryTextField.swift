//
//  CustomCategoryTextField.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 28/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class CustomCategoryTextField: CustomTextField {
  
  let listButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "list"), for: .normal)

    return button
  }()
  
  let rightViewSize: CGRect = .init(x: 0, y: 0, width: 20, height: 20)
  
  override init(padding: CGFloat, placeholder: String, cornerRaduis: CGFloat) {
    super.init(padding: padding, placeholder: placeholder, cornerRaduis: cornerRaduis)
    
    rightView = listButton
    rightView?.frame = rightViewSize
    rightViewMode = .always
    
  }
  
  override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
      var rect = super.rightViewRect(forBounds: bounds)
    
      rect.origin.x -= 5 // отступ от правого края
      return rect
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: .init(top: 0, left: padding, bottom: 0, right: rightViewSize.width + 2))
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: .init(top: 0, left: padding, bottom: 0, right: rightViewSize.width + 2))
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

