//
//  LoginController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class LoginController: UIViewController {
  
  
  var loginView = LoginView()
  let loginModelView = LoginModelView()
  
//  var jgProgressHud: JGProgressHUD = {
//    let jgp = JGProgressHUD(style: .dark)
//    jgp.textLabel.text = "Log In"
//    return jgp
//  }()
  // Clousers
  var didFinishLogInClouser: (() -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    setLoginView()
    setViewObserver()
    setModelViewObserver()
    setTapGestureRecogniser()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setKeyboardNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: Set Layout
  private func setLoginView() {
    view.addSubview(loginView)
    loginView.fillSuperview()
  }
  
  // MARK: Set Observer
  private func setViewObserver() {
    loginView.didTapGoToBackRegistration = tapGoToBackRegisterController
    loginView.didTextChangeClouser = textFieldDidChange
    loginView.didTapLoginButtonClouser = tapLoginButton
  }
  
  private func setModelViewObserver() {
    loginModelView.isValidForm.observer = checkForm
    loginModelView.isLogIn.observer = logIn
  }
  
  // MARK: TapGestureTecogniser
  private func setTapGestureRecogniser() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapView))
    loginView.addGestureRecognizer(tapGesture)
  }
  
  @objc private func handleTapView() {
    loginView.endEditing(true)
  }
  
  // MARK: Keyboard Notififcation
  
  private func setKeyboardNotification() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillUP), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func handleKeyBoardWillUP(notification: Notification) {

    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyboardFrame = value.cgRectValue
    
    let gapBottomFromStackViewAndBottom = loginView.frame.height - loginView.overAllStackView.frame.height - loginView.overAllStackView.frame.origin.y
    
    let diff = keyboardFrame.height - gapBottomFromStackViewAndBottom
    
    Animator.springTranslated(view: loginView, cgaTransform: CGAffineTransform(translationX: 0, y: -diff))
  }
  
  @objc private func handleKeyBoardWillHide(notification: Notification) {
    Animator.springTranslated(view: loginView, cgaTransform:.identity)
  }
  
  // MARK: TextFieldDIDChange
  
  private func textFieldDidChange(textField: UITextField) {

    switch textField {
    case loginView.emailTextField:
      loginModelView.email = textField.text
    default:
      loginModelView.password = textField.text
    }
  }
  
  // MARK: CheckForm
  
  private func checkForm(isValid: Bool?) {
    
    guard let isValid = isValid else {return}
    loginView.loginButton.isEnabled = isValid
    if isValid {
      
      loginButtonAble()
    } else {
      loginButtonDisable()
    }
    
  }
  // MARK: LogIn
  
  private func logIn(logIn: Bool?) {
    
    guard let logIn = logIn else {return}
//    if logIn {
//      jgProgressHud.show(in: loginView)
//      loginButtonDisable()
//    } else {
//      jgProgressHud.dismiss()
//      loginButtonAble()
//    }
    
  }
  
  private func loginButtonAble() {
    loginView.loginButton.backgroundColor = #colorLiteral(red: 0.8327895403, green: 0.09347004443, blue: 0.3214370608, alpha: 1)
    loginView.loginButton.setTitleColor(.white, for: .normal)
  }
  
  private func loginButtonDisable() {
    loginView.loginButton.backgroundColor = .lightGray
    loginView.loginButton.setTitleColor(.black, for: .disabled)
  }
  
  
  
  // MARK: Tap LoginButton
  private func tapLoginButton() {
    // Здесь нужно запустить метода передачи данных в firebase!

//    loginModelView.performSignIn { (result) in
//      switch result {
//      case .failure(let error):
//        self.showAlert(title: "Ошибка входа", message: error.localizedDescription)
//        self.loginModelView.isLogIn.value = false
//      case .success(_):
//
//        self.dismiss(animated: true, completion: {
//          // После перехода запусти на Main Controllere подгрузку данных
//          self.didFinishLogInClouser!()
//
//        })
//
//      }
//    }
    
  }
  
  private func tapGoToBackRegisterController() {
    let registrationController = RegistrationController()
    navigationController?.pushViewController(registrationController, animated: true)
//    navigationController?.popViewController(animated: true)
  }
  
  
  
 
}
