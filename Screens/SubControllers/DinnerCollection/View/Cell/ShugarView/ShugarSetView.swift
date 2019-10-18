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
  
  let timeBeforeLabel = CustomLabels(font: .systemFont(ofSize: 14), text: "")
  // Time After
  let timeAfterLabel = CustomLabels(font: .systemFont(ofSize: 14), text: "")
  
  var stackViewShugarAfter: UIStackView!
  
  var spacingView: UIView = {
    
    let view = UIView()
    view.isHidden = true
    return view
    
  }()
  
  let dateFormatter: DateFormatter = {
    
    let dateF = DateFormatter()
    dateF.dateFormat = "dd-MM-yy HH:mm"
    return dateF
  }()
  
  
  
  // CLousers
  var didBeginEditingShugarBeforeTextField: TextFieldPassClouser?
  var didChangeShugarBeforeTextFieldToDinnerCellClouser: StringPassClouser?
  var didSetShugarBeforeInTimeClouser: StringPassClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    shugarBeforeValueTextField.addTarget(self, action: #selector(handleShugarBeforeTextChange), for: .editingChanged)
    shugarBeforeValueTextField.keyboardType = .decimalPad
    shugarAfterValueTextField.keyboardType = .decimalPad
    
    shugarBeforeValueTextField.delegate = self
    
    
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
        
    addSubview(stackView)
    stackView.fillSuperview()
    

  }
  
  

  
  func setViewModel(viewModel:ShugarTopViewModelable) {
    
    shugarBeforeValueTextField.text = viewModel.shugarBeforeValue
    timeBeforeLabel.text = viewModel.timeBefore
    
    // Hidden right shugar StackView And S
    stackViewShugarAfter.isHidden = !viewModel.isPreviosDinner
    spacingView.isHidden = viewModel.isPreviosDinner
    
    if viewModel.isPreviosDinner {
      
      shugarBeforeValueTextField.text = viewModel.shugarBeforeValue
      shugarBeforeValueTextField.isEnabled = !viewModel.isPreviosDinner
      
      timeBeforeLabel.text = viewModel.timeBefore
      timeAfterLabel.text = viewModel.timeAfter
    }
    
  }
  
  
  private func setTimeBeforTime() -> String {
    
    let timeNow = Date()
    let timeString = dateFormatter.string(from: timeNow)
    timeBeforeLabel.text = timeString
    timeBeforeLabel.alpha = 0
    
    UIView.animate(withDuration: 0.5) {
      self.timeBeforeLabel.alpha = 1
    }
    
    return timeString
    
  }
  
  
 
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}


extension ShugarSetView: UITextFieldDelegate {
  
  @objc private func handleShugarBeforeTextChange(textField: UITextField) {
    
    guard let text = textField.text else {return}
    didChangeShugarBeforeTextFieldToDinnerCellClouser!(text)
    
    // Здесь нужно установить время и прокинуть его в модельку потомучто потом мы будем сохранять все в базу данных
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    didBeginEditingShugarBeforeTextField!(textField)
  }
  
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if textField.text?.isEmpty == false {
      let timeBefore = setTimeBeforTime()
      
      didSetShugarBeforeInTimeClouser!(timeBefore)
    }
    
    
    
    // Возможно здесь мне нужно будет прокидывать clouser
  }
}
