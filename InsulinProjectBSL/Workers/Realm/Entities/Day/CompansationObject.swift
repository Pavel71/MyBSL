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
        
  // тип объекта
  dynamic var typeObject       : Int = 0
  

  
  dynamic var sugarBefore      : Double = 0
  
  var correctionPositionObject : CorrectInsulinPosition{
    ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: Float(sugarBefore))
  }
  
  
  dynamic var sugarAfter       : Double = 0 // Этот параметр буду сетить как только вводится новая дозировка инсулина! Тогда мы будем брать текущий сахар
  dynamic var timeCreate       : Date?
  // На какой стадии находится объект
  dynamic var compansationFase : Int    = 0
  
  
  
  // For results
   dynamic var totalCarbo      : Double = 0
   dynamic var totalInsulin    : Double = 0
   
   
   var listProduct              = List<ProductRealm>()
  
  convenience init(
    typeObject            : TypeCompansationObject,
    sugarBefore           : Double,
    totalCarbo            : Double,
    totalInsulin          : Double
    
    ) {
      self.init()
    self.typeObject       = typeObject.rawValue
    self.sugarBefore      = sugarBefore
    self.timeCreate       = Date()
    self.compansationFase = CompansationPosition.progress.rawValue
    self.totalCarbo       = totalCarbo
    self.totalInsulin     = totalInsulin
    
    }
  
  override static func primaryKey() -> String? {
    return CompansationObjectRelam.Property.id.rawValue
  }

}
