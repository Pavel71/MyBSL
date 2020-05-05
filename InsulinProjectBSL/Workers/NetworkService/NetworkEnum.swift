//
//  NetworkEnum.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


enum NetworkFirebaseError: Error {
  
  case createUserError
  case signInError

  case saveDocumentError
  case saveUserDefaultsDataError
  
  case fetchAllDataFromFireStoreError

  case resetPasswordError
}

enum FirebaseKeyPath: String {
  
  case users = "Users"
  
  enum Users: String {
    
    case userDefaultsData
    case realmData
    
  }
  
  
}
