//
//  RegistrationController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//


import UIKit
import JGProgressHUD

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
    
    let loginController = LoginController()
    navigationController?.pushViewController(loginController, animated: true)
//    navigationController?.popViewController(animated: true)

  }
  
 
  
  
  
  
  
 
  // MARK:  Set UP Observer
  
  
  private func setupRegistratioViewModelObserver() {
    
    registrationViewModel.bindableISFormValid.bind(observer: chekForm)
    


  }
  

  
  private func chekForm(isFormValid: Bool?) {
    
    guard let isFormValid = isFormValid else {return}
    registrationView.registerButton.isEnabled = isFormValid
    if isFormValid {
      registerButton.setTitleColor(.white, for: .normal)
      registerButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    } else {
      registerButton.setTitleColor(.black, for: .normal)
      registerButton.backgroundColor = .lightGray
    }
  }
  
  // MARK: TextField Handle
  
  @objc private func handleTextChange(textField: UITextField) {
    
    switch textField {
      
    case registrationView.emailTextField:
      registrationViewModel.email = textField.text
    case registrationView.passwordTextField:
      registrationViewModel.password = textField.text
    default:
      break
    }
 
  }
  
  // MARK: Registration in Firebase
  var registerHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Register"
    return hud
  }()
  
  @objc private func handleRegistrationButton() {
    // Убрать клавиатуру
    handleTapView()
    
    registerHUD.show(in: view)
    
    registrationViewModel.performRegistration { (result) in
     
      
      switch result {
      case .failure(let error):
        self.showHUDWithError(error)
      case .success(_):
        self.registerHUD.dismiss()
        
        // Регистрация пройдена успешно нужно запустить OnBoardingScreen
        
        let appState = AppState.shared
        appState.toogleMinorWindow(minorWindow: appState.loginRegisterWindow)
        appState.toogleMinorWindow(minorWindow: appState.onBoardingWindow)
        
        print("Registration Sucsess!")

//        self.present(MainController(), animated: true, completion: nil)
      }
    }

    
  }
  
  fileprivate func showHUDWithError(_ error: Error) {
    
    registerHUD.dismiss()

    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Ошибка Регистрации"
    hud.detailTextLabel.text = "Такой емаил уже есть в базе"
    hud.show(in: self.view)
    hud.dismiss(afterDelay: 4)
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
    
    if  difference > 0 {

      Animator.springTranslated(view: registrationView, cgaTransform: CGAffineTransform(translationX: 0, y: -difference - 10))
    }
    
  }
  
  // Клавиатура Скрылась
  @objc private func handleKeyBoardHide(notification: Notification) {
    Animator.springTranslated(view: registrationView, cgaTransform: .identity)
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
