//
//  LoginView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class LoginView: UIView {
  
  let emailTextField: CustomTextField = {
    let tf = CustomTextField(padding: 16,placeholder:"Введите email", cornerRaduis: 10)
    
    tf.backgroundColor = .white
    tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    tf.keyboardType = .emailAddress
    return tf
  }()
  
  let passwordTextField: CustomTextField = {
    let tf = CustomTextField(padding: 16,placeholder:"Введите password",cornerRaduis: 10)
    
    tf.backgroundColor = .white
    tf.isSecureTextEntry = true
    tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    
    return tf
  }()
  
  let loginButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Войти", for: .normal)
    b.setTitleColor(.black, for: .disabled)
    b.isEnabled = false
    b.backgroundColor = .lightGray
    b.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    b.constrainHeight(constant: 50)
    b.layer.cornerRadius = 25
    
    b.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
    return b
  }()
  
  let goToRegistrationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Регистрация", for: .normal)
    button.setTitleColor(.white, for: .normal)
    
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    button.addTarget(self, action: #selector(handleGoToRegister), for: .touchUpInside)
    
    return button
  }()
  
  let resetPasswordButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Забыли пароль?", for: .normal)
    button.setTitleColor(.white, for: .normal)
    
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    button.addTarget(self, action: #selector(handleResetPasswordButton), for: .touchUpInside)
    
    return button
  }()
  
  lazy var overAllStackView = VerticalStackView(arrangedSubviews: [
    emailTextField,
    passwordTextField,
    loginButton
    ], customSpacing: 5)
  
  let gradientLayer = CAGradientLayer()
  
  var forrgotPasswordView = ForgotPasswordView(frame: ForgotPasswordView.sizeView)
  
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    
    setUpGradientlayer()
    
    setUPOverAllStackView()

    setUpBlurEffect()
    setUpResetPasswordView()

  }
  

  
  var didTextChangeClouser: ((UITextField) -> Void)?
  
  @objc private func handleTextChange(textField: UITextField) {
    didTextChangeClouser!(textField)
  }
  
  var didTapLoginButtonClouser: (() -> Void)?
  @objc private func handleLoginButton() {
    didTapLoginButtonClouser!()
  }
  
  var didTapGoToBackRegistration: (() -> Void)?
  @objc private func handleGoToRegister() {
    didTapGoToBackRegistration!()
  }
  
  var didResetPasswordButton: EmptyClouser?
  @objc private func handleResetPasswordButton() {
    didResetPasswordButton!()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Up Views
extension LoginView {
  
  private func setUPOverAllStackView() {
    overAllStackView.distribution = .fillEqually
    
    addSubview(overAllStackView)
    overAllStackView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
    overAllStackView.centerInSuperview()
    
    let bottomStackView = UIStackView(arrangedSubviews: [
    goToRegistrationButton,resetPasswordButton
    ])
    bottomStackView.distribution = .fillEqually
    bottomStackView.spacing = 5
    
    addSubview(bottomStackView)
    bottomStackView.anchor(top: nil, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 30, bottom: 0, right: 30))
  }
  
  private func setUpResetPasswordView() {
    
    addSubview(forrgotPasswordView)
    forrgotPasswordView.centerInSuperview()
    
    forrgotPasswordView.constrainWidth(constant: ForgotPasswordView.sizeView.width)
    forrgotPasswordView.constrainHeight(constant: ForgotPasswordView.sizeView.height)
  
    forrgotPasswordView.hideViewUnderBottomInCenter()
    
  }
  
  // Нужно вызвать определение Layout заново
  override func layoutSubviews() {
    gradientLayer.frame = frame
  }
  
  private func setUpGradientlayer() {

    let topColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor ]
    gradientLayer.locations = [0,1]
    
    layer.addSublayer(gradientLayer)
    
    
  }
  
   private func setUpBlurEffect() {
      addSubview(blurView)
     blurView.fillSuperview()

      blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnBlur)))
    }
   
   @objc private func didTapOnBlur() {
     self.superview?.endEditing(true)
   }
}
