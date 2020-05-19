//
//  DeleteService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import Firebase


// Класс отвечате за удаление данных из FireBase


final class DeleteService {
  
}


// MARK: Delete Sugars

extension DeleteService {
  
  func deleteSugarFromFireStore(sugarId: String) {
    DispatchQueue.global(qos: .default).async {
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      
      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Sugars.collectionName).document(sugarId).delete()
    }
  }
  
}

//MARK: Delete Meals
extension DeleteService {
  
  func deleteProductFromMealFireStore(mealId: String,productId: String) {
    DispatchQueue.global(qos: .default).async {
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      
      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(mealId).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(productId).delete()
    }
  }
  
  func deleteMealFromFireStore(mealId: String) {
    DispatchQueue.global(qos: .default).async {
      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      

      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(mealId).delete()
      
      
    }
  }
  
}

// MARK: Delete Products

extension DeleteService {
  
  func deleteProducts(productId: String) {
    
    DispatchQueue.global().async {
      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      
      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(productId).delete()
    }
    
    
  }
  
}
