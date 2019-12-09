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
  dynamic var sugarAfter       : Double = 0 // Этот параметр буду сетить как только вводится новая дозировка инсулина! Тогда мы будем брать текущий сахар
  dynamic var timeCreate       : Date?
  // На какой стадии находится объект
  dynamic var compansationFase : Int    = 0
  
  // For results
   dynamic var carbo           : Double?
   dynamic var insulin         : Double?
   
   
   var listProduct              = List<ProductRealm>()
  
  convenience init(
    typeObject       : Int,
    sugarBefore      : Double,
    sugarAfter       : Double,
    timeCreate       : Date,
    compansationFase : Int,
    carbo            : Double,
    insulin          : Double
    
    ) {
      self.init()
    self.typeObject       = typeObject
    self.sugarBefore      = sugarBefore
    self.sugarAfter       = sugarAfter
    self.timeCreate       = timeCreate
    self.compansationFase = compansationFase
    self.carbo            = carbo
    self.insulin          = insulin
    
    }
  
  override static func primaryKey() -> String? {
    return CompansationObjectRelam.Property.id.rawValue
  }

}
