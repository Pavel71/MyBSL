//
//  LoginViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import Firebase

class LoginModelView {
  
  var email: String? { didSet {checkForm()} }
  var password: String? {didSet {checkForm()} }
  
  var isValidForm = Bindable<Bool>()
  var isLogIn = Bindable<Bool>()
  
  var fetchService: FetchService!
  
  init() {
    let locator = ServiceLocator.shared
    fetchService = locator.getService()
  }
  
  func checkForm() {
    guard let email = self.email else {return}
    let isValidemail = email.isValidEmailRFC5322()
    isValidForm.value = isValidemail && password?.isEmpty == false
  }
  
  func performSignIn(complation: @escaping (Result<AuthDataResult, NetworkFirebaseError>) -> Void) {
    
    isLogIn.value = true
    
    guard let email = self.email else {return}
    guard let password = self.password else {return}

    LoginService.sigIn(email: email, password: password, complation: complation)
  }
  
  func fetchDataFromFirebase(complation: @escaping ((Result<Bool,NetworkFirebaseError>) -> Void)) {
    
    fetchService.fetchAllDataFromFireBase { (result) in
      switch result {
        
      case .success(let userDefData):
        
        // Получили данные теперь сохраним
        let locator = ServiceLocator.shared
        let userDefaults: UserDefaultsWorker! = locator.getService()
        
        userDefaults.setDataToUserDefaults(data: userDefData)
        complation(.success(true))
        
      case .failure(let error):
        complation(.failure(error))
        
      }
    }
    
  }

  
  
}
