
//  LoginController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import JGProgressHUD



class LoginController: UIViewController {
  
  
  var loginView = LoginView()
  let loginModelView = LoginModelView()
  
  var jgProgressHud: JGProgressHUD = {
    let jgp = JGProgressHUD(style: .dark)
    jgp.textLabel.text = "Log In"
    return jgp
  }()
  
  var fetchDataHud: JGProgressHUD = {
    let jgp = JGProgressHUD(style: .dark)
    jgp.textLabel.text = "Загрузка данных"
    return jgp
  }()
  
  // Clousers
  var didFinishLogInClouser: (() -> Void)?
  
  // MARK: Deinit
  
  deinit {
    print("Deinit Login Controller")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setLoginView()
    setViewObserver()
    setModelViewObserver()
    setTapGestureRecogniser()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
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

  private func loginButtonAble() {
    loginView.loginButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    loginView.loginButton.setTitleColor(.white, for: .normal)
  }
  
  private func loginButtonDisable() {
    loginView.loginButton.backgroundColor = .lightGray
    loginView.loginButton.setTitleColor(.black, for: .disabled)
  }
  
  
  
}


// MARK: Set View Observer

extension LoginController {
  
  
  private func setViewObserver() {
    loginView.didTapGoToBackRegistration = {[weak self] in self?.tapGoToBackRegisterController()}
    loginView.didTextChangeClouser       = {[weak self] textField in self?.textFieldDidChange(textField:textField)}
    loginView.didTapLoginButtonClouser   = {[weak self] in self?.tapLoginButton()}
    loginView.didResetPasswordButton     = {[weak self] in self?.tapResetPasswordButton()}
    
    loginView.forrgotPasswordView.didTapCancelButtonCLouser = {[weak self] in
      self?.handleCancelForgotPasswordButton()
    }
    loginView.forrgotPasswordView.didInputEmailChanging = {[weak self] email in
      self?.validInputEmailToResetPassword(email: email)
    }
    
    loginView.forrgotPasswordView.didTapSaveButtonClouser = {[weak self] validEmail in
      self?.tapSendEmailToChangePassword(email: validEmail)
    }
    
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
  
  private func tapGoToBackRegisterController() {
    //    let registrationController = RegistrationController()
    //    navigationController?.pushViewController(registrationController, animated: true)
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Tap LoginButton
  private func tapLoginButton() {
    // Здесь нужно запустить метода передачи данных в firebase!
    
    loginModelView.performSignIn { (result) in
      
      switch result {
        
      case .failure(let error):
        
        
        self.showErrorMessage(text: "Ошибка входа",detailText: error.localizedDescription )
        self.loginModelView.isLogIn.value = false
        
      case .success(_):
        
        print("Login Success")
        self.loginModelView.isLogIn.value = false
        
        let appState = AppState.shared
        
//        appState.pushUpdateMainScreenViewControllerMethod()
        
        // Здесь нужно удалить текущий день из базы данных! Так как он мешает
        
        // Попробую так покачто
        let newdatRealmManger: NewDayRealmManager! = ServiceLocator.shared.getService()
        newdatRealmManger.deleteDaysRealm() // Очистим повторно
        
        appState.setMainTabBarController()
        appState.toogleMinorWindow(minorWindow: appState.loginRegisterWindow)
        
//        self.fetchDataHud.show(in: self.loginView, animated: true)

//        self.loginModelView.fetchDataFromFirebase { (result) in
//
//           switch result {
//
//             case .failure(let error):
//               self.fetchDataHud.dismiss()
//               self.showErrorMessage(text: error.localizedDescription)
//
//             case .success(_):
//
//               self.fetchDataHud.dismiss()
//
//               self.view.endEditing(true)
//
//               let appState = AppState.shared
//
//               appState.pushUpdateMainScreenViewControllerMethod()
//
//               appState.toogleMinorWindow(minorWindow: appState.loginRegisterWindow)
//
//               // Нужно заказать обновление данных в Устройстве
//
//             }
//        }
        
   
        

        
      }
    }
    
  }
}

// MARK: Set ViewModel Observer

extension LoginController {
  
  private func setModelViewObserver() {
    loginModelView.isValidForm.observer = checkForm
    loginModelView.isLogIn.observer = logIn
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
    if logIn {
      jgProgressHud.show(in: loginView)
      loginButtonDisable()
    } else {
      jgProgressHud.dismiss()
      loginButtonAble()
    }
    
  }
  
}


//MARK: Reset Password View Signals

extension LoginController {
  
  private func tapSendEmailToChangePassword(email: String) {
    print("Запускаем процесс восстановления пароля")
    
    
    ResetPasswordService.resetPassword(email: email) { (result) in
      
      switch result {
        
      case .success(_):
        print("Success")
        
        self.showSuccesMessage(text: "Проверьте почту")

      case .failure(let error):
        self.showErrorMessage(text: "Email не найден")
        print(error.localizedDescription)
      }
    }
  }
  
  private func validInputEmailToResetPassword(email: String) {
    
    let isEmailValid = email.isValidEmailRFC5322()
    loginView.forrgotPasswordView.validateInputEmailToResetPasswordTextField(isCanSave: isEmailValid)
    
  }
  
  
  private func tapResetPasswordButton() {
    
    
    AddNewElementViewAnimated.showOrDismissUnderBottomInCenterNewView(
      newElementView: loginView.forrgotPasswordView,
      blurView: loginView.blurView,
      customNavBar: nil,
      tabbarController: nil,
      isShow: true)
    // Теперь нужно дать текстфилд с вводом email
    
  }
  
  private func handleCancelForgotPasswordButton() {
    AddNewElementViewAnimated.showOrDismissUnderBottomInCenterNewView(
         newElementView: loginView.forrgotPasswordView,
         blurView: loginView.blurView,
         customNavBar: nil,
         tabbarController: nil,
         isShow: false)
  }
}


// MARK: TapGestureTecogniser
extension LoginController {
  
  
  private func setTapGestureRecogniser() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapView))
    loginView.addGestureRecognizer(tapGesture)
  }
  
  @objc private func handleTapView() {
    view.endEditing(true)
  }
}

// MARK: Keyboard Notififcation
extension LoginController {
  
  
  private func setKeyboardNotification() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillUP), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func handleKeyBoardWillUP(notification: Notification) {
    
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyboardFrame = value.cgRectValue
    
    let padding: CGFloat = 10
    let gapBottomFromStackViewAndBottom = loginView.frame.height - loginView.overAllStackView.frame.height - loginView.overAllStackView.frame.origin.y - padding
    
    let diff = keyboardFrame.height - gapBottomFromStackViewAndBottom
    
    if  diff > 0 {

      Animator.springTranslated(view: loginView, cgaTransform: CGAffineTransform(translationX: 0, y: -diff))
    }
    
    
  }
  
  @objc private func handleKeyBoardWillHide(notification: Notification) {
    Animator.springTranslated(view: loginView, cgaTransform:.identity)
  }
}
