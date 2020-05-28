//
//  CompObjRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import RealmSwift



final class CompObjRealmManager {
  
  
  
  let provider: RealmProvider
  
  //  static var shared:CompObjRealmManager = {CompObjRealmManager()}()
  
  var realm : Realm {provider.realm}
  
  var sugarCorrectorWorker: ShugarCorrectorWorker!
  
  init(provider: RealmProvider = RealmProvider.compObjProvider) {
    self.provider = provider
    
    let locator = ServiceLocator.shared
    
    sugarCorrectorWorker = locator.getService()
    
  }
  
}

// MARK: Delete All CompObjs

extension CompObjRealmManager {
  
  func deleteAllCompObjs() {
    
    do {
      self.realm.beginWrite()
      self.realm.deleteAll()
      try self.realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
    
  }
}


// MARK: Fetch CompansationObjectRelam From Realm
extension CompObjRealmManager {
  
  func fetchAllCompObj() -> Results<CompansationObjectRelam> {
    
    return realm.objects(CompansationObjectRelam.self)
    
  }
  
  
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
    
    if count > 1 {
      compObj = allCompObj[count - 2]
    }
    return  compObj
  }
  
  func fetchCompObjByPrimeryKey(compObjPrimaryKey: String)-> CompansationObjectRelam? {
    
    let compObj = realm.object(ofType: CompansationObjectRelam.self, forPrimaryKey: compObjPrimaryKey)
    return compObj
  }
  
  func fetchCompObjByTypeCompObj(typeObj: TypeCompansationObject,compFase: CompansationPosition) -> Results<CompansationObjectRelam> {
    
    return fetchAllCompObj().filter("(typeObject == %@) AND (compansationFase == %@)",typeObj.rawValue,compFase.rawValue)
  }
  
  
  
}



// MARK: Add or Update New SugarRealm

extension CompObjRealmManager {
  
  // Loaded data From FireStore And Save
  
