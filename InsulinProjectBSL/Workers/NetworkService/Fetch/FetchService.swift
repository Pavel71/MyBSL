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
  
  
  
  func fetchAllDataFromFireBase(complation: @escaping (Result<[String: Any],NetworkFirebaseError>) -> Void) {
    
    print("Пошла загрузка данных")
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).getDocuments { (snpashot, error) in
      
      if error != nil {
        complation(.failure(.fetchAllDataFromFireStoreError))
      }
      
      snpashot?.documents.forEach({ (doc) in
        let userData = doc.data()
        complation(.success(userData))
      
      })
      
      
    }
    
    
  }
  

  
}
