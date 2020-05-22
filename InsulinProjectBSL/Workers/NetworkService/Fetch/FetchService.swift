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
          
          dictRealmData[query] = documents.compactMap{$0.data()}
          
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
      case .success(let userdDefaultDict):
        dictRealmData["UserDefaults"] = [userdDefaultDict]
        group.leave()
      case .failure(let error):
        complation(.failure(error))
        
      }
    }
    
    
    
    group.notify(queue: DispatchQueue.main) {

      print("Начинаю конвертировать данные в Network Models")

      self.convertAllModels(data: dictRealmData) { result in
        
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
  
  
  func fetchUserDefaultsDataFromFireStore(complation: @escaping (Result<[String: Any],NetworkFirebaseError>) -> Void) {
    
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).getDocuments { (snpashot, error) in
      
      if error != nil {
        complation(.failure(.fetchUserDefaultDataFromFireStoreError))
      }
      
      snpashot?.documents.forEach({ (doc) in
        let userData = doc.data()
        complation(.success(userData))
      
      })
      
      
    }
    
    
  }
  
}
// MARK: Convert Document to NetworkModel
   
extension FetchService {
  
  
  private func convertAllModels(
    data:[ String:[[String: Any]] ],
    complation: @escaping (Result<FireStoreNetwrokModels,NetworkFirebaseError>) -> Void) {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
      // Нужно декодировать!
      let model = try JSONDecoder().decode(FireStoreNetwrokModels.self, from: jsonData)
      
      complation(.success(model))
    } catch (_) {
      complation(.failure(.castNetworkModelError))
    }
  }
 
//    private func convertFireStoreDataToNetworkModels<T: NetworkModelable>(
//      data      : [String: Any],
//      typeModel : T.Type,
//      complation: @escaping (Result<NetworkModelable,CastFireStoreDataToNetwrokModelError>) -> Void) {
//
//  //    let some = typesCastingDict[]
//
//      do {
//        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//        // Нужно декодировать!
//        let model = try JSONDecoder().decode(typeModel.self, from: jsonData)
//
//        complation(.success(model))
//      } catch (_) {
//        complation(.failure(.castNetworkModelError))
//      }
//
//    }
  
  // MARK: Cast FireStoreData to CompObjNetwork Model
  
//  private func convertCompObj(
//    documents:[QueryDocumentSnapshot],
//    complation: @escaping (Result<[CompObjNetworkModel],CastFireStoreDataToNetwrokModelError>) -> Void) {
//
//    var arr: [CompObjNetworkModel] = []
//
//    documents.forEach { (document) in
//
//      self.convertFireStoreDataToNetworkModels(
//        data: document.data(),
//        typeModel: CompObjNetworkModel.self) { (result) in
//
//          switch result {
//          case .success(let model):
//               arr.append(model as! CompObjNetworkModel)
//          case .failure(_):
//            complation(.failure(.castCompobjModelError))
//          }
//      }
//
//    }
//
//    complation(.success(arr))
//
//  }
  
  // MARK: Convert FireStore Days to Day Network Model
  
//  private func convertDay(
//    documents:[QueryDocumentSnapshot],
//    complation: @escaping (Result<[DayNetworkModel],CastFireStoreDataToNetwrokModelError>) -> Void) {
//
//    var arr: [DayNetworkModel] = []
//
//    documents.forEach { (document) in
//
//      self.convertFireStoreDataToNetworkModels(
//        data: document.data(),
//        typeModel: DayNetworkModel.self) { (result) in
//
//          switch result {
//          case .success(let model):
//               arr.append(model as! DayNetworkModel)
//          case .failure(_):
//            complation(.failure(.castDayModelError))
//          }
//      }
//
//    }
//
//    complation(.success(arr))
//
//  }
  
  
}
