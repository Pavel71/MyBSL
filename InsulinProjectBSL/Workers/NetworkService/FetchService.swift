//
//  FetchService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import Firebase


// Класс отвечает за загрузку данных из FireBase

final class FetchService {
  
  
  static func fetchAllDataFromFireBase(complation: @escaping (Result<Bool,NetworkFirebaseError>) -> Void) {
    
    print("Пошла загрузка данных")
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    Firestore.firestore().collection(FirebaseKeyPath.users.rawValue).document(currentUserID).collection(FirebaseKeyPath.Users.userDefaultsData.rawValue).getDocuments { (snpashot, error) in
      
      if error != nil {
        complation(.failure(.fetchAllDataFromFireStoreError))
      }
      
      snpashot?.documents.forEach({ (doc) in
        let userData = doc.data()
        print(userData)
        saveDataToUserDefaults(data: userData)
      })
      
      // Теперь эти данные можно сохранить в UserDefaults или создать структуру UserSettings
      
      
      let userDefaults = UserDefaults.standard
      print("Test Save UserDefaults Data Insulin Supply 300",userDefaults.float(forKey: UserDefaultsKey.insulinSupplyValue.rawValue))
      
      complation(.success(true))
      
      
    }
    
    
  }
  
  static private func saveDataToUserDefaults(data: [String: Any]) {
    
    let userDefaults = UserDefaults.standard
    
    UserDefaultsKey.allCases.forEach { (key) in
    
      userDefaults.set(data[key.rawValue], forKey: key.rawValue)
      
    }
    
  }
  
}
