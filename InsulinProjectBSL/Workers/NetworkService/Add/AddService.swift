//
//  SaveService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import Firebase


// Класс отвечает за сохранение данных в FIrebase

final class AddService {

  var encoder: JSONEncoder {
    let encod = JSONEncoder()
    return encod
  }
  

    
}


// MARK: Bit TransAction Add SugarRealm + Add CompObj + Update Day + update PrevCompObj
extension AddService {
  
 
  
}
 
// MARK: Add Day to FireStore
extension AddService {
  
  func addDayToFireStore(dayNetworkModel: DayNetworkModel) {

          
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}

    let data = dayNetworkModel.dictionary

    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(dayNetworkModel.id).setData(data)
          
          
          
  }
  
}

// MARK: Add CompObj To FireStore

extension AddService {
  
//  func addCompObjToFireStore(compoObj: CompObjNetworkModel) {
//    
//    DispatchQueue.global(qos: .userInteractive).async {
//       
//        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
//         
//      
//      // C другой стороны это всеткаи усложняет запросы на редактирование и удаление каких то элементов!
//      
//       let data = compoObj.dictionary
//
//      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.CompObjs.collectionName).document(compoObj.id).setData(data)
//       
//       
//       }
//    
//    
//    
//  }
  
}

// MARK: Add Sugar Realm To FireStore

extension AddService {
  
  func addSugarNetworkModelinFireStore(sugarNetworkModel: SugarNetworkModel) {

      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
       

     let data = sugarNetworkModel.dictionary

      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Sugars.collectionName).document(sugarNetworkModel.id).setData(data)

  }
  
}

// MARK: Add Meal To FireStore

extension AddService {
  

  
  func addMealToFireStore(meal: MealNetworkModel) {
    
    DispatchQueue.global(qos: .default).async {
      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      
      let data = meal.dictionary

      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(meal.id).setData(data)
    }
  }
  
  
}
  
  
  


// MARK: Add Product To FireStore

extension AddService {
  
  func addProductToFireBase(product: ProductNetworkModel) {
    
    DispatchQueue.global(qos: .default).async {
      guard let currentUserID = Auth.auth().currentUser?.uid else {return}
      
      let data = product.dictionary

      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(product.id).setData(data)
    }
    
    
    
  }
  
}



// MARK: Save UserDefaultsData after Register!
extension AddService {
  
  
  func addUserDefaultsDataToFirebase(
    userDefaltsData: [String: Any],
    completion: @escaping ((Result<Bool,NetworkFirebaseError>)) -> Void) {
    

    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    
    
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).document(currentUserID).setData(userDefaltsData) { (error) in
      
      if error != nil {
        completion(.failure(.saveUserDefaultsDataError))
      }
      
      completion(.success(true))
      
    }
    
  }
  
  
  
  
}
