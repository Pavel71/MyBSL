//
//  ShugarSetView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class ShugarSetView: UIView {
  

  
  let shugarBeforeTitleLabel = CustomLabels(font: .systemFont(ofSize: 18), text: "Сахар до еды")
  
  let shugarBeforeValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  let shugarAfterTitleLabel = CustomLabels(font: .systemFont(ofSize: 18), text: "Сахар после еды")
  
  let shugarAfterValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    shugarBeforeValueTextField.keyboardType = .decimalPad
    
    
    let stackViewBefore = UIStackView(arrangedSubviews: [
      shugarBeforeTitleLabel,shugarBeforeValueTextField
      ])
    stackViewBefore.distribution = .fill
    shugarBeforeValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    
    let stackViewAfter = UIStackView(arrangedSubviews: [
      shugarAfterTitleLabel,shugarAfterValueTextField
      ])
    shugarAfterValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    stackViewAfter.distribution = .fill
    
    let stackView = UIStackView(arrangedSubviews: [
      stackViewBefore,stackViewAfter
      ])
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    

    addSubview(stackView)
    stackView.fillSuperview()
    

  }
  
  func setShugarValueAndEnableTextField(shugarValue: String,isPreviosDinner: Bool) {
    
    if isPreviosDinner {
      shugarBeforeValueTextField.text = shugarValue
      shugarBeforeValueTextField.isEnabled = !isPreviosDinner
    }
    
    
  }
  

  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
