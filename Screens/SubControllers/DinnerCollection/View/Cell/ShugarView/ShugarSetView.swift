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
  
  
  var correctInsulinByShugar: Float {get set}
  var shugarBeforeValue: String {get set}
  var shugarAfterValue: String {get set}
  var timeBefore: String {get set}
  var timeAfter: String {get set}
  
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
  
  let dateFormatter: DateFormatter = {
    
    let dateF = DateFormatter()
    dateF.dateFormat = "dd-MM-yy HH:mm"
    return dateF
  }()
  
  
  
  // CLousers
  var didBeginEditingShugarBeforeTextField: TextFieldPassClouser?
  var didChangeShugarBeforeTextFieldToDinnerCellClouser: StringPassClouser?
  var didSetShugarBeforeInTimeClouser: StringPassClouser?
  var didSetCorrectionShugarByInsulinClouser: StringPassClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    shugarBeforeValueTextField.addTarget(self, action: #selector(handleShugarBeforeTextChange), for: .editingChanged)
    shugarBeforeValueTextField.keyboardType = .decimalPad
    shugarAfterValueTextField.keyboardType = .decimalPad
    
    shugarBeforeValueTextField.delegate = self
    
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
    
    shugarBeforeValueTextField.text = viewModel.shugarBeforeValue
    timeBeforeLabel.text = viewModel.timeBefore
    
    
    correctionShugarInsulinValueTextField.text = String(viewModel.correctInsulinByShugar)
    
    isHIddenCorrectionShugarByInsulinStackView()

    configureIfisPreviosDinner(viewModel: viewModel)
    
  }
  
  private func configureIfisPreviosDinner(viewModel: ShugarTopViewModelable) {
    // Hidden right shugar StackView And S
    stackViewShugarAfter.isHidden = !viewModel.isPreviosDinner
    
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
  
  private func isHIddenCorrectionShugarByInsulinStackView() {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
      self.correctionShugarByInsulinStackView.isHidden = !ShugarCorrectorWorker.shared.isNeedCorrectShugarByInsulin
      self.spacingView.isHidden = ShugarCorrectorWorker.shared.isNeedCorrectShugarByInsulin
    }, completion: nil)
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
    // Вообщем план такой я ловлю этот сахар и отправляю запрос на интерактор на проверку если в норме то ничего не делаю! Если нет то показываю этот текстфилд и прошу внести корректировку! также получается его надо добавить в валидатор как то! 
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if let text = textField.text {
      
      // Просто с синглтонами нихера не понятно если честно не читаетс код не понятно откуда идет сигнал просто по факту видно что он уже имее тсво1ство а когда оно засетилось туда не особо понятно
      ShugarCorrectorWorker.shared.setInsulinCorrectionByShugar(shugarValue: text)
      
      
      let timeBefore = setTimeBeforTime()
      
      didSetShugarBeforeInTimeClouser!(timeBefore)
      
      isHIddenCorrectionShugarByInsulinStackView()
      
      
      
    }

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
    
    // Просто проще здесь по условию показывать ли correctionUsnulin Text Fiedl или нет.
    
    
    // По идеии эту корректировку намбы хронить в диннере! Поэтому нам нужно это поле там создать!
    correctionShugarInsulinValueTextField.text = String(valueResult)
    
    didSetCorrectionShugarByInsulinClouser!(String(valueResult))
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
