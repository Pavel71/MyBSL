//
//  RegistrationViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

class RegistrationViewModel {
  
  var bindableImage       = Bindable<UIImage>()
  var bindableISFormValid = Bindable<Bool>()
  
  var fullName: String? { didSet{checkFormValidity()} }
  var email: String?    { didSet{checkFormValidity()} }
  var password: String? { didSet{checkFormValidity()} }
  
  
  
  
  func checkFormValidity() {
    
    guard let email = self.email else {return}
    let isEmailValid = email.isValidEmailRFC5322()
    
    let isFormValid = isEmailValid && password?.isEmpty == false
    
    bindableISFormValid.value = isFormValid
  }
  
  
  
  
  func performRegistration(complation: @escaping ((Result<Bool,Error>) -> Void)) {
    
    guard let email = email else {return}
    guard let password = password else {return}
    
    print("Пошла регистрация Юзера с данными",email,password)
    
    RegisterService.createUser(email: email, password: password) { result in

      switch result {

      case .failure(let error):
        complation(.failure(error))

      case .success(let res):
        print("Succesful:", res.user.uid)
        complation(.success(true))
        
      }

    }
    
  }
  
//  private func loadDataInStorage(complation: @escaping ((Result<Bool,Error>) -> Void)) {
//
//    guard let image = bindableImage.value else {return}
    
//    SaveService.saveImageInStorage(image: image) { (result) in
//      switch result {
//      case .failure(let error):
//        complation(.failure(error))
//      case .success(let url):
//
//        let urlString = url.absoluteString
//        self.saveDataInFireStore(imageUrlString: urlString, complation: complation)
//      }
//    }
//  }
  
  private func saveDataInFireStore(imageUrlString: String, complation: @escaping ((Result<Bool,Error>) -> Void)) {
    
    guard let fullName = fullName else {return}
    
//    SaveService.saveRegisterDataInFireStore(imageUrlString: imageUrlString, fullName: fullName) { (result) in
//
//      switch result {
//      case .failure(let error):
//        complation(.failure(error))
//      case .success(let succses):
//        complation(.success(succses))
//      }
//    }
  }
  
  
  
}
