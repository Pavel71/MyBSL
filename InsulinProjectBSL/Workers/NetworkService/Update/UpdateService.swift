//
//  UpdateService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import Firebase

// Класс Отвечает за изменение или обнволение данных в FireBase

final class UpdateService {
  
  // MARK: Update Insulin Supply

  
  
  
  

  
}



// MARK: Update Meals

extension UpdateService {
  
  func updateProductInMealInFireStore(productId: String,mealId: String,portion:Int) {
    DispatchQueue.global(qos: .default).async {
      
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      
      let data = [ProductNetworkModel.CodingKeys.portion.rawValue : portion]
      
         
      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(mealId).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(productId).updateData(data)
       }
  }
  
  func updateMealInFireStore(mealId: String,data:[String: Any]) {
    
    DispatchQueue.global(qos: .default).async {
      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      

      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(mealId).updateData(data)
    }
    
  }
  
}

// MARK: Update Products

extension UpdateService {
  
  func updateProductRealm(productId: String,data:[String: Any]) {
    
    DispatchQueue.global(qos: .default).async {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
      
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(productId).updateData(data)
    }
  }
  
}


// MARK: Update UserDefaults
extension UpdateService {
  
  func updateInsulinSupplyDataInFireBase(supplyInsulin: Int)  {
    
    DispatchQueue.global(qos: .default).async {
      
      let updateData = [UserDefaultsKey.insulinSupplyValue.rawValue : supplyInsulin]
      
      self.updateUserDefaultsDataFireStore(updateData: updateData)
      
  
    }
  
  
  }
  
  // MARK: Update ML Weights
  
  func updateMLWeights(weights: [Float],key: UserDefaultsKey) {
    
    DispatchQueue.global(qos: .default).async {
      
      let updateData = [key.rawValue: weights]
      
      self.updateUserDefaultsDataFireStore(updateData: updateData)
      
    }
    
  }
  
  private func updateUserDefaultsDataFireStore(updateData:[String: Any]) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).document(currentUserID).updateData(updateData) { (error) in
      
        if error != nil {
          print("Ошибка обновления Данных")

        }
        

      }
  }
  
}
