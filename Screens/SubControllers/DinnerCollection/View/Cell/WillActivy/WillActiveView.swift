//
//  WillActiveView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class WillActiveView: UIView {
  
  
  let activityImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "running").withRenderingMode(.alwaysTemplate))
    iv.tintColor = .white
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
//  let activityTitle = CustomLabels(font: UIFont.systemFont(ofSize: 18), text: "Тренировка:")
  
  let activeOn: UISwitch = {
    let st = UISwitch()
    st.tintColor = Constants.Color.lightBlueBackgroundColor
    st.onTintColor = Constants.Color.darKBlueBackgroundColor
    st.addTarget(self, action: #selector(handleSwitchActive), for: .valueChanged)
    return st
  }()
  
  let trainTextField = CustomCategoryTextField(
    padding: 5,
    placeholder: "Бассейн",
    cornerRaduis: 10,
    imageButton: #imageLiteral(resourceName: "list")
  )
  
  
  // Clousers
  var didSwitchActiveView: EmptyClouser?
  
  
  
  // Добавить сюда этот список
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  
//    activityTitle.numberOfLines = 0
    trainTextField.isHidden = true
    trainTextField.alpha = 0
    trainTextField.delegate = self
    
    
    trainTextField.addDoneButtonOnKeyboard()
    

    
    
    let containerView = UIView()
    containerView.addSubview(activeOn)
    activeOn.centerInSuperview()
    

    let overStackView = UIStackView(arrangedSubviews: [
      activityImageView,containerView,trainTextField
      ])

    overStackView.distribution = .fillEqually
    
    
    addSubview(overStackView)
    overStackView.fillSuperview()
    
  }
  
  
  
  
  
  // Switch On
  
  @objc private func handleSwitchActive(switchOn: UISwitch) {
    
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      
      self.trainTextField.isHidden = !switchOn.isOn
      self.trainTextField.alpha = switchOn.isOn ? 1 : 0
      
      self.activityImageView.isHidden = switchOn.isOn
      self.activityImageView.alpha = !switchOn.isOn ? 1 : 0
      
    }, completion: nil)
    
    didSwitchActiveView!()
  
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  var didBeginEditingTrainTextField: TextFieldPassClouser?
  var didEndEditingTrainTextField: TextFieldPassClouser?
  
}

extension WillActiveView: UITextFieldDelegate {
  
  // Начал пользоватся
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditingTrainTextField!(textField)
  }
  // Закончил пользоватся
  func textFieldDidEndEditing(_ textField: UITextField) {
    didEndEditingTrainTextField!(textField)
  }
}
