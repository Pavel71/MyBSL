//
//  RegisterService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import Firebase



class RegisterService {
  
  static func createUser(email: String, password: String, complation: @escaping ((Result<AuthDataResult, NetworkFirebaseError>) -> Void)) {
    
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
      
      if err != nil {
        complation(.failure(.createUserError))
      }
      if let res = result {
        complation(.success(res))
      }
      
    }
  }
  
}
