//
//  CustomValueTextField.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class CustomValueTextField: UITextField {
  
  let padding: CGFloat = 5
  
  var withCornerLayer: Bool = true {
    didSet {setNeedsDisplay()} // Обнови методы отображения
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    textAlignment = .center
    backgroundColor = .white
    self.addDoneButtonOnKeyboard()
  }
  
  convenience init(withCornerLayer: Bool) {
    self.init(frame: .zero)
    self.withCornerLayer = withCornerLayer
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    if withCornerLayer {
      layer.borderWidth = 1
      layer.borderColor = UIColor.lightGray.cgColor
      
      clipsToBounds = true
      layer.cornerRadius = 10
      
      
    } else {
      layer.borderWidth = 0
    }
    

  }
  
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
