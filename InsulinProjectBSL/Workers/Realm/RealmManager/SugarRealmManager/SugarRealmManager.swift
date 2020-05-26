//
//  SugarRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import RealmSwift



class SugarRealmManager {
  
  
  
  let provider: RealmProvider
  
//  static var shared:SugarRealmManager = {SugarRealmManager()}()
  
  var realm : Realm {provider.realm}
  
  init(provider: RealmProvider = RealmProvider.sugarProvider) {
    self.provider = provider
    
  }
  
}


// MARK: Fetch Sugar From Realm
extension SugarRealmManager {
  
  func fetchAllSugar() -> Results<SugarRealm> {
    
    return realm.objects(SugarRealm.self)
    
  }
  
//  func fetchSugarById(sugarRealmId: String) -> SugarRealm? {
//
//    let sugarRealm = fetchAllSugar().first(where: {$0.id == sugarRealmId})
//    return sugarRealm
//  }
  
  func fetchSugarByPrimeryKey(sugarPrimaryKey: String)-> SugarRealm? {
    
    let sugar = realm.object(ofType: SugarRealm.self, forPrimaryKey: sugarPrimaryKey)
    return sugar
  }
  
  func fetchSugarByCompansationId(sugarCompObjId: String) -> SugarRealm? {
    
    let sugarRealm = fetchAllSugar().first(where: {$0.compansationObjectId == sugarCompObjId})
    return sugarRealm
  }
  
}



// MARK: Add or Update New SugarRealm

extension SugarRealmManager {
  
  func setSugarFromFireStore(sugars: [SugarRealm]) {
    do {
         self.realm.beginWrite()
         self.realm.add(sugars, update: .all)
         try self.realm.commitWrite()
         print(self.realm.configuration.fileURL?.absoluteURL as Any,"Sugar in DB")
         
       } catch {
         print(error.localizedDescription)
       }
  }
  
  func addOrUpdateNewSugarRealm(sugarRealm: SugarRealm) {
    
    do {
      self.realm.beginWrite()
      self.realm.add(sugarRealm, update: .modified)
      
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"Sugar in DB")
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}

// MARK: Delete Sugar From Realm
extension SugarRealmManager {
  
  // сейчас это удаление происходит когда мы удалеям объект!
  // Нужно пробежатся по всем ближайшим объектам до сахара с обедом и затереть их тоже!
  
  func deleteSugarId(sugarId: String) {
    
    guard let sugarRealm = fetchSugarByPrimeryKey(sugarPrimaryKey: sugarId) else {return}
    
    var arrayDelete:[SugarRealm] = findNearestSugarObjectWithOutCompObjId(sugarDeleteId: sugarRealm.id)
    arrayDelete.append(sugarRealm)
    
    arrayDelete.forEach{deleteSugarRealm(sugarRealm: $0)}
    
    
  }
  
  private func findNearestSugarObjectWithOutCompObjId(sugarDeleteId: String) -> [SugarRealm] {
    
    
    let allSugarsWithoutLast = fetchAllSugar().dropLast().reversed()

    
    let removeSugars:[SugarRealm] = allSugarsWithoutLast.prefix { (sugar) -> Bool in
      sugar.compansationObjectId == nil
    }

    return removeSugars
    
  }
  
  private func deleteSugarRealm(sugarRealm: SugarRealm) {
    
    do {
      self.realm.beginWrite()
      self.realm.delete(sugarRealm)
      
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"Sugar in DB")
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}


// MARK: Update Sugar From Realm
extension SugarRealmManager {
  
  func updateSugarRealm(
    sugarRealm    : SugarRealm,
    chartDataCase : ChartDataCase,
    sugar         : Double,
    time          : Date) {
    
//    guard let sugarRealm = fetchSugarByCompansationId(sugarCompObjId: sugarCompId) else {return}
    do {
      self.realm.beginWrite()
      
      sugarRealm.sugar = sugar
      sugarRealm.time  = time
      sugarRealm.chartDataCase  = chartDataCase
      
      try self.realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  

}
