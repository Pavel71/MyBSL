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

// MARK: Delete All Sugars
extension SugarRealmManager {
  
  func deleteAllSugars() {
    do {
      self.realm.beginWrite()
      self.realm.deleteAll()
      try self.realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
  }
}

// MARK: Add or Update New SugarRealm

extension SugarRealmManager {
  
  func setSugarToRealm(sugars: [SugarRealm]) {
    
    let sortedSugars = sugars.sorted(by: {$0.time < $1.time})

    do {
         self.realm.beginWrite()
         self.realm.add(sortedSugars, update: .all)
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
  

  func deleteSugarId(sugarId: String) {
    
    guard let sugarRealm = fetchSugarByPrimeryKey(sugarPrimaryKey: sugarId) else {return}
    
    deleteSugarRealm(sugarRealm: sugarRealm)

  }
  
  func getNearestSugarToDelete(sugarId: String) ->[String] {
    
    var nearestSugarToDelte = findNearestSugarObjectWithOutCompObjId(sugarDeleteId: sugarId)
    nearestSugarToDelte.append(sugarId)
    
    return nearestSugarToDelte
  }
  
  private func findNearestSugarObjectWithOutCompObjId(sugarDeleteId: String) -> [String] {
    
    
    let allSugarsWithoutLast = fetchAllSugar().dropLast().reversed()

    
    let removeSugars:[String] = allSugarsWithoutLast.prefix { (sugar) -> Bool in
      sugar.compansationObjectId == nil
    }.map{$0.id}

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
