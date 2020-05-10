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

// MARK: Add Meal To FireStore

extension AddService {
  
  func addProductInMeal(mealId: String, product:ProductNetworkModel) {
    
    DispatchQueue.global(qos: .userInteractive).async {
      
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
      // Я выяснил из за чего у меня дропается добавление в массив- но как мне кажется через коллекцию даже проще!
      
      print("Set Product to MEal",product)
      
      // Вообщем надо добавлять коллекцию
      
//      let data = [MealNetworkModel.CodingKeys.listProduct.rawValue : FieldValue.arrayUnion([product.dictionary])]
        
//      let data = [
//        MealNetworkModel.CodingKeys.listProduct.rawValue : [
//          product.id: FieldValue.arrayUnion([product.dictionary])]
//      ]
      
//      let data = [
//        "ID" : product.id
//      ]
//
      let data = product.dictionary
      
      
      
      
//      {favorites: {size: "large"}},
//      {merge: true}
      
      
//      washingtonRef.updateData([
//          "regions": FieldValue.arrayUnion(["greater_virginia"])
//      ])
      
//      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(mealId).updateData(data)
      
      // Надо подумать как объеденить 2 запроса в 1 чтобы не перепушивать сервер!

      Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).document(mealId).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(product.id).setData(data)
      
      
     
      }
    }
  
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
