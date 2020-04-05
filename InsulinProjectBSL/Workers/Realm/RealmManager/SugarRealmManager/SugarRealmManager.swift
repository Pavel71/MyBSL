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
  
  static var shared:SugarRealmManager = {SugarRealmManager()}()
  
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
  
  func addOrUpdateNewSugarRealm(sugarRealm: SugarRealm) {
    
    do {
      self.realm.beginWrite()
      self.realm.add(sugarRealm, update: .all)
      
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"Sugar in DB")
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}

// MARK: Delete Sugar From Realm
extension SugarRealmManager {
  
  
  func deleteSugarByCompObjId(sugarCompObjId: String) {
    guard let sugarRealm = fetchSugarByCompansationId(sugarCompObjId: sugarCompObjId) else {return}
    
    deleteSugarRealm(sugarRealm: sugarRealm)
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
  
  func updateSugarRealmByCompObj(compObj: CompansationObjectRelam) {
    
    guard let sugarRealm = fetchSugarByCompansationId(sugarCompObjId: compObj.id) else {return}
    do {
      self.realm.beginWrite()
      
      sugarRealm.sugar = compObj.sugarBefore
      
      sugarRealm.chartDataCase  = getChartDataCase(compObj: compObj)
      
      
      try self.realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
  private func getChartDataCase(compObj: CompansationObjectRelam) -> ChartDataCase {
    
    // Будет возвращать что у нас обед всегда когда есть обед
    guard compObj.listProduct.isEmpty else {return .mealData}
    
    switch compObj.correctSugarPosition {
      
    case .correctDown:
      return .correctInsulinData
    case .correctUp:
      return .correctCarboData
      
    default:
      return .sugarData
    }

  }
}
