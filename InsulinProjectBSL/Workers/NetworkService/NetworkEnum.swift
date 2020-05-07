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
  case addProductToFireBaseError
  
  // Update
  
  case updateInsulinSupplyDataErroe
  
  // Fetch
  
  case fetchAllDataFromFireStoreError

  
}

enum FirebaseKeyPath {
  
  struct Users {
    
    static let collectionName = "Users"
    
    struct UserDefaults {
      static let collectionName   = "UserDefaults"
      static let userDefaultsData = "userDefaultsData"
      
    }
    
    struct RealmData {
      static let collectionName  = "RealmData"
      
      struct Products {
        static let collectionName = "Products"
      }
    
      
    }
  }
}

//enum FirebaseKeyPath {
//  
//
//  enum Users  {
//    
//    var collectionName: String {"Users"}
//    
//    enum UserDefaults: String {
//      
//      var collectionName: String {"UserDefaults"}
//      case userDefaultsData
//    }
//
//    enum RealmData: String {
//      
//      var collectionName :String {"RealmData"}
//      
//      case products
//    }
//    
//  }
//  
//  
//}
