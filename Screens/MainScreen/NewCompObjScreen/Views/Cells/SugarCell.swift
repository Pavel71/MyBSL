//
//  SugarCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class SugarCell: UITableViewCell {
  
  static let cellId = "SugarCell"
  
  // Properties
  
  let titleLabel: UILabel = {
    
    let label = UILabel()
    label.text          = "Уровень Сахара в крови"
    label.font          = UIFont.systemFont(ofSize: 18, weight: .semibold)
    label.textColor     = .white
    label.textAlignment = .center
    return label
    
  }()
  
  // Sugar Label
  
  let currentSugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Текущий сахар:")
  
  var didTapSugarTextFieldButton: StringPassClouser?
  let currentSugarTextField = CustomCategoryTextField(padding: 5, placeholder: "6.0", cornerRaduis: 10, imageButton: #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate))
  
  
  // Let Compansation Sugar Title
  
  let compansationSugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Сахар в норме")
  
  // MARK: Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .orange
    
    compansationSugarLabel.isHidden      = true
    compansationSugarLabel.textAlignment = .center
    compansationSugarLabel.numberOfLines = 0
    
    configureTextFields()
    
    setUpViews()
    
  }
  
  private func configureTextFields() {
    currentSugarTextField.addDoneButtonOnKeyboard()
    currentSugarTextField.keyboardType      = .decimalPad
    currentSugarTextField.delegate          = self
    currentSugarTextField.rightButton.alpha = 0
    
  }
  

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: SetUpViews
extension SugarCell {
  
  private func setUpViews() {
    
    
    let leftStakcView = UIStackView(arrangedSubviews: [
    currentSugarLabel,
    
    ])
    leftStakcView.axis         = .vertical
    leftStakcView.spacing      = 5
    leftStakcView.distribution = .fillEqually
    
    let rightStakcView = UIStackView(arrangedSubviews: [
    currentSugarTextField,
    
    ])
    rightStakcView.axis         = .vertical
    rightStakcView.spacing      = 5
    rightStakcView.distribution = .fillEqually
    
    let horizontalStackView = UIStackView(arrangedSubviews: [
    leftStakcView,rightStakcView
    ])
    horizontalStackView.distribution = .fillEqually
    horizontalStackView.spacing      = 5
    
    let overAllStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      horizontalStackView,
      compansationSugarLabel
    ])
    horizontalStackView.constrainHeight(constant: NewCompansationObjConstants.Cell.SugarCell.sugarDataStackViewHeigth)
    titleLabel.constrainHeight(constant: NewCompansationObjConstants.Cell.titleLabelHeight)
    compansationSugarLabel.constrainHeight(constant: NewCompansationObjConstants.Cell.SugarCell.sugarCompansationLabelheight)
    
    overAllStackView.axis = .vertical
    overAllStackView.spacing = 10
    overAllStackView.distribution = .fill
    
    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: NewCompansationObjConstants.Cell.paddingInCell)
  }
}

// MARK: Set ViewModel
extension SugarCell {
  
  func configureCell(isCompansationLabelHidden: Bool) {
    
    animatedCompansationSugarLabel(isHidden: isCompansationLabelHidden)
//    compansationSugarLabel.isHidden = isCompansationLabelHidden
  }
}

// MARK: Check Sugar by Position
extension SugarCell {
  
  
  private func checkSugar(sugar: String) {
    
    let sugarFloat = (sugar as NSString).floatValue
    let wayCorrectPosition = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: sugarFloat)
    
    var compansationString: String!
    
    switch wayCorrectPosition {
    case .dontCorrect:
      compansationString = "Сахар в норме"
      print("Сахар в норме можно показывать ячейку с продуктами")
    case .correctDown:
      compansationString = "Сахар выше нормы! нужна коррекция инсулином!"
      print("Высокий сахар нужно скорректировать доп инсулином и показываем продукты")
    case .correctUp:
      compansationString = "Сахар ниже нормы! нужна коррекция углеводами!"
      print("Сахар ниже нормы Показываем возможность добавить продукты")
    default:break
    }
    
    
//    animatedCompansationSugarLabel(isHidden: false)
    
    compansationSugarLabel.text = compansationString
  }
  
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
    print("End Editing")
    guard let text = textField.text else {return}
    guard !text.isEmpty else {
      if compansationSugarLabel.isHidden == false {
        animatedCompansationSugarLabel(isHidden: true)
      }
      return
      
    }
    didTapSugarTextFieldButton!(text)
    
    checkSugar(sugar: text)
    
//    didTapSugarTextFieldButton!(text)
  }
  
}
