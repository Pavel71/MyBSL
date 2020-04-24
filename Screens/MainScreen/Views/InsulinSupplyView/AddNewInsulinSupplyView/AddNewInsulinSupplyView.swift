//
//  AddNewInsulinSupplyView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 21.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Класс забирает знаяение общего инсулина в картридже у пользователя!

final class AddNewInsulinSupplyView: AddNewElementView {
  
  static let sizeView : CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 150)
  
  
  // MARK: Propertys
  
  
  let maxInsulin: Float = 300
  
  
  var insulinSlider: UISlider = {
    let slider = UISlider(frame: .zero)
    slider.maximumValue = 1.0
    slider.minimumValue = 0.0
    slider.addTarget(self, action: #selector(handleSLiderValueChange), for: .valueChanged)
    slider.tintColor = .white
    
    slider.setValue(1, animated: false)
    return slider
  }()
  
  var insulinSupplyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "300 ед."
    
    return label
  }()
  
  var insulinSupplyTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = .white
    label.numberOfLines = 0
    label.text = "Инсулина в картридже:"
    
    return label
    
  }()
  
  var insulinSupplyValue: Int {
    (insulinSlider.value * maxInsulin).toInt()
  }
  
  lazy var bottomButtonsStackView = getBottomButtonStackView()
  
  // MARK: Clousers
  
  var didTapCancelButton: EmptyClouser?
  var didTapSaveButton: EmptyClouser?
  
  
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    okButton.isEnabled = true
    okButton.setTitleColor(.white, for: .normal)
    okButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    let insulinSupplyStack = UIStackView(arrangedSubviews: [insulinSupplyLabel])
    insulinSupplyStack.alignment = .center
    
    let insulinLabelsStack = UIStackView(arrangedSubviews: [
    insulinSupplyTitle,insulinSupplyStack
    ])
    insulinSupplyStack.constrainWidth(constant: 100)
    insulinLabelsStack.distribution = .fill
    insulinLabelsStack.spacing      = 5
    
    let verticalStackView = UIStackView(arrangedSubviews: [
    
    insulinLabelsStack,
    insulinSlider,
    bottomButtonsStackView
    ])
    
    bottomButtonsStackView.constrainHeight(constant: 40)
    
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fill
    verticalStackView.spacing = 5
    
    addSubview(verticalStackView)
    verticalStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    
    
  }
  
  // MARK: Signals
  
  override func handleCancelButton() {
    didTapCancelButton!()
    
  }
  
  override func handleSaveButton() {
    didTapSaveButton!()
  }
  
  @objc func handleSLiderValueChange(slider: UISlider) {
    
//    insulinSupplyLabel.text = "\(insulinSupplyValue) ед."
    setInsulinSupplyValue()
  }
  
  private func setInsulinSupplyValue() {
    insulinSupplyLabel.text = "\(insulinSupplyValue) ед."
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set View Model
extension AddNewInsulinSupplyView {
  
  func updateInsulinSupplyValue(insulinSuppValue: Float) {
    
   let value = insulinSuppValue / maxInsulin
   
   insulinSlider.setValue(value, animated: true)
   setInsulinSupplyValue()
  }
  
}
