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
  
  //  var convertor: ConvertorWorker!
  //
  //  init() {
  //    convertor = ServiceLocator.shared.getService()
  //  }
  
  
}


// MARK: Bit TransAction Add SugarRealm + Add CompObj + Update Day + update PrevCompObj
extension AddService {
  
  
  
}

// MARK: Add Day to FireStore
extension AddService {
  // complation: @escaping (Result<Bool,NetworkFirebaseError>) -> Void
  func addDayToFireStore(
    dayNetworkModel: DayNetworkModel,
    complation: @escaping (Result<DayNetworkModel?,NetworkFirebaseError>) -> Void) {
    
    // Прежде чем записать день нужно проверить нет ли такового в базе!
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    let db    = Firestore.firestore()
    
    let data = dayNetworkModel.dictionary
    
    
    let newDayRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(dayNetworkModel.id)
    
    let targetDate = Date().onlyDate()!.timeIntervalSince1970
    let dayCollectionRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).whereField("date", isEqualTo: targetDate)
    
    
    
    // Поисчем день с текущей датой!
    dayCollectionRef.getDocuments { (querry, error) in
      guard let querry = querry else {
        complation(.failure(.addDayTpFireStore))
        return
      }
      
      var dayNetwork: DayNetworkModel?
      
      if querry.documents.count == 0 { // Значит сегодняшнего дня в базе нет! Можем записывать смело
        print("FireStore Пустая записываю День")
        newDayRef.setData(data)
        complation(.success(nil))
      } else {
        // Уже такой день есть в базе Нужно его достать и установить в реалм! а текущий удалить нафиг
        dayNetwork =  self.convertFireStoreToNetwrokModel(data: querry.documents.first!.data(), type: DayNetworkModel.self)
        complation(.success(dayNetwork))
        print("День есть в FireStore значит возму его к себе")
      }
      
      
    }
    
 
    

  }
  
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
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    let data = product.dictionary
    
    Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).document(product.id).setData(data)
    
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
