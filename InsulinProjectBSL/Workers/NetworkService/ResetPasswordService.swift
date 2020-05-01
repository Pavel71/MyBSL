//
//  ResetPasswordService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import Firebase


final class ResetPasswordService {
  
  static func resetPassword(email: String, completion: @escaping (Result <Bool, NetworkFirebaseError>) -> Void) {
    
    
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      if  error == nil {
        completion(.success(true))
      } else {
        
        completion(.failure(.resetPasswordError))
      }
      
      
    }
    
  }
  
}
