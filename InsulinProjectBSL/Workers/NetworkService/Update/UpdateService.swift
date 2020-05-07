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

  
  
  func updateInsulinSupplyDataInFireBase(supplyInsulin: Int)  {
    
    DispatchQueue.global(qos: .default).async {
      
      let updateData = [UserDefaultsKey.insulinSupplyValue.rawValue : supplyInsulin]
      
      self.updateFireStore(updateData: updateData)
      
  
    }
  
  
  }
  
  // MARK: Update ML Weights
  
  func updateMLWeights(weights: [Float],key: UserDefaultsKey) {
    
    DispatchQueue.global(qos: .default).async {
      
      let updateData = [key.rawValue: weights]
      
      self.updateFireStore(updateData: updateData)
      
    }
    
  }
  
  private func updateFireStore(updateData:[String: Any]) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    

    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).document(currentUserID).updateData(updateData) { (error) in
      
        if error != nil {
          print("Ошибка обновления Данных")

        }
        

      }
  }
  

  
}