  func setCompObjsFromFireStore(compObjs: [CompansationObjectRelam]) {
    
    let sortedcompObjs = compObjs.sorted(by: {$0.timeCreate < $1.timeCreate})
    do {
      self.realm.beginWrite()
      self.realm.add(sortedcompObjs, update: .all)
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"CompObj in DB")
      
    } catch {
      print(error.localizedDescription)
    }
  }
  
  // Work with USer
  
  func addOrUpdateNewCompObj(compObj: CompansationObjectRelam) {
    
    // пежде чем добавить новый сcompObj - внеси изменения в последний
    
    // если будет предыдущий объект то обнови его данными из нового
    //    updatePrevCompObjWhenAddNew(timeCreateNew: compObj.timeCreate, sugarNew: compObj.sugarBefore)
    
    do {
      self.realm.beginWrite()
      self.realm.add(compObj, update: .modified)
      
      
      
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
    // Тут нужно внести поправку! Что мы не разрешаем править условие редактирование для предыдущего обеда если прошел день!
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
  
  typealias TransportTuple = (sugarBefore: Double, typeObjectEnum: TypeCompansationObject, insulinCarbo: Double, insulinCorrect: Double, totalCarbo: Double, placeInjections: String, productsRealm: [ProductRealm])
  
  
  
  func updateCompObj(transportTuple: TransportTuple,compObjId: String) {
    
    guard let updateCompObj = fetchCompObjByPrimeryKey(compObjPrimaryKey: compObjId) else {return}
    
    updatingPrevCompObjWhenUpdatingCurrent(sugarAfter: transportTuple.sugarBefore)
    
    do {
      
      self.realm.beginWrite()
      
      updateCompObj.sugarBefore                  = transportTuple.sugarBefore
      updateCompObj.typeObjectEnum               = transportTuple.typeObjectEnum
      updateCompObj.insulinOnTotalCarbo          = transportTuple.insulinCarbo
      updateCompObj.userSetInsulinToCorrectSugar = transportTuple.insulinCorrect
      updateCompObj.totalCarbo                   = transportTuple.totalCarbo
      updateCompObj.placeInjections              = transportTuple.placeInjections
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
    
    // Если день у последнего не равен текущему то редактировать такой объект нельзя
    let compPosition:CompansationPosition = lastCompobj.timeCreate.compareDateByDay(with: Date()) ? .progress : .dontCalculated
    
    
    
    updatingPrevCompObjIfNeeded(
      sugarAfter   : 0,
      compPosition : compPosition,
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
    
    let sugarCompansation = sugarCorrectorWorker.getWayCorrectPosition(sugar: Float(sugarAfter))
    
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


// MARK: ML Working

extension CompObjRealmManager {
  
  // MARK: Success Compansation
  
  func compensationSuccessWriteMlData(compObj: CompansationObjectRelam) {
    
    do {
      
      self.realm.beginWrite()
      
      setInsulinOnCorrectSugarML(compobj: compObj)
      compObj.listProduct.forEach(setInsulinOnCarboML)
      
      try self.realm.commitWrite()
      
    } catch {
      print(error.localizedDescription)
    }
  }
  
  
  
  
  // MARKK: Modifided Correct Sugar
  func writeCorrectSugarInsuilin(
    compObj: CompansationObjectRelam,
    correctSugarMl: Double,
    changeTypeCompPosition: CompansationPosition) {
    
    
    do {
      
      self.realm.beginWrite()
      compObj.compansationFaseEnum    = changeTypeCompPosition
      compObj.insulinToCorrectSugarML = Float(correctSugarMl)
      
      try self.realm.commitWrite()
      
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func writeInsulinOnCarboInProducts(
    compObj: CompansationObjectRelam,
    correctKoeficient: Float,
    isPlus: Bool) {
    
    
    do {
      
      self.realm.beginWrite()
      
      // нужно проследить чтобы происходили изменения в CompPosition но и Fetch шел не только хорошие объекты но и модифицированные! 
      //      compObj.compansationFaseEnum = .modifidedForMl
      
      if isPlus {
        
        compObj.listProduct.forEach { (product) in
          product.insulinOnCarboToML = product.userSetInsulinOnCarbo + (product.percantageCarboInMeal * correctKoeficient)
        }
        
      } else {
        compObj.listProduct.forEach { (product) in
          product.insulinOnCarboToML = product.userSetInsulinOnCarbo - (product.percantageCarboInMeal * correctKoeficient)
        }
      }
      compObj.compansationFaseEnum = .modifidedForMl
      
      
      
      try self.realm.commitWrite()
      
    } catch {
      print(error.localizedDescription)
    }
    
    
  }
  
  private func setInsulinOnCarboML(productRealm: ProductRealm) {
    
    productRealm.insulinOnCarboToML = productRealm.userSetInsulinOnCarbo
  }
  
  private func setInsulinOnCorrectSugarML(compobj:CompansationObjectRelam) {
    compobj.insulinToCorrectSugarML = Float(compobj.userSetInsulinToCorrectSugar)
  }
  
  
}

// MARK: Fetch For ML

extension CompObjRealmManager {
  
  
  
  // Для обучения мне нужно получить траин и таргет по Sugar Compansation и по Meal Compansation!
  // Только мне нужно понимать что я обяхан сетить 0 значения чтобы предсказания были более точными! Этого нельзя забыть!
  
  // Train Meal
  
  func fetchTrainCarbo() -> [Float] {
    // Идея просто забрать все объекты и вытащить от туда показатели
    // нельзя брать объекты которые не идут в рассчет или плохо компенсированны
    let allMealObj = fetchCompObjToMLLearning()
    let carboTrain : [Float] = allMealObj.flatMap{$0.listProduct.map{$0.carboInPortion}}
    
    
    return carboTrain
    
  }
  
  func fetchTargetCarbo() -> [Float] {
    
    let allMealObj = fetchCompObjToMLLearning()
    let insulinList:[Float] = allMealObj.flatMap{$0.listProduct.map{$0.insulinOnCarboToML}}
    
    
    return insulinList
  }
  
  private func fetchCompObjToMLLearning() -> [CompansationObjectRelam] {
    let filteredData : [CompansationObjectRelam] = fetchAllCompObj().dropLast().filter { (compObjRealm) -> Bool in
      compObjRealm.compansationFaseEnum != .dontCalculated
    }
    
    return filteredData
  }
  
  // Train Sugar
  
  func fetchTrainSugar() -> [Float] {
    
    let allMealObj = fetchAllCompObj().dropLast()
    let trainSugarData : [Float] = allMealObj.compactMap{$0.sugarDiffToOptimaForMl}
    
    
    return trainSugarData
  }
  // Target Sugar
  func fetchTargetSugar() -> [Float] {
    
    let allMealObj = fetchAllCompObj().dropLast()
    let targetSugarInsulin : [Float] = allMealObj.compactMap{$0.insulinToCorrectSugarML}
    
    
    return targetSugarInsulin
    
  }
  
}
