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
  var isNeedInsulinCorrectByShugar: Bool {get set}
  
  var correctInsulinByShugar: Float {get set}
  var shugarBeforeValue: Float {get set}
  var shugarAfterValue: Float {get set}
  var timeBefore: Date? {get set}
  var timeAfter: Date? {get set}
  
}

class ShugarSetView: UIView {
  
  
  // Shugar Before
  
  let shugarBeforeTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар до еды")
  
  let shugarBeforeValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  
  // Shugar After
  
  let shugarAfterTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар после еды")
  
  let shugarAfterValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  
  // Time before
  
  let timeBeforeLabel = CustomLabels(font: .systemFont(ofSize: 14), text: "")
  // Time After
  let timeAfterLabel = CustomLabels(font: .systemFont(ofSize: 14), text: "")
  
  var stackViewShugarAfter: UIStackView!
  
  
  // Correct StackView
  let correctionShugarInsulinValueTextField = CustomValueTextField(placeholder: "1.0", cornerRadius: 10)
  let correctionLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Компенсационный инсулин")
  
  lazy var correctionShugarByInsulinStackView: UIStackView = {
    
    let stackView = UIStackView(arrangedSubviews: [
      correctionLabel,correctionShugarInsulinValueTextField
    ])
    correctionShugarInsulinValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    stackView.spacing = 5
    
    stackView.isHidden = true
    return stackView
  }()
  
  // Picker View
  let pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.backgroundColor = .white
    pickerView.frame = CGRect(x: 0, y: 0, width: 0, height: 250)
    return pickerView
  }()
  
  let pickerCorrectInsulin = [
    ["+","-"],
    ["0.0","0.5","1.0","1.5","2.0","2.5","3.0","3.5","4.0","5.0","5.5","6.0","6.5","7.0","7.5","8.0","8.5","9.0","9.5","10.0"],
    ["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9"]
  ]
  
  var correctSign: String = ""
  var correctTens: Float = 0
  var correctDecimal: Float = 0
  
  // Вместо этого Spacinga может нужно добавить stackView где будет текстфилд и лабел
  var spacingView: UIView = {
    
    let view = UIView()
    view.isHidden = true
    return view
    
  }()

  
  // CLousers
  var didBeginEditingShugarBeforeTextField: TextFieldPassClouser?
  var didChangeShugarBeforeTextFieldToDinnerCellClouser: FloatPassClouser?
  
  
  var didSetShugarBeforeInTimeClouser: DatePassClouser?
  var didSetShugarBeforeValueAndTimeClouser: ((Date,Float) -> Void)?
  
  var didSetCorrectionShugarByInsulinClouser: FloatPassClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    shugarBeforeValueTextField.addTarget(self, action: #selector(handleShugarBeforeTextChange), for: .editingChanged)
    
    shugarBeforeValueTextField.keyboardType = .decimalPad
    shugarAfterValueTextField.keyboardType = .decimalPad
    
    shugarBeforeValueTextField.delegate = self
    correctionShugarInsulinValueTextField.delegate = self
    
    correctionShugarInsulinValueTextField.inputView = pickerView
    pickerView.delegate = self
    pickerView.dataSource = self
    
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
      stackViewShugarBefore,stackViewShugarAfter,correctionShugarByInsulinStackView,spacingView
    ])
    
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    addSubview(stackView)
    stackView.fillSuperview()
    
    
  }
  
  func setViewModel(viewModel:ShugarTopViewModelable) {
    
    let shugarBeforeString = viewModel.shugarBeforeValue == 0 ? "" : String(viewModel.shugarBeforeValue)
    
    shugarBeforeValueTextField.text = shugarBeforeString
    timeBeforeLabel.text = DateWorker.shared.getTimeString(date: viewModel.timeBefore)
    
    // теперь нам приходит како-ето значение!
    
     let correctInsulinByShugarString = viewModel.correctInsulinByShugar == 0 ? "" : String(viewModel.correctInsulinByShugar)
    
    correctionShugarInsulinValueTextField.text = correctInsulinByShugarString
    
    configureIfisPreviosDinner(viewModel: viewModel)
    
    isHIddenCorrectionShugarByInsulinStackView(isHiddenCorrection:viewModel.isNeedInsulinCorrectByShugar)

    
  }
  
  private func configureIfisPreviosDinner(viewModel: ShugarTopViewModelable) {
    // Hidden right shugar StackView And S
    
    
    stackViewShugarAfter.isHidden = !viewModel.isPreviosDinner
    shugarBeforeValueTextField.isEnabled = !viewModel.isPreviosDinner
    
    if viewModel.isPreviosDinner {
      
      shugarBeforeValueTextField.text = String(viewModel.shugarBeforeValue)
      
      timeBeforeLabel.text = DateWorker.shared.getTimeString(date: viewModel.timeBefore)
      timeAfterLabel.text = DateWorker.shared.getTimeString(date: viewModel.timeAfter)
    }
  }
  
  
  private func setTimeBeforTime() -> Date {
    
    let timeNow = Date()
    let timeString = DateWorker.shared.getTimeString(date: timeNow)
    timeBeforeLabel.text = timeString
    timeBeforeLabel.alpha = 0
    
    UIView.animate(withDuration: 0.5) {
      self.timeBeforeLabel.alpha = 1
    }
    
    return timeNow
    
  }

  private func isHIddenCorrectionShugarByInsulinStackView(isHiddenCorrection: Bool) {
    self.correctionShugarByInsulinStackView.isHidden = !isHiddenCorrection

    self.spacingView.isHidden = isHiddenCorrection

  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}


