//
//  ShugarSetView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class ShugarSetView: UIView {
  
  static let height: CGFloat = 60
  
  let shugarTitleLabel = CustomLabels(font: .systemFont(ofSize: 18), text: "Введите ваш текущий сахар в крови")
  
  let shugarValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    shugarValueTextField.keyboardType = .decimalPad
    
    
    let stackView = UIStackView(arrangedSubviews: [
      shugarTitleLabel,shugarValueTextField
      ])
    shugarValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.fillSuperview()
    

  }
  

  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
