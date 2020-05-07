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
      
      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        // мне по большому счету не нужно получать никаких сообщений отправили данные на сохранение и ладно!
      
      Firestore.firestore().collection(FirebaseKeyPath.users.rawValue).document(currentUserID).collection(FirebaseKeyPath.Users.userDefaultsData.rawValue).document(currentUserID).updateData(updateData) { (error) in
        
          if error != nil {
            print("Ошибка обновления insulinSupply")

          }
          

        }
    }
  
  
    
  
  }
  

  
}
