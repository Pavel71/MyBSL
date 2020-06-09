//
//  ListnerService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03.06.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Firebase

// Класс отвекчает за установку и снятие listnerov

enum ObserverDataType {
  case local
  case server
}
enum ServerChangeType {
  case added
  case removed
  case modifided
}

final class ListnerService {
  
  var productListner : ListenerRegistration!
  var mealListner    : ListenerRegistration!
  var dayListner     : ListenerRegistration!
  
  var fetchService   : FetchService!
  
  var convertWorker : ConvertorWorker!
  init() {
    convertWorker = ServiceLocator.shared.getService()
    fetchService  = ServiceLocator.shared.getService()
  }
}

// MARK: Day
extension ListnerService {
  
  func setDayListner(complation: @escaping (Result<(DayNetworkModel,ServerChangeType),NetworkFirebaseError>) -> Void) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    dayListner = Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).addSnapshotListener({ (querry, error) in
      
      guard let snapshot = querry else {
        complation(.failure(.dayListnerGetDataError))
        return
      }
      
      // Когда мы получили querry - то нам также нужно запросить данные из userDefaults
      
     
      
      let source:ObserverDataType = snapshot.metadata.hasPendingWrites ? .local : .server
      print("Source Data Day",source)
      
      if source == .server {
        
        var dayModels:[DayNetworkModel] = []
        
        snapshot.documentChanges.forEach { diff in
          
          
          let dayModel = self.convertFireStoreToNetwrokModel(
            data: diff.document.data(),
            type: DayNetworkModel.self)
          
          var type : ServerChangeType
          
          switch diff.type {
          case .added    : type = .added
          case .modified : type = .modifided
          case .removed  : type = .removed
            
          }
          
          complation(.success((dayModel,type)))
          
        }
                
        
      }
      
      
    }) // Listner
    
  }
}

// MARK: Meal

extension ListnerService {
  func setMealListner(complation: @escaping (Result<(MealNetworkModel,ServerChangeType),NetworkFirebaseError>) -> Void) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    
    mealListner =  Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Meals.collectionName).addSnapshotListener { (querry, error) in
      
      guard let snapshot = querry else {
        complation(.failure(.mealListnerGetDataError))
        return
      }
      
      
      let source:ObserverDataType = snapshot.metadata.hasPendingWrites ? .local : .server
      print("Source Data Meal",source)
      
      if source == .server { // Изменения инициировал сервер
        print("Изменения пришил с сервера!")
        // задача простая внести изменения в реалм и обновить Экран!
        snapshot.documentChanges.forEach { diff in
          
          //           guard
          //             let mealModel = self.convertFireStoreToNetwrokModel(
          //             data: diff.document.data(),
          //             type: MealNetworkModel.self),
          //
          //           else {
          //             complation(.failure(.castNetworkModelError))
          //             return}
          
          let mealModel = self.convertFireStoreToNetwrokModel(
            data: diff.document.data(),
            type: MealNetworkModel.self)
          
          var type : ServerChangeType
          
          switch diff.type {
          case .added    : type = .added
          case .modified : type = .modifided
          case .removed  : type = .removed
            
          }
          
          complation(.success((mealModel,type)))
          
        }
      }
      
      
      
    }
  }
}

// MARK: Product
extension ListnerService {
  
  // Смысл в том что приходят мои же значения! Вот в чем прикол! А это не нужно абсолютно! Дублировать эти запросы какой смысл? Как этого не допустить?
  // Я записал - мне же пришли новые данные! Когда тот кто записывает не должен полуыать новые данные
  // Удаление не показывает как Local Change -
  
  func setProductLisner(complation: @escaping (Result<(ProductNetworkModel,ServerChangeType),NetworkFirebaseError>) -> Void) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    
    productListner =  Firestore.firestore().collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Products.collectionName).addSnapshotListener { (querry, error) in
      
      guard let snapshot = querry else {
        complation(.failure(.productListnerGetDataError))
        return
      }
      
      
      let source:ObserverDataType = snapshot.metadata.hasPendingWrites ? .local : .server
      print("Source Data Products",source)
      
      
      if source == .server { // Изменения инициировал сервер
        print("Изменения пришил с сервера!")
        // задача простая внести изменения в реалм и обновить Экран!
        snapshot.documentChanges.forEach { diff in
          
          //          guard
          //            let productModel = self.convertFireStoreToNetwrokModel(
          //            data: diff.document.data(),
          //            type: ProductNetworkModel.self)
          //          else {
          //            complation(.failure(.castNetworkModelError))
          //            return}
          
          let productModel = self.convertFireStoreToNetwrokModel(
            data: diff.document.data(),
            type: ProductNetworkModel.self)
          
          var type : ServerChangeType
          
          switch diff.type {
          case .added    : type = .added
          case .modified : type = .modifided
          case .removed  : type = .removed
            
          }
          
          complation(.success((productModel,type)))
          
        }
      }
      
      
      
    }
    
  }
  // MARK: FireStore to Network Model
  func convertFireStoreToNetwrokModel <T: NetworkModelable>(
    data:[String: Any],
    type: T.Type
  ) -> T {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
      // Нужно декодировать!
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      
      
      let model = try decoder.decode(type.self, from: jsonData)
      
      return model
    } catch (let error) {
      fatalError("Cast Convert Type Error \(type)")
    }
  }
  
  func dismissProductListner() {
    productListner.remove()
  }
}