extension ShugarSetView: UITextFieldDelegate {
  
  @objc private func handleShugarBeforeTextChange(textField: UITextField) {
    
    guard let text = textField.text else {return}
    let shugarFloat = (text as NSString).floatValue
    
    didChangeShugarBeforeTextFieldToDinnerCellClouser!(shugarFloat)
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditingShugarBeforeTextField!(textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let text = textField.text else {return}
    
    switch textField {
    case shugarBeforeValueTextField:
      didEndEdidtingShugarBefore(text: text)
      
    case correctionShugarInsulinValueTextField:
      didEndEditingCorrectionInsulinTextField(text:text)
      
    default:break
    }
    
    
  }
  
  private func didEndEditingCorrectionInsulinTextField(text: String) {
    let correctionValue = (text as NSString).floatValue
    didSetCorrectionShugarByInsulinClouser!(correctionValue)
  }
  
  
  // End Editing SHugar Before
  private func didEndEdidtingShugarBefore(text: String) {
    
    let shugarFloat = (text as NSString).floatValue
    
    let timeBefore = setTimeBeforTime()
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {

      self.isHIddenCorrectionShugarByInsulinStackView(isHiddenCorrection: ShugarCorrectorWorker.shared.getIsShowCorrectTextField(shugarValue: shugarFloat))
      
    }, completion: { _ in
      self.didSetShugarBeforeValueAndTimeClouser!(timeBefore,shugarFloat)
    })
    
    

    // если это значение будет приходить с viewModel   то можно оставить этот метода только в setViewModel
    
//    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
//
//      self.isHIddenCorrectionShugarByInsulinStackView(isHiddenCorrection: ShugarCorrectorWorker.shared.getIsShowCorrectTextField(shugarValue: shugarFloat))
//
//    }, completion: { _ in
//      self.didSetShugarBeforeValueAndTimeClouser!(timeBefore,shugarFloat)
//    })
    
    
  }
  
  
}



extension ShugarSetView: UIPickerViewDelegate,UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case 0:
      correctSign = pickerCorrectInsulin[component][row]
    case 1:
      correctTens = (pickerCorrectInsulin[component][row] as NSString).floatValue
    case 2:
      correctDecimal = (pickerCorrectInsulin[component][row] as NSString).floatValue
    default:break
    }
    
    var valueResult = correctTens + correctDecimal
    
    if correctSign == "-" {
      valueResult *= -1
    }
    
    correctionShugarInsulinValueTextField.text = String(valueResult)
//    ShugarCorrectorWorker.shared.setInsulinCorrectionByShugar(shugarValue: valueResult)
    
  }
  
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return pickerCorrectInsulin.count
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerCorrectInsulin[component].count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerCorrectInsulin[component][row]
  }
  
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    switch component {
    case 1:
      return UIScreen.main.bounds.width / 2
    default:break
    }
    return UIScreen.main.bounds.width / 4
  }
  
}

// Здесь нам нужен pickerView! с выбором направления коррекцитровки и вводлм самой корректирвоки
