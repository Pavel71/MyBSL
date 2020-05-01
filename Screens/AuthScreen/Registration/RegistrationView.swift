//
//  RegistrationView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class RegistrationView: UIView {
  
  
  
//  let fullNameTextField: CustomTextField = {
//
//
//      let tf = CustomTextField(padding: 16, placeholder: "Введите Имя",cornerRaduis:10)
//
//      tf.backgroundColor = .white
//      return tf
//    }()
    
    let emailTextField: CustomTextField = {
      let tf = CustomTextField(padding: 16,placeholder: "Введите email",cornerRaduis:10)
  
      tf.backgroundColor = .white
      tf.keyboardType = .emailAddress
      return tf
    }()
    
    let passwordTextField: CustomTextField = {
      let tf = CustomTextField(padding: 16,placeholder: "Введите password",cornerRaduis:10)
  
      tf.backgroundColor = .white
      tf.isSecureTextEntry = true
      
      return tf
    }()
    
    let registerButton: UIButton = {
      let b = UIButton(type: .system)
      b.setTitle("Регистрация", for: .normal)
      b.setTitleColor(.black, for: .disabled)
      b.isEnabled = false
      b.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
      b.backgroundColor = .lightGray
      b.constrainHeight(constant: 50)
      b.layer.cornerRadius = 25
      
      return b
    }()
    
    let goToLoginButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Уже есть Логин?", for: .normal)
      button.setTitleColor(.white, for: .normal)
   
      button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
 
      
      return button
    }()
    
    
    
    lazy var verticalStackView:UIStackView = {
      let sv = UIStackView(arrangedSubviews: [
        
        emailTextField,
        passwordTextField,
        registerButton
        ])
      sv.axis = .vertical
      sv.spacing = 5
      sv.distribution = .fillEqually
      return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
      verticalStackView
      ])
    
    let gradientLayer = CAGradientLayer()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradienLayer()
    setupLayout()
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
  // MARK: Set Up Views
extension RegistrationView {
  

  
  private func setupLayout() {
    
    
    
    overallStackView.axis = .vertical
    overallStackView.spacing = 5
    
    
    self.addSubview(overallStackView)
    
    
    overallStackView.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
    overallStackView.centerYInSuperview()
    
    self.addSubview(goToLoginButton)
    goToLoginButton.anchor(top: nil, leading: self.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.trailingAnchor)

  }
  
  private func setupGradienLayer() {
    
    let topColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor ]
    gradientLayer.locations = [0,1]
    
    self.layer.addSublayer(gradientLayer)
    
  }
}
