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
  
  enum RedactingDB: Int {
    case canRedacting,notRedacting
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
  
  
  // func add Day without day listner!
  // Зачем нам листнер дня! Когда он не нужен! мы можем просто проверить по транзакции день! Если он есть то возми его себе и обнвои текущий день! если нет то добавь новый!
  // И не нужен никакой литснер!
  // Просто нужно будет протестировать эту работу без инета! когда появуится интернет! Транзакция повторится или нет?
  
  func addDayToFRBWithTransaction(
    dayNetworkModel: DayNetworkModel,
    complation: @escaping (Result<DayNetworkModel?,NetworkFirebaseError>) -> Void) {
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
          let db    = Firestore.firestore()

          let data = dayNetworkModel.dictionary

       let lastDayDateRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID)
    
        
    
       let dayRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(dayNetworkModel.id)
    
     db.runTransaction({ (transaction, error) -> Any? in
          print("Запись дня в FireStore")
          let lastDayDateDocument: DocumentSnapshot
          do {
              try lastDayDateDocument = transaction.getDocument(lastDayDateRef)
          } catch let fetchError as NSError {
              error?.pointee = fetchError
              return nil
          }
          
          if let cameData = lastDayDateDocument.data()?["lastDayDate"] as? TimeInterval {

                if cameData < dayNetworkModel.date {
                  print("Дня еще нет в FireStore - добавляем!")
                  transaction.setData(data, forDocument: dayRef)
                  transaction.updateData(["lastDayDate":dayNetworkModel.date], forDocument: lastDayDateRef)
                  
                } else {
                  print("День есть в FireStore Transaction, ничего не добавляем!ждем когда сам придет!")
                  let lastDayRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).whereField("date", isEqualTo: cameData)
                  // нужно взять этот день и вкинуть его в реалм! причем с удалением текущего дня!
                  lastDayRef.getDocuments { (querry, error) in
                    guard let querry = querry else {
//                      complation(.failure(.addDayTpFireStore))
                      return
                    }
                    
                    
                    
                    guard let daydata = querry.documents.first?.data() else {return}
                    
                    let dayNetwork =  self.convertFireStoreToNetwrokModel(data:daydata, type: DayNetworkModel.self)
                    
                    // теперь нужно перекинуть эту модельку в интерактор
                    complation(.success(dayNetwork))
                  }
                  
                }
            
            

          } else {
            // Значит поля c проверочным днем нет нужно его создать
            print("Создаем поле с датой и сетим день")
            transaction.setData(["lastDayDate":dayNetworkModel.date], forDocument: lastDayDateRef)
            transaction.setData(data, forDocument: dayRef)
          }
          
        

          return nil
        }) { (obj, error) in

          if let error = error {
                 // транзакция пришла с ошибкой
            print("Transaction Error",error)
         }
    }
  }

//  func addDayToFireStoreTransaction(
//    dayNetworkModel: DayNetworkModel,
//    complation: @escaping (Result<Bool,NetworkFirebaseError>) -> Void) {
//
//    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
//       let db    = Firestore.firestore()
//
//       let data = dayNetworkModel.dictionary
//
//    let lastDayDateRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID)
//    let dayRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(dayNetworkModel.id)
//
//
//    var isNeddSetDataToRealm = false
//
//    db.runTransaction({ (transaction, error) -> Any? in
//
//
//      let lastDayDateDocument: DocumentSnapshot
//      do {
//          try lastDayDateDocument = transaction.getDocument(lastDayDateRef)
//      } catch let fetchError as NSError {
//          error?.pointee = fetchError
//          return nil
//      }
//
////     guard
////      let cameData = lastDayDateDocument.data()?["lastDayDate"] as? TimeInterval
////      else {return nil}
//
//      if let cameData = lastDayDateDocument.data()?["lastDayDate"] as? TimeInterval {
//        // Если дата совпадает с сегодняшним днем то нужно взять день по последней дате, Если нет то добавить
//            print(cameData,"Came Data")
//
//            if cameData < dayNetworkModel.date {
//              print("Дня еще нет в FireStore - добавляем!")
//              transaction.setData(data, forDocument: dayRef)
//              transaction.updateData(["lastDayDate":dayNetworkModel.date], forDocument: lastDayDateRef)
//
//              isNeddSetDataToRealm = true
//
//            }
//        print("День есть в FireStore Transaction, ничего не добавляем!ждем когда сам придет!")
//
//
//      } else { // Значит поля c проверочным днем нет нужно его создать
//        print("Создаем поле с датой и сетим день")
//        transaction.setData(["lastDayDate":dayNetworkModel.date], forDocument: lastDayDateRef)
//        transaction.setData(data, forDocument: dayRef)
//      }
//
//
//
//      return nil
//    }) { (obj, error) in
//
//      if let error = error {
//             // транзакция пришла с ошибкой
//        complation(.success(true)) // Всерано разрешаем установить день в реалм
//             print("Transaction failed: \(error)")
//         } else {
//        // NТранзактион прошел можно добавлять данные в реалм
//        complation(.success(isNeddSetDataToRealm))
//             print("Transaction successfully committed!")
//         }
//    }
//
//  }
  
  
  
  
  
  
  
  
  // complation: @escaping (Result<Bool,NetworkFirebaseError>) -> Void
//  func addDayToFireStore(
//    dayNetworkModel: DayNetworkModel,
//    complation: @escaping (Result<DayNetworkModel?,NetworkFirebaseError>) -> Void) {
//
//    // Прежде чем записать день нужно проверить нет ли такового в базе!
//
//    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
//    let db    = Firestore.firestore()
//
//    let data = dayNetworkModel.dictionary
//
//
//    let newDayRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(dayNetworkModel.id)
//
//
//    let targetDate = Date().onlyDate()!.timeIntervalSince1970
//    let dayCollectionRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).whereField("date", isEqualTo: targetDate)
//
//
//
////     Поисчем день с текущей датой!
//    dayCollectionRef.getDocuments { (querry, error) in
//      guard let querry = querry else {
//        complation(.failure(.addDayTpFireStore))
//        return
//      }
//
//      var dayNetwork: DayNetworkModel?
//
//      if querry.documents.count == 0 { // Значит сегодняшнего дня в базе нет! Можем записывать смело
//        print("FireStore Пустая записываю День")
//        newDayRef.setData(data)
//        complation(.success(nil))
//      } else {
//        // Уже такой день есть в базе Нужно его достать и установить в реалм! а текущий удалить нафиг
//        dayNetwork =  self.convertFireStoreToNetwrokModel(data: querry.documents.first!.data(), type: DayNetworkModel.self)
//        complation(.success(dayNetwork))
//
//      }
//
//
//    }
//
//
//
//
//  }
  
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
