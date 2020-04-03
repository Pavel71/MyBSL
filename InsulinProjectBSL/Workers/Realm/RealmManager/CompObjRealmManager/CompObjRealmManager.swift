//
//  CompObjRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import RealmSwift



class CompObjRealmManager {
  
  
  
  let provider: RealmProvider
  
  static var shared:CompObjRealmManager = {CompObjRealmManager()}()
  
  var realm : Realm {provider.realm}
  
  init(provider: RealmProvider = RealmProvider.compObjProvider) {
    self.provider = provider
    
  }
  
}


// MARK: Fetch Sugar From Realm
extension CompObjRealmManager {
  
  func fetchAllCompObj() -> Results<CompansationObjectRelam> {
    
    return realm.objects(CompansationObjectRelam.self)
    
  }
  
  func fetchCompObjById(compObjId: String) -> CompansationObjectRelam? {
    
    let compObj = fetchAllCompObj().first(where: {$0.id == compObjId})
    return compObj
  }
  
}



// MARK: Add or Update New SugarRealm

extension CompObjRealmManager {
  
  func addOrUpdateNewCompObj(compObj: CompansationObjectRelam) {
    
    
    do {
      self.realm.beginWrite()
      self.realm.add(compObj, update: .all)
      
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"CompObj in DB")
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}

// MARK: Delete Sugar From Realm
extension CompObjRealmManager {
  
  func deleteCompObgById(compObjId: String) {
    print(compObjId,"Comp Id")
    guard let compObj = fetchCompObjById(compObjId: compObjId) else {return}
    deleteCompObj(compObj: compObj)
  }
  
  
  private func deleteCompObj(compObj: CompansationObjectRelam) {
    
    do {
      self.realm.beginWrite()
      self.realm.delete(compObj)
      
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"CompObj in DB")
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}

//MARK: Update Comp Obj

extension CompObjRealmManager {
  
   typealias TransportTuple = (compObjId: String, sugarBefore: Double, typeObjectEnum: TypeCompansationObject, insulinCarbo: Double, insulinCorrect: Double, totalCarbo: Double, placeInjections: String, productsRealm: [ProductRealm])
  
  func updateCompObj(transportTuple: TransportTuple) {
    
    guard let updateCompObj = fetchCompObjById(compObjId: transportTuple.compObjId) else {return}
    
    do {
      self.realm.beginWrite()
      
      updateCompObj.sugarBefore              = transportTuple.sugarBefore
      updateCompObj.typeObjectEnum           = transportTuple.typeObjectEnum
      updateCompObj.insulinOnTotalCarbo      = transportTuple.insulinCarbo
      updateCompObj.insulinInCorrectionSugar = transportTuple.insulinCorrect
      updateCompObj.totalCarbo               = transportTuple.totalCarbo
      updateCompObj.placeInjections          = transportTuple.placeInjections
      updateCompObj.listProduct.append(objectsIn:transportTuple.productsRealm )
      
      
      try self.realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    // не уверен что это требуется скорее всего нет
//    CompObjRealmManager.shared.addOrUpdateNewCompObj(compObj: updateCompObj)
    
    

  }
  
}
