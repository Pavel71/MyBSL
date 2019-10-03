//
//  ShugarSetView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol ShugarTopViewModelable {
  
  var isPreviosDinner: Bool {get set}
  
  var shugarBeforeValue: String {get set}
  var shugarAfterValue: String {get set}
  var timeBefore: String {get set}
  var timeAfter: String {get set}
  
}

class ShugarSetView: UIView {
  
  
  // Shugar Before
  
  let shugarBeforeTitleLabel = CustomLabels(font: .systemFont(ofSize: 18), text: "До еды")
  
  let shugarBeforeValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  
  // Shugar After
  
  let shugarAfterTitleLabel = CustomLabels(font: .systemFont(ofSize: 18), text: "После еды")
  
  let shugarAfterValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  
  // Time before
  
  let timeBeforeLabel = CustomLabels(font: .systemFont(ofSize: 14), text: "28/09/19 00:41")
  // Time After
  let timeAfterLabel = CustomLabels(font: .systemFont(ofSize: 14), text: "28/09/19 01:41")
  
  var stackViewShugarAfter: UIStackView!
  
  var spacingView: UIView = {
    
    let view = UIView()
    view.isHidden = true
    return view
    
  }()
  
//  var titleView = CustomLabels(font: UIFont.systemFont(ofSize: 18), text: "Сахар")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    shugarBeforeValueTextField.keyboardType = .decimalPad
    shugarAfterValueTextField.keyboardType = .decimalPad
    
    
    let stackViewBefore = UIStackView(arrangedSubviews: [
      shugarBeforeTitleLabel,
      timeBeforeLabel
      ])
    stackViewBefore.axis = .vertical
    
    let stackViewShugarBefore = UIStackView(arrangedSubviews: [
      stackViewBefore,shugarBeforeValueTextField
      ])
    
    stackViewShugarBefore.distribution = .fill
    shugarBeforeValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    
    
    
    let stackViewAfter = UIStackView(arrangedSubviews: [
      shugarAfterTitleLabel,
      timeAfterLabel
      ])
    stackViewAfter.axis = .vertical
    
    stackViewShugarAfter = UIStackView(arrangedSubviews: [
      stackViewAfter,shugarAfterValueTextField
      ])
    shugarAfterValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    
    
    stackViewShugarAfter.distribution = .fill
    
    let stackView = UIStackView(arrangedSubviews: [
      stackViewShugarBefore,stackViewShugarAfter,spacingView
      ])
    
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
//    let overAllStackView = UIStackView(arrangedSubviews: [
//      titleView,
//      stackView
//      ])
//    overAllStackView.axis = .vertical
//    overAllStackView.spacing = 2
//    overAllStackView.distribution = .fill
//
//
//    addSubview(overAllStackView)
//    overAllStackView.fillSuperview()
    
    addSubview(stackView)
    stackView.fillSuperview()
    

  }

  
  func setViewModel(viewModel:ShugarTopViewModelable) {
    
    timeBeforeLabel.text = viewModel.timeBefore
    timeAfterLabel.text = viewModel.timeAfter
    
    // Hidden right shugar StackView And S
    stackViewShugarAfter.isHidden = !viewModel.isPreviosDinner
    spacingView.isHidden = viewModel.isPreviosDinner
    
    if viewModel.isPreviosDinner {
      
      shugarBeforeValueTextField.text = viewModel.shugarBeforeValue
      shugarBeforeValueTextField.isEnabled = !viewModel.isPreviosDinner
    }
  }
  

  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
