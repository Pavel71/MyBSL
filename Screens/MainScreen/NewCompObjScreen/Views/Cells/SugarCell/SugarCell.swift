//
//  SugarCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol SugarCellable {
  
  
  var cellState            : SugarCellState {get set}
  var correctionImage      : UIImage? {get set}
  var compansationString   : String? {get set}
  var currentSugar         : Float? {get set}
  var correctionSugarKoeff : Float? {get set} // Свойство которое будет заполнятся если сахар вне нормы
  
}

enum  SugarCellState {
  case currentLayer
  case currentLayerAndCorrectionLabel
  case currentLayerAndCorrectionLayer
}



class SugarCell: UITableViewCell {
  
  static let cellId = "SugarCell"
  
  var cellState: SugarCellState = .currentLayer
  
  // Properties
  
  let titleLabel: UILabel = {
    
    let label = UILabel()
    label.text          = "Уровень Сахара в крови"
    label.font          = UIFont.systemFont(ofSize: 18, weight: .semibold)
    label.textColor     = .white
    label.textAlignment = .center
    return label
    
  }()
  
  // Sugar Layer
  
  let currentSugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Текущий сахар:")
  
  var currentSugarButton : UIButton =  {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "sugar-cubes").withRenderingMode(.alwaysOriginal), for: .normal)
    b.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    return b
  }()
  
  var passCurrentSugarClouser: StringPassClouser?
  let currentSugarTextField = CustomCategoryTextField(padding: 5, placeholder: "6.0", cornerRaduis: 10, imageButton: #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate))
  
  
  // Let Compansation Layer
  
  let compansationSugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар в норме")

  let correctionButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "anesthesia").withRenderingMode(.alwaysOriginal), for: .normal)
    b.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    return b
  }()
  let correctionTextField = CustomCategoryTextField(padding: 5, placeholder: "", cornerRaduis: 10, imageButton: #imageLiteral(resourceName: "robot32").withRenderingMode(.alwaysOriginal))
  
  // MARK: Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .orange
    
    correctionButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    currentSugarButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    
    configureSugarLayer()
    configureCorrectSugarLayer()
    
    setUpViews()
    
  }
  
  private func configureSugarLayer() {
    currentSugarTextField.addDoneButtonOnKeyboard()
    currentSugarTextField.keyboardType      = .decimalPad
    currentSugarTextField.delegate          = self
    currentSugarTextField.rightButton.alpha = 0
  }
  
  private func configureCorrectSugarLayer() {
    
    
    compansationLayerHidden()
    
    compansationSugarLabel.textAlignment = .center
    compansationSugarLabel.numberOfLines = 0
    compansationSugarLabel.textColor     = #colorLiteral(red: 0.05815836042, green: 0.1558106244, blue: 0.9651042819, alpha: 1)
    
    
    correctionTextField.addDoneButtonOnKeyboard()
    correctionTextField.keyboardType     = .decimalPad
    correctionTextField.rightButton.addTarget(self, action: #selector(handleCorrectSugarRobotButton), for: .touchUpInside)
    correctionTextField.delegate         = self
    
  }
  
  private func compansationLayerHidden() {
    compansationSugarLabel.isHidden      = true
    correctionTextField.isHidden         = true
    correctionButton.isHidden            = true
  }
  
  private func correctionStackViewHidden() {
    compansationSugarLabel.isHidden      = false
    correctionTextField.isHidden         = true
    correctionButton.isHidden            = true

  }
  
  private func comapsnationLayerDontHidden() {
    compansationSugarLabel.isHidden      = false
    correctionTextField.isHidden         = false
    correctionButton.isHidden            = false
  }
  
  
  // MARK: Clousers
  
  
  var didTapCurrentSugarButton      : EmptyClouser?
  var didTapCorrectionInsulinButton : EmptyClouser?
  var didTapRobotInfoButton         : EmptyClouser?
  var didUserSetCopmansationInsulin : StringPassClouser?
  
  @objc private func tapButton(button: UIButton) {
    switch button {
    case correctionButton:
      didTapCorrectionInsulinButton!()
    case currentSugarButton:
      didTapCurrentSugarButton!()
    default:break
    }
    
  }
  
  @objc private func handleCorrectSugarRobotButton() {
    didTapRobotInfoButton!()
  }
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: SetUpViews
extension SugarCell {
  
  private func setUpViews() {
    

    let currentStackView    = getCurrentSugarStackView()
    let correctionStackView = getCorrectionStackView()
    
    let overAllStackView = UIStackView(arrangedSubviews: [
      currentStackView,
      correctionStackView
    ])
    overAllStackView.spacing      = SugarCellHeightWorker.spacing
    overAllStackView.distribution = .fill
    overAllStackView.axis         = .vertical
    
    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: SugarCellHeightWorker.padding)
  }
  
  // MARK: SetUp Current Sugr Layer
  
  private func getCurrentSugarStackView() -> UIStackView {

    
    let currentstackView = UIStackView(arrangedSubviews: [
      currentSugarButton,currentSugarTextField
    ])
    currentSugarButton.constrainHeight(constant: SugarCellHeightWorker.valueHeight)
    currentSugarButton.constrainWidth(constant: SugarCellHeightWorker.valueHeight)
    
    currentstackView.spacing      = 20
    currentstackView.distribution = .fill
    
    
    
    let overAllStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      currentstackView
    ])
    
    titleLabel.constrainHeight(constant: SugarCellHeightWorker.titleHeight)
    
    overAllStackView.spacing      = SugarCellHeightWorker.spacing * 2
    overAllStackView.distribution = .fill
    overAllStackView.axis         = .vertical
    
    return overAllStackView
  }
  
  
  // MARK: Set Uo Correction Sugar LAyer
  
  private func getCorrectionStackView() -> UIStackView {

    
    let correctionStackView = UIStackView(arrangedSubviews: [
      correctionButton, correctionTextField
    ])
    correctionButton.constrainHeight(constant: SugarCellHeightWorker.valueHeight)
    correctionButton.constrainWidth(constant: SugarCellHeightWorker.valueHeight)
    correctionStackView.spacing      = 20
    correctionStackView.distribution = .fill
    
    
    
    let overAllStackView = UIStackView(arrangedSubviews: [
      
      compansationSugarLabel,
      correctionStackView
      
    ])
    
    compansationSugarLabel.constrainHeight(constant: SugarCellHeightWorker.compansationTitleHeight)
    
    overAllStackView.spacing      = SugarCellHeightWorker.spacing * 2
    overAllStackView.distribution = .fill
    overAllStackView.axis         = .vertical
    
    return overAllStackView
    
  }
}





