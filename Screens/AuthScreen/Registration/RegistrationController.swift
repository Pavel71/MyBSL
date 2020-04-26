//
//  RegistrationController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//


import UIKit
//import JGProgressHUD

class RegistrationController: UIViewController {
  
  
  
  let registrationView      = RegistrationView()
  
  lazy var registerButton   = registrationView.registerButton
  lazy var overallStackView = registrationView.overallStackView
  let registrationViewModel = RegistrationViewModel()
 

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpViews()
    addTapGestureRecognizer()
    

    // Set Up RegistrationObserver
    setupRegistratioViewModelObserver()
  }
  
  private func setUpViews() {
    self.view.addSubview(registrationView)
    registrationView.fillSuperview()
    
    setRegistrationViewSignals()
  }
  
  private func setRegistrationViewSignals() {
    registrationView.emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    
    registrationView.passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    registrationView.fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    
    registrationView.registerButton.addTarget(self, action: #selector(handleRegistrationButton), for: .touchUpInside)
    
    registrationView.goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
    // Здесь так как они будут включатся при призентации!
    setKeyboardNotification()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // remove all Notification!
    NotificationCenter.default.removeObserver(self)
  }

  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    registrationView.gradientLayer.frame = view.bounds
  }
  

  
  // MARK: HandleGoToLogin Button
  
  @objc private func handleGoToLogin() {
    
//    let loginController = LoginController()
//    navigationController?.pushViewController(loginController, animated: true)
    navigationController?.popViewController(animated: true)

  }
  
 
  
  
  
  
  
 
  // MARK:  Set UP Observer
  
  
  private func setupRegistratioViewModelObserver() {
    
    registrationViewModel.bindableISFormValid.bind(observer: chekForm)
    
//    registrationViewModel.bindableImage.bind(observer: setChooseImage)

  }
  

  
  private func chekForm(isFormValid: Bool?) {
    
    guard let isFormValid = isFormValid else {return}
    registrationView.registerButton.isEnabled = isFormValid
    if isFormValid {
      registerButton.setTitleColor(.white, for: .normal)
      registerButton.backgroundColor = #colorLiteral(red: 0.8327895403, green: 0.09347004443, blue: 0.3214370608, alpha: 1)
    } else {
      registerButton.setTitleColor(.black, for: .normal)
      registerButton.backgroundColor = .lightGray
    }
  }
  
  // MARK: TextField Handle
  
  @objc private func handleTextChange(textField: UITextField) {
    
    switch textField {
      
    case registrationView.fullNameTextField:
      registrationViewModel.fullName = textField.text
    case registrationView.emailTextField:
      registrationViewModel.email = textField.text
    case registrationView.passwordTextField:
      registrationViewModel.password = textField.text
    default:
      break
    }
 
  }
  
  // MARK: Registration in Firebase
//  var registerHUD: JGProgressHUD = {
//    let hud = JGProgressHUD(style: .dark)
//    hud.textLabel.text = "Register"
//    return hud
//  }()
  
  @objc private func handleRegistrationButton() {
    // Убрать клавиатуру
    handleTapView()
    
//    registerHUD.show(in: view)
    
    registrationViewModel.performRegistration { (result) in
     
      
//      switch result {
//      case .failure(let error):
//        self.showHUDWithError(error)
//      case .success(_):
//        self.registerHUD.dismiss()
//        print("Registration Sucsess!")
//
//        self.present(MainController(), animated: true, completion: nil)
//      }
    }

    
  }
  
  fileprivate func showHUDWithError(_ error: Error) {
    
//    registerHUD.dismiss()
//
//    let hud = JGProgressHUD(style: .dark)
//    hud.textLabel.text = "Failed registration"
//    hud.detailTextLabel.text = error.localizedDescription
//    hud.show(in: self.view)
//    hud.dismiss(afterDelay: 4)
  }
  

  
}



// MARK: Set WillShow Cancel Keyboard

extension RegistrationController {
  
  
  private func setKeyboardNotification() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleWillShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  // Клавиватура Появилась
  @objc private func handleWillShowKeyboard(notification: Notification) {
    // Достаем по ключу значение
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyBoardFrame = value.cgRectValue

    
    let bottomGapFromStackViewAndBotton = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
    
    let difference = keyBoardFrame.height - bottomGapFromStackViewAndBotton

    Animator.springTranslated(view: view, cgaTransform: CGAffineTransform(translationX: 0, y: -difference - 8))
    
  }
  
  // Клавиатура Скрылась
  @objc private func handleKeyBoardHide(notification: Notification) {
    Animator.springTranslated(view: view, cgaTransform: .identity)
  }
  
  // MARK: Tap View Gesture

  private func addTapGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapView))
    
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  @objc func handleTapView() {
    view.endEditing(true)
  }
  
  // MARK: Trait Collection
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    
    if self.traitCollection.verticalSizeClass == .compact {
      overallStackView.axis = .horizontal
    } else {
      overallStackView.axis = .vertical
    }
  }
}
