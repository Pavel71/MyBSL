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

  lazy var usersQuery = FirebaseKeyPath.Users.RealmData.self
  
  lazy var queryStr:[String] = [
    
    usersQuery.CompObjs.collectionName,
    usersQuery.Days.collectionName,
    usersQuery.Meals.collectionName,
    usersQuery.Sugars.collectionName,
    usersQuery.Products.collectionName
    
  ]

  
}


// MARK: Check Day in DB
extension FetchService {
  
  func checkDayByDateInFireStore (complation: @escaping (Result<DayNetworkModel?,NetworkFirebaseError>) -> Void) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    guard let date = Date().onlyDate()?.timeIntervalSince1970 else {return}
    
    let query = Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).whereField("date", isEqualTo: date)
    
    query.getDocuments { (querySnapshot, err) in
      if let error = err {
        print("error")
        complation(.failure(.checkDayByDateInFireStoreError))
      }
      
      if querySnapshot?.documents.isEmpty == false {
        // день есть в базе данных нужно вернуть этот день
        guard let dayQuery = querySnapshot?.documents.first else {return}
        
        let dayNetwrokModel = self.convertFireStoreToNetwrokModel(data: dayQuery.data(), type: DayNetworkModel.self) 
        
        complation(.success(dayNetwrokModel))
      } else { // Дня нет в базе данных возвращаем просто false
        complation(.success(nil))
      }
      
      
    }
    
    
  }
  
}



// MARK: Fetch All Data From FireStore

extension FetchService {
  
  
  func getRealmDataFromFireStore(complation: @escaping (Result<FireStoreNetwrokModels,NetworkFirebaseError>) -> Void) {

    print("Пошла загрузка данных из FireBase Realm Data")
    
    let group = DispatchGroup()

    var dictRealmData : [String:[[String: Any]] ] = [:]
    
    // 1. Загружаем данные для realma

    queryStr.forEach { (query) in
      group.enter()
      fetchRealmDataFromFireStore(collectionName: query) { (result) in
        
        switch result {
          
        case .success(let documents):
          
          let documents = documents.compactMap{$0.data()}
          dictRealmData[query] = documents
          
          group.leave()
          
        case .failure(let error):
          complation(.failure(error))
          
        }
      }
    }
    
    // 2. Загружаем данные userDefaults
    group.enter()

    fetchUserDefaultsDataFromFireStore { (result) in
      switch result {
      case .success(let userDefaultsModel):
        let data = userDefaultsModel.dictionary
//        dictRealmData["UserDefaults"] = data
        group.leave()
      case .failure(let error):
        complation(.failure(error))
        
      }
    }
    
    
    
    group.notify(queue: DispatchQueue.main) {

      print("Начинаю конвертировать данные в Network Models")
      
      // Тут нам нужно пройтись по всем полям со временем и конвертировать их в Date
//      var days = dictRealmData[self.usersQuery.Days.collectionName]!
//
//
//      days = days.map{
//        var dict = $0
//        let date = dict["date"] as! Timestamp
//        dict["date"] = date.dateValue()
//        return dict
//      }
//
//      dictRealmData[self.usersQuery.Days.collectionName] = days
      self.convertFireStoreModel(data: dictRealmData) { result in
        
        switch result {
          
        case .success(let models):complation(.success(models))
        case .failure(let error):complation(.failure(error))
          
        }
        
      }
      

    }


  }
  
  

  
  
  // MARK: Fetch RealmData FromFireStore
  
  private func fetchRealmDataFromFireStore(
    collectionName: String,
    complation: @escaping (Result<[QueryDocumentSnapshot],NetworkFirebaseError>) -> Void) {

    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
           
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(collectionName).getDocuments { (snapShot, error) in
      
      if error != nil { complation(.failure(.fetchRealmDataFromFireStoreErorr)) }
      
      if let snapShot = snapShot { complation(.success(snapShot.documents)) }
      
    }
    
  }
  

  
  
  
}

// MARK: Fetch User Defaults Data From FireStore

extension FetchService {
  
  
  func fetchUserDefaultsDataFromFireStore(complation: @escaping (Result<UserDefaultsNetworkModel,NetworkFirebaseError>) -> Void) {
    
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).getDocuments { (snpashot, error) in
      
      if error != nil {
        complation(.failure(.fetchUserDefaultDataFromFireStoreError))
      }
      
      snpashot?.documents.forEach({ (doc) in
        let userData = doc.data()
       guard
        let userDefaultsModel = self.convertFireStoreToNetwrokModel(data: userData, type: UserDefaultsNetworkModel.self)
        else {return complation(.failure(.castNetworkModelError)) }
        
        complation(.success(userDefaultsModel))
      
      })
      
      
    }
    
    
  }
  
}
// MARK: Convert Document to NetworkModel
   
extension FetchService {
  
  
  private func convertFireStoreModel(
    data:[ String:[[String: Any]] ],
    complation: @escaping (Result<FireStoreNetwrokModels,NetworkFirebaseError>) -> Void) {
        
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
      // Нужно декодировать!
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      
      
      let model = try decoder.decode(FireStoreNetwrokModels.self, from: jsonData)
      
      complation(.success(model))
    } catch (_) {
      complation(.failure(.castNetworkModelError))
    }
  }
  
  // MARK: Convert Firestore Dict to Netwrok Model
  
  private func convertFireStoreToNetwrokModel <T: NetworkModelable>(
    data:[String: Any],
    type: T.Type
    ) -> T? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        // Нужно декодировать!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        
        let model = try decoder.decode(type.self, from: jsonData)
        
        return model
      } catch (_) {
        return nil
      }
  }
 

  
}
