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


// MARK: Fetch CompansationObjectRelam From Realm
extension CompObjRealmManager {
  
  func fetchAllCompObj() -> Results<CompansationObjectRelam> {
    
    return realm.objects(CompansationObjectRelam.self)
    
  }
  
//  func fetchCompObjById(compObjId: String) -> CompansationObjectRelam? {
//    
//    let compObj = fetchAllCompObj().first(where: {$0.id == compObjId})
//    return compObj
//  }
  
  func fetchLastCompObj() -> CompansationObjectRelam? {
    
    return fetchAllCompObj().last
  }
  
  func fetchPrevCompObj(before compObj: CompansationObjectRelam) -> CompansationObjectRelam? {
    
    let allCompObj = fetchAllCompObj()
    guard let index = allCompObj.index(of: compObj) else {return nil}
    let indexBefore = allCompObj.index(before: index)
    
    
    return allCompObj[indexBefore]
  }
  
  
  
  func fetchSecondOnTheEndCompObj() -> CompansationObjectRelam? {
    
    let allCompObj = fetchAllCompObj()
    let count = allCompObj.count
    
    var compObj : CompansationObjectRelam?
    print(count)
    if count > 1 {
       compObj = allCompObj[count - 2]
    }
    
    print("Second of the End", compObj)
    return  compObj
  }
  
  func fetchCompObjByPrimeryKey(compObjPrimaryKey: String)-> CompansationObjectRelam? {
    
    let compObj = realm.object(ofType: CompansationObjectRelam.self, forPrimaryKey: compObjPrimaryKey)
    return compObj
  }
  
}



// MARK: Add or Update New SugarRealm

extension CompObjRealmManager {
  
  func addOrUpdateNewCompObj(compObj: CompansationObjectRelam) {
    
    // пежде чем добавить новый сcompObj - внеси изменения в последний
    
    // если будет предыдущий объект то обнови его данными из нового
    updatePrevCompObjWhenAddNew(timeCreateNew: compObj.timeCreate, sugarNew: compObj.sugarBefore)
    
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
    
    guard let compObj = fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId) else {return}
    deleteCompObj(compObj: compObj)
    
    // После удаления измени состояние предыдущего обеда
    updatingPrevCompObjWhenDeleting()
    
    
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
    
    guard let updateCompObj = fetchCompObjByPrimeryKey(compObjPrimaryKey: transportTuple.compObjId) else {return}
    
    updatingPrevCompObjWhenUpdatingCurrent(sugarAfter: transportTuple.sugarBefore)
    
    do {
      
      self.realm.beginWrite()
      
      updateCompObj.sugarBefore              = transportTuple.sugarBefore
      updateCompObj.typeObjectEnum           = transportTuple.typeObjectEnum
      updateCompObj.insulinOnTotalCarbo      = transportTuple.insulinCarbo
      updateCompObj.insulinInCorrectionSugar = transportTuple.insulinCorrect
      updateCompObj.totalCarbo               = transportTuple.totalCarbo
      updateCompObj.placeInjections          = transportTuple.placeInjections
      updateCompObj.listProduct.removeAll()
      updateCompObj.listProduct.append(objectsIn:transportTuple.productsRealm)
      
      try self.realm.commitWrite()
      
    } catch {
      print(error.localizedDescription)
    }
  }

  
}


// MARK: UpdatingPrevCompObj

extension CompObjRealmManager {

  // Updating When Adding new Comp Obj
  func updatePrevCompObjWhenAddNew(timeCreateNew: Date, sugarNew:Double) {

    guard let lastCompObj = fetchLastCompObj() else {return}
    
    if isTimeBeetwinCompObjActual(timeLastCompObj: lastCompObj.timeCreate, timeNewCompObj: timeCreateNew) {
      
      print("Время между двумя обедами больше 15 часов")
      
      updatingPrevCompObjIfNeeded(
        sugarAfter   : 0,
        compPosition : .dontCalculated,
        prevCompObj  : lastCompObj)
      
    } else {
      
      print("Время между двумя обедами меньше 15 часов")
      let compPosition = getCompObjStateBySugarAfter(sugarAfter: sugarNew)
      
      updatingPrevCompObjIfNeeded(
        sugarAfter   : sugarNew,
        compPosition : compPosition,
        prevCompObj  : lastCompObj)
      
    }
    
    
  }
  
  // Updating PrevCompObj When Deleteng
  
  private func updatingPrevCompObjWhenDeleting() {
    
    guard let lastCompobj = fetchLastCompObj() else {return}
    updatingPrevCompObjIfNeeded(
      sugarAfter   : 0,
      compPosition : .progress,
      prevCompObj  : lastCompobj)
    
  }
  
  // Updating PrevCompObj When Updating Current
  private func updatingPrevCompObjWhenUpdatingCurrent(sugarAfter: Double) {
    
    guard let prevCompobj = fetchSecondOnTheEndCompObj() else {return}
    
    let compPosition = getCompObjStateBySugarAfter(sugarAfter: sugarAfter)
    
    updatingPrevCompObjIfNeeded(
      sugarAfter : sugarAfter,
    compPosition : compPosition,
    prevCompObj  : prevCompobj)
  }
  
  
  // MARK: Helps Function
  
  
  private func isTimeBeetwinCompObjActual(timeLastCompObj: Date, timeNewCompObj: Date) -> Bool {
    let components = Calendar.current.dateComponents([.hour], from: timeLastCompObj, to: timeNewCompObj)
    let diff = components.hour!
    
    return diff > 15
  }
  
  
  
  private func updatingPrevCompObjIfNeeded(
     sugarAfter   : Double,
     compPosition : CompansationPosition,
     prevCompObj  : CompansationObjectRelam) {
     
     do {
       
       self.realm.beginWrite()
       
       prevCompObj.sugarAfter           = sugarAfter
       prevCompObj.compansationFaseEnum = compPosition
       
       try self.realm.commitWrite()
       
     } catch {
       print(error.localizedDescription)
     }
     
   }
  
  
  private func getCompObjStateBySugarAfter(sugarAfter: Double) -> CompansationPosition {
     
     let sugarCompansation = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: Float(sugarAfter))
     
     var compPosition: CompansationPosition
     
     switch sugarCompansation {
     case .correctDown:
       compPosition = .bad
     case .correctUp:
       compPosition = .bad
     case .dontCorrect:
       compPosition = .good
     case .progress:
       compPosition = .progress
     case .needCorrect:
       compPosition = .progress
     }
     
     return compPosition
   }
  
}
