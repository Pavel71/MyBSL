//
//  LoginService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


import Foundation
import Firebase

class LoginService {
  
  
  static func sigIn(email: String, password: String,complation: @escaping (Result<AuthDataResult, NetworkFirebaseError>) -> Void) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
      if error != nil {
        complation(.failure(.signInError))
      }
      guard let result = authDataResult else {return}
      complation(.success(result))
    }
  }
  
  static func logOut() -> Bool {
    do {
      try Auth.auth().signOut()
      return true
    } catch{
      return false
    }
  }
  
}
