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
  var userDefaults: UserDefaultsWorker!
  
  init() {
    let locator = ServiceLocator.shared
    fetchService = locator.getService()
    userDefaults = locator.getService()
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
  
  // MARK: Fetch Data From FireStore
  func fetchDataFromFirebase(complation: @escaping ((Result<Bool,NetworkFirebaseError>) -> Void)) {
    
    
    fetchService.getRealmDataFromFireStore { (result) in
      switch result {
      case .success(let models):
        print("Catch Models",models)
        
        // 1. Сохранить UserDefaults
        self.userDefaults.setDataToUserDefaults(userDefaultsNetwrokModel: models.userDefaults[0])
        
        let realmMagaer:RealmManager! = ServiceLocator.shared.getService()
        
        // 2. Удалим пустой день который создался при запуске приложения
        realmMagaer.deleteEmptyDayFromRealm()

        // 3. запустить процесс сохранения в реалме!
        
        print("Сохраняю данные в Реалм из FireStore")
        // К этому моменту у меня будет 1 день с сегодняшней датой в базе данных!
        // Нужно сегодняшний день взять из FireStore - а из реалма удалить его нахер!
        
        realmMagaer.setNetwrokdDataToRealm(fireStoreModel: models)
        // Даже не знаю если четсно как это бомбить!
        
        complation(.success(true))
        
      case .failure(let error):
        complation(.failure(error))
      }
    }
    
    
  }

  
  
}
