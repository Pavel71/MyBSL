//
//  ShugarSetView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit




protocol ShugarTopViewModelable {
//  var isNeedInsulinCorrectByShugar: Bool {get set} // Deprecated
//  var isPreviosDinner: Bool {get set} // Deprecated
  
//  var dinnerPosition: DinnerPosition {get set}
//  var correctInsulinPosition: CorrectInsulinPosition {get set}

  var correctInsulinByShugar: Float {get set}
  var shugarBeforeValue: Float {get set}
  var shugarAfterValue: Float {get set}
  var timeBefore: Date? {get set}
  var timeAfter: Date? {get set}
  
}

class ShugarSetView: UIView {
  
  // States
  var correctInsulinPosition: CorrectInsulinPosition!
  var dinnerPosition: DinnerPosition!
  
  // Shugar Before
  
  let shugarBeforeTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар до еды")

  
  lazy var sugarBeforeImageView = createSugarImageView(image: #imageLiteral(resourceName: "SugarBefore"))
  lazy var sugarAfterImageView = createSugarImageView(image: #imageLiteral(resourceName: "SugarAfter"))
  lazy var sugarCorrectDownImageView = createSugarImageView(image: #imageLiteral(resourceName: "SugarCorrect"))
  

  
  func createSugarImageView(image: UIImage) -> UIImageView {
    let iv = UIImageView(image: image)
      iv.clipsToBounds = true
      iv.layer.cornerRadius = 10
      iv.contentMode = .scaleAspectFit
    return iv
  }
  
  let shugarBeforeValueTextField = CustomValueTextField(placeholder: "7.2", cornerRadius: 10)
  
  
  
  // Shugar After
  
//  let shugarAfterTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар после еды")
  
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
      correctionLabel,sugarCorrectDownImageView,correctionShugarInsulinValueTextField
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
    
    drawViews()
    
    
  }
  
  func setViewModel(
    viewModel: ShugarTopViewModelable,
    dinnerPosition: DinnerPosition,
    correctInsulinPosition: CorrectInsulinPosition
  ) {
    
    self.dinnerPosition = dinnerPosition
    self.correctInsulinPosition = correctInsulinPosition
    
    setViewModels(viewModel: viewModel)
    
    
    // Здесь мне нужно запустить логику
    
    // 1. Проверить Обед предыдущий или нет
    //
    
    updateViewsFromCorrectInsulinBySugarPosition()
    updateViewsFromDinnerPosition(sugarAfter: viewModel.shugarAfterValue)
    
    
    
  }
  
  // MARK: Dinner Position
  
  private func updateViewsFromDinnerPosition(sugarAfter: Float) {
    switch dinnerPosition {
      case .newdinner:
        print("Shugar New Dinner")
        updateViewsNewDinner()
      case .previosdinner:
        print("Shugar Prev Dinner")
        updateViewsPrevDinner(sugarAfter: sugarAfter)

    case .none:break
    }
    
    
  }
  
  // MARK: Configure Views CorrectInsulin
   
   private func updateViewsFromCorrectInsulinBySugarPosition() {
     
     switch correctInsulinPosition {
     case .needCorrect:
       print("Need Correct Insulin")
       
       correctionShugarByInsulinStackView.isHidden = false
       spacingView.isHidden = true
      
     case .dontCorrect:
       print("Dont neeed Correct")
       correctionShugarByInsulinStackView.isHidden = true
       spacingView.isHidden = false
    
     case .none:break
    }
   }

  
  // MARK: SetViewModels
  
  private func setViewModels(viewModel:ShugarTopViewModelable) {
    
    setTime(viewModel: viewModel)
    setSugarBefore(viewModel: viewModel)
    setShugarAfter(viewModel: viewModel)
    setCorrectInsulin(viewModel: viewModel)

    
  }
  
  // MARK: Update Views NewDinner
  
  private func updateViewsNewDinner() {
    

    switchLabelAndImageView(text: shugarBeforeValueTextField.text ?? "", imageView: sugarBeforeImageView, label: shugarBeforeTitleLabel)
    
    switchLabelAndImageView(text: correctionShugarInsulinValueTextField.text ?? "", imageView: sugarCorrectDownImageView, label: correctionLabel)
    
    stackViewShugarAfter.isHidden = true
    
    confirmeTextFieldsToNewDinner(textField: shugarBeforeValueTextField)
    confirmeTextFieldsToNewDinner(textField: correctionShugarInsulinValueTextField)

    
  }
  // MARK: Update Views PrevDinner
  
  private func updateViewsPrevDinner(sugarAfter: Float) {
    
//    switchSugarImageViewToLabel(imageView: sugarBeforeImageView, label: shugarBeforeTitleLabel)
    
    switchLabelAndImageView(text: shugarBeforeValueTextField.text!, imageView: sugarBeforeImageView, label: shugarBeforeTitleLabel)
    
    switchLabelAndImageView(text: correctionShugarInsulinValueTextField.text ?? "", imageView: sugarCorrectDownImageView, label: correctionLabel)
    
  
    confirmeTextFieldsToPrevDinner(textField: shugarBeforeValueTextField)
    confirmeTextFieldsToPrevDinner(textField: correctionShugarInsulinValueTextField)
    // Нам нужно скрывать эти поля пока не засетится новые значениея
    stackViewShugarAfter.isHidden = sugarAfter == 0
    spacingView.isHidden          = sugarAfter != 0
  }
  
 
  private func confirmeTextFieldsToNewDinner(textField: CustomValueTextField) {
    textField.isEnabled = true
    textField.backgroundColor =  .white
    textField.textColor       = .black
    textField.withCornerLayer = true
  }
  
  private func confirmeTextFieldsToPrevDinner(textField: CustomValueTextField) {
    textField.isEnabled = false
    textField.backgroundColor =  .clear
    textField.textColor       = .white
    textField.withCornerLayer = false
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


  private func updateCorrectInsulinPositionByNewSugar(correctInsulinBySugarPosition: CorrectInsulinPosition) {
    
    correctInsulinPosition = correctInsulinBySugarPosition
    updateViewsFromCorrectInsulinBySugarPosition()

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set View Models

extension ShugarSetView {
  
   private func setTime(viewModel:ShugarTopViewModelable) {
      
      timeBeforeLabel.text = DateWorker.shared.getTimeString(date: viewModel.timeBefore)
      timeAfterLabel.text = DateWorker.shared.getTimeString(date: viewModel.timeAfter)

    }
    
    private func setSugarBefore(viewModel:ShugarTopViewModelable) {
      
      let shugarBeforeString = viewModel.shugarBeforeValue == 0 ? "" : String(viewModel.shugarBeforeValue)
         shugarBeforeValueTextField.text = shugarBeforeString
  
      
    }
    
    private func setShugarAfter(viewModel:ShugarTopViewModelable) {


      shugarAfterValueTextField.text =  viewModel.shugarAfterValue == 0 ? "" : String(viewModel.shugarAfterValue)

      confirmeTextFieldsToPrevDinner(textField: shugarAfterValueTextField)
 
      
    }
    
    private func setCorrectInsulin(viewModel:ShugarTopViewModelable) {

      let correctInsulinByShugarString = viewModel.correctInsulinByShugar == 0 ? "" : String(viewModel.correctInsulinByShugar)
      
      correctionShugarInsulinValueTextField.text = correctInsulinByShugarString

    }
  
}

  // MARK: Switch ImageView to Label
extension ShugarSetView {
  
   private func switchLabelAndImageView(
     text: String,
     imageView: UIImageView,
     label: UILabel
   ) {
    
    if text.isEmpty {
    self.switchSugarLabelToImageView(imageView: imageView, label: label)
       } else {
    self.switchSugarImageViewToLabel(imageView: imageView, label: label)
       }

   }
   
   private func switchSugarImageViewToLabel(imageView: UIImageView,label: UILabel) {
     imageView.isHidden = false
     label.isHidden = true
   }
   private func switchSugarLabelToImageView(imageView: UIImageView,label: UILabel) {
     imageView.isHidden = true
     label.isHidden = false
   }
  
}

// MARK: Set Up Views

extension ShugarSetView {
  
  private func drawViews() {
    confirmViews()
    setUpViews()
  }
  
  
  private func confirmViews() {
    shugarBeforeValueTextField.addTarget(self, action: #selector(handleShugarBeforeTextChange), for: .editingChanged)
    
    shugarBeforeValueTextField.keyboardType = .decimalPad
    shugarAfterValueTextField.keyboardType = .decimalPad
    
    shugarBeforeValueTextField.delegate = self
    correctionShugarInsulinValueTextField.delegate = self
    
    correctionShugarInsulinValueTextField.inputView = pickerView
    pickerView.delegate = self
    pickerView.dataSource = self
  }
  
  
 
  
  private func setUpViews() {
       
      sugarBeforeImageView.isHidden = true
      sugarCorrectDownImageView.isHidden = true
       
       let stackViewBefore = UIStackView(arrangedSubviews: [
         shugarBeforeTitleLabel,
         sugarBeforeImageView,
         
       ])
//    timeBeforeLabel
       stackViewBefore.axis = .vertical
       
       let stackViewShugarBefore = UIStackView(arrangedSubviews: [
         stackViewBefore,shugarBeforeValueTextField
       ])
       
       stackViewShugarBefore.distribution = .fill
       shugarBeforeValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
       
       
       
       let stackViewAfter = UIStackView(arrangedSubviews: [
         sugarAfterImageView,
         timeAfterLabel
       ])
       stackViewAfter.axis = .vertical
       
       stackViewShugarAfter = UIStackView(arrangedSubviews: [
         stackViewAfter,shugarAfterValueTextField
       ])
       shugarAfterValueTextField.constrainWidth(constant: Constants.numberValueTextFieldWidth)
       
       
       stackViewShugarAfter.distribution = .fill
       // Он никогда не редактируется!
       shugarAfterValueTextField.isEnabled = false
       
       let stackView = UIStackView(arrangedSubviews: [
         stackViewShugarBefore,
         correctionShugarByInsulinStackView,
         stackViewShugarAfter,
         spacingView
       ])

       stackView.distribution = .fillEqually
       stackView.spacing = 10
       
       addSubview(stackView)
       stackView.fillSuperview()
       
       stackViewShugarAfter.isHidden = true
       correctionShugarByInsulinStackView.isHidden = true
       
  }
}

// MARK: TextField Delegate
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
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
        
        self.switchLabelAndImageView(text: text, imageView: self.sugarBeforeImageView, label: self.shugarBeforeTitleLabel)
      })
 
      didEndEdidtingShugarBefore(text: text)
      
    case correctionShugarInsulinValueTextField:
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
        
        self.switchLabelAndImageView(text: text, imageView: self.sugarCorrectDownImageView, label: self.correctionLabel)
      })
      
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
  
    let timeBefore = setTimeBeforTime()
    let shugarFloat = (text as NSString).floatValue

    let correctInsulinBySugarPosition = ShugarCorrectorWorker.shared.getCorrectInsulinBySugarPosition(sugar: shugarFloat)
    
    animateShowCorrectInsulinFields(correctInsulinPosition: correctInsulinBySugarPosition) { (_) in
      self.didSetShugarBeforeValueAndTimeClouser!(timeBefore,shugarFloat)
      }

  }
  
private func animateShowCorrectInsulinFields(correctInsulinPosition: CorrectInsulinPosition, complation: ((Bool) -> Void)? = nil){
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {

      self.updateCorrectInsulinPositionByNewSugar(correctInsulinBySugarPosition: correctInsulinPosition)
      
    }, completion: complation)
  
  }

  
  
}


// MARK: PickerView Delegate

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
