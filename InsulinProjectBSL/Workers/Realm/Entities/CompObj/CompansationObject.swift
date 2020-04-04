//
//  CompansationObject.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 09.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class CompansationObjectRelam: Object {
  
  enum Property                : String { case id }
        
  dynamic var id               : String = UUID().uuidString
  
  var isUpdated                : Bool   = false
  var updateThisID             : String = ""
        
  // тип объекта
  dynamic var typeObject       : Int = 0
  
  var typeObjectEnum: TypeCompansationObject {
    get {TypeCompansationObject(rawValue: typeObject)!}
    set {typeObject = newValue.rawValue}
  }

  
  dynamic var sugarBefore      : Double = 0
  
  var correctionPositionObject : CorrectInsulinPosition{
    ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: Float(sugarBefore))
  }
  
  
  
  
  dynamic var sugarAfter       : Double = 0 // Этот параметр буду сетить как только вводится новая дозировка инсулина! Тогда мы будем брать текущий сахар
  dynamic var timeCreate       : Date = Date()
  // На какой стадии находится объект
  
  dynamic var compansationFase : Int    = 0
  var compansationFaseEnum : CompansationPosition   {
    
    set {compansationFase =  newValue.rawValue}
    get {CompansationPosition.init(rawValue: compansationFase)!}
    
  }
  
  
  // For results
  dynamic var insulinOnTotalCarbo      : Double = 0
  dynamic var insulinInCorrectionSugar : Double = 0
  
  var totalInsulin                     : Double  {
    insulinOnTotalCarbo + insulinInCorrectionSugar
  }
  
  dynamic var totalCarbo               : Double = 0
  dynamic var placeInjections          : String = ""
   
   
   var listProduct              = List<ProductRealm>()
  
  convenience init(
    typeObject               : TypeCompansationObject,
    sugarBefore              : Double,
    insulinOnTotalCarbo      : Double,
    insulinInCorrectionSugar : Double,
    totalCarbo               : Double,
    placeInjections          : String
    
    ) {
      self.init()
    self.typeObject               = typeObject.rawValue
    self.sugarBefore              = sugarBefore
    self.compansationFase         = CompansationPosition.progress.rawValue
    self.totalCarbo               = totalCarbo
    self.insulinOnTotalCarbo      = insulinOnTotalCarbo
    self.insulinInCorrectionSugar = insulinInCorrectionSugar
    self.placeInjections          = placeInjections
    
    }
  
  override static func primaryKey() -> String? {
    return CompansationObjectRelam.Property.id.rawValue
  }

}
