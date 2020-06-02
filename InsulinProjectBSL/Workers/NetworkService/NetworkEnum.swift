//
//  NetworkEnum.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation



enum CastFireStoreDataToNetwrokModelError: Error {
  
  
  case castNetworkModelError
  
  case castCompobjModelError
  case castDayModelError
  case castSugarModelError
  case castProductModelError
  case castMealModelError
}

// MARK: Network Errors

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
  
  
  case fetchUserDefaultDataFromFireStoreError
  
  case fetchRealmDataFromFireStoreErorr
  
  // Casting
  case castNetworkModelError
  
  // Checks
  case checkDayByDateInFireStoreError

  
}

// MARK: FireBase keys

enum FirebaseKeyPath {
  
  struct Users {
    
    static let collectionName = "Users"
    
    struct UserDefaults {
      static let collectionName   = "UserDefaults"
      static let userDefaultsData = "userDefaultsData"
      
    }
    
    struct RealmData {
      
       static let collectionName  = "RealmData"
      
      struct Days {
        static let collectionName = "Days"
      }
      
      struct Products {
        static let collectionName = "Products"
      }
      
      struct Meals {
        static let collectionName = "Meals"

      }
      
      struct Sugars {
        static let collectionName = "Sugars"
      }
      
      struct CompObjs {
        static let collectionName = "CompObjs"

      }
    
      
    }
  }
}

