//
//  NetworkEnum.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


enum NetworkFirebaseError: Error {
  
  
  // Register Login
  case createUserError
  case signInError
  case signOutError
  case resetPasswordError
  
  // Add
  
  case saveUserDefaultsDataError
  
  // Update
  
  case updateInsulinSupplyDataErroe
  
  // Fetch
  
  case fetchAllDataFromFireStoreError

  
}

enum FirebaseKeyPath: String {
  
  case users = "Users"
  
  enum Users: String {
    
    case userDefaultsData
    case realmData
    
  }
  
  
}
