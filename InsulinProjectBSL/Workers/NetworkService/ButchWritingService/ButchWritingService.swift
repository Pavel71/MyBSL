//
//  ButchWritingService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 29.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Firebase


// Класс Отвечает за крупные изменения базы данных после обновления или добавления или удаления
final class ButchWritingService {
  
  
}

// MARK: Add Simple Sugar Data

extension ButchWritingService {
  
  func writtingSugarToFIreStoreAndSugarIdToDay(sugarNetwrokModel: SugarNetworkModel,updateDayID: String) {
    
    // 1. Добавляем в day Id
    // 2. Добавляем в sugar
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    let db    = Firestore.firestore()
    let batch = db.batch()
    
    
    // Set Sugsar Realm
    let sugarRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Sugars.collectionName).document(sugarNetwrokModel.id)
    
    batch.setData(sugarNetwrokModel.dictionary, forDocument: sugarRef)
    
    let dayUpdate:[String: Any] = [
        "listSugarID"   : FieldValue.arrayUnion([sugarNetwrokModel.id])
      ]
    
     let dayRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(updateDayID)
    
    batch.updateData(dayUpdate, forDocument: dayRef)
    
    batch.commit() { err in
      if let err = err {
        print("Error writing batch \(err)")
      } else {
        print("Batch write succeeded.")
      }
    }
  }
  
}

// MARK: After Add New CompObj

extension ButchWritingService {
  
  func writtingDataAfterAddNewCompObj(
    sugarNetwrokModel       : SugarNetworkModel,
    compObjNetwrokModel     : CompObjNetworkModel,
    prevCompObjNetwrokModel : CompObjNetworkModel,
    userDefaultsData        : [String:Any],
    updateDayID             : String) {
    
    // 1. Добавим Sugar Realm Добавим COmpObj
    
    // Get new write batch
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    let db    = Firestore.firestore()
    let batch = db.batch()
    
    
    // Set CompObj
    let compObjRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.CompObjs.collectionName).document(compObjNetwrokModel.id)
    
    
    batch.setData(compObjNetwrokModel.dictionary, forDocument: compObjRef)
    
    // Set Sugsar Realm
    let sugarRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Sugars.collectionName).document(sugarNetwrokModel.id)
    
    batch.setData(sugarNetwrokModel.dictionary, forDocument: sugarRef)
    
    // Update Data
    
    let dayRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(updateDayID)
    
    let dayUpdate:[String: Any] = [
      "listSugarID"   : FieldValue.arrayUnion([sugarNetwrokModel.id]),
      "listCompObjID" : FieldValue.arrayUnion([compObjNetwrokModel.id])
    ]
    
    batch.updateData(dayUpdate, forDocument: dayRef)
    
    // UpdateprevCompobj
    let updatePrevCompObjRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.CompObjs.collectionName).document(prevCompObjNetwrokModel.id)
    
    batch.updateData(prevCompObjNetwrokModel.dictionary, forDocument: updatePrevCompObjRef)
    
    // UpdateUSerdefaults Data
    let userDefaultsRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).document(currentUserID)
    
    
    batch.updateData(userDefaultsData, forDocument: userDefaultsRef)
    
    
    
    
    //    // Update the population of 'SF'
    //    let sfRef = db.collection("cities").document("SF")
    //    batch.updateData(["population": 1000000 ], forDocument: sfRef)
    //
    //    // Delete the city 'LA'
    //    let laRef = db.collection("cities").document("LA")
    //    batch.deleteDocument(laRef)
    
    // Commit the batch
    batch.commit() { err in
      if let err = err {
        print("Error writing batch \(err)")
      } else {
        print("Batch write succeeded.")
      }
    }
    
  }
}

// MARK: After UpdateCompObj

extension ButchWritingService {
  
  func writtingDataAfterUpdatindCompObj(
    sugarNetwrokModel   : SugarNetworkModel,
    compObjNetwrokModel : CompObjNetworkModel,
    userDefaultsData    : [String:Any]) {
    
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    let db    = Firestore.firestore()
    let batch = db.batch()
    
    
    // Set CompObj
    let compObjRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.CompObjs.collectionName).document(compObjNetwrokModel.id)
    
    batch.updateData(compObjNetwrokModel.dictionary, forDocument: compObjRef)
    
    
    
    // Set Sugsar Realm
    let sugarRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Sugars.collectionName).document(sugarNetwrokModel.id)
    
    batch.updateData(sugarNetwrokModel.dictionary, forDocument: sugarRef)
    
    let userDefaultsRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).document(currentUserID)
     
     
     batch.updateData(userDefaultsData, forDocument: userDefaultsRef)
    
    batch.commit() { err in
      if let err = err {
        print("Error writing batch \(err)")
      } else {
        print("Batch write updating succeeded.")
      }
    }
  }
  
}

// MARK: After Deleteing CompObj

extension ButchWritingService {
  
  func writtingDataAfterDeletingCompObj(
    compObjId           : String,
    sugarId             : String,
    dayNetwrokModel     : DayNetworkModel,
    userDefaltsData     : [String:Any],
    prevCompObjUpdate   : CompObjNetworkModel? = nil){
    
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    let db    = Firestore.firestore()
    let batch = db.batch()
    
    
    // Delte CompObj From CompObj
    let compObjRefColl = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.CompObjs.collectionName)
    
    
    batch.deleteDocument(compObjRefColl.document(compObjId))
    
    // Delete Sugars Form Sugars
    let sugarRef = db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Sugars.collectionName).document(sugarId)
    
    batch.deleteDocument(sugarRef)
    
    // Update List Day
    
    let dayRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.RealmData.Days.collectionName).document(dayNetwrokModel.id)
    
    batch.updateData(dayNetwrokModel.dictionary, forDocument: dayRef)
    
    
    // Update UserDefaults
    
    let userDefaultsRef =  db.collection(FirebaseKeyPath.Users.collectionName).document(currentUserID).collection(FirebaseKeyPath.Users.UserDefaults.collectionName).document(currentUserID)
    
    
    
   
    batch.updateData(userDefaltsData, forDocument: userDefaultsRef)
    
     // Update Prev CompObj
    if let prevCompobjNetwork = prevCompObjUpdate {
      batch.updateData(prevCompobjNetwork.dictionary, forDocument: compObjRefColl.document(prevCompobjNetwork.id))
    }
    
    
    batch.commit() { err in
        if let err = err {
          print("Error writing batch \(err)")
        } else {
          print("Batch write updating succeeded.")
        }
      }
    
  }
  
}