// MARK: Set ViewModel
extension SugarCell {
  
  func setViewModel(viewModel: SugarCellModel) {
    
    
    
    let currentSugar = viewModel.currentSugar != nil ? "\(viewModel.currentSugar!)": ""
    currentSugarTextField.text = currentSugar
    
    
    let correctionKoeff = viewModel.correctionSugarKoeff != nil ? "\(floatTwo: viewModel.correctionSugarKoeff!)" : ""
    
    correctionTextField.text   = correctionKoeff
    
    correctionButton.setImage(viewModel.correctionImage?.withRenderingMode(.alwaysOriginal), for: .normal)
      
    let compansationString = viewModel.compansationString != nil ? viewModel.compansationString! : ""
    compansationSugarLabel.text = compansationString
    
    
    
    cellState = viewModel.cellState
    
    setComapsnationLayerHidden()
    
  }
  
  
  private func setComapsnationLayerHidden() {
    
//    comapsnationLayerDontHidden()
    
    switch cellState {
    case .currentLayer:
      
      compansationLayerHidden()
    case .currentLayerAndCorrectionLabel:

//      correctionStackViewHidden()
      comapsnationLayerDontHidden()
    case .currentLayerAndCorrectionLayer:
      comapsnationLayerDontHidden()
    }
  }
}

// MARK: Check Sugar by Position
extension SugarCell {
  
  

  
  // MARK: Animated CompansationLabel
  
  private func animatedCompansationSugarLabel(isHidden: Bool) {
    
    layoutIfNeeded()
    UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
      self.compansationSugarLabel.isHidden = isHidden
    }, completion: nil)
    layoutIfNeeded()
    
    //    UIView.transition(with: compansationSugarLabel, duration: 0.5, options: .curveEaseOut, animations: {
    //      self.compansationSugarLabel.isHidden = isHidden
    //    }, completion: nil)
  }
  
}



// MARK: TextFiedl Delegate

extension SugarCell: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else {return}
    
    
    switch textField {
    case correctionTextField:
      
      didUserSetCopmansationInsulin!(text)
      
    case currentSugarTextField:
      
      passCurrentSugarClouser!(text)
      
 
    default:break
    }
   
  }
  
}
