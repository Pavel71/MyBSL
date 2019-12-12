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
    label.text = "Уровень Сахара в крови"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
    
  }()
  
  // Sugar Label
  
  let currentSugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Текущий сахар")
  
  var didTapSugarTextFieldButton: StringPassClouser?
  let currentSugarTextField = CustomCategoryTextField(padding: 5, placeholder: "6.0", cornerRaduis: 10, imageButton: #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate))
  
  // Switcher
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
   
    configureTextFields()
    backgroundColor = .orange
    setUpViews()
    
  }
  
  private func configureTextFields() {
    currentSugarTextField.addDoneButtonOnKeyboard()
    currentSugarTextField.keyboardType      = .decimalPad
    currentSugarTextField.delegate          = self
    currentSugarTextField.rightButton.alpha = 0
    
//       currentSugarTextField.rightButton.addTarget(self, action: #selector(handleTapConfirmButton), for: .touchUpInside)
  }
  
  // Handle Buttons
//  @objc private func handleTapConfirmButton(button: UIButton) {
//
//    guard let text = currentSugarTextField.text else {return}
//    guard !text.isEmpty else {return}
//
//    checkSugar(sugar: text)
//
//    didTapSugarTextFieldButton!(text)
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: SetUpViews
extension SugarCell {
  
  private func setUpViews() {
    
    
    let leftStakcView = UIStackView(arrangedSubviews: [
    currentSugarLabel,
    UIView()
    ])
    leftStakcView.axis         = .vertical
    leftStakcView.spacing      = 5
    leftStakcView.distribution = .fillEqually
    
    let rightStakcView = UIStackView(arrangedSubviews: [
    currentSugarTextField,
    UIView()
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
      horizontalStackView
    ])
    titleLabel.constrainHeight(constant: 20)
    
    overAllStackView.axis = .vertical
    overAllStackView.spacing = 10
    overAllStackView.distribution = .fill
    
    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
  }
}

// MARK: Check Sugar by Position
extension SugarCell {
  
  
  private func checkSugar(sugar: String) {
    
    let sugarFloat = (sugar as NSString).floatValue
    let wayCorrectPosition = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: sugarFloat)
    
    switch wayCorrectPosition {
    case .dontCorrect:
      print("Сахар в норме можно показывать ячейку с продуктами")
    case .correctDown:
      print("Высокий сахар нужно скорректировать доп инсулином и показываем продукты")
    case .correctUp:
      print("Сахар ниже нормы Показываем возможность добавить продукты")
    default:break
    }
  }
  
}

// MARK: TextFiedl Delegate

extension SugarCell: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print("End Editing")
    guard let text = textField.text else {return}
    guard !text.isEmpty else {return}
    
    checkSugar(sugar: text)
    
    didTapSugarTextFieldButton!(text)
  }
  
}
