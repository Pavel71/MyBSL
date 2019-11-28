//
//  Meal.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift




@objcMembers class DinnersRealm: Object {
  
  enum Property                : String { case id }
  
  dynamic var id               : String = UUID().uuidString
  
  
  // Propertyies
  dynamic var sugarBefore      : Double = 0
  dynamic var sugarAfter       : Double = 0 // Этот параметр буду сетить как только вводится новая дозировка инсулина! Тогда мы будем брать текущий сахар
  dynamic var timeEating       : Date?
  dynamic var compansationFase : Int    = 0
  
  // For results
  dynamic var totalCarbo       : Double = 0
  dynamic var totalInsulin     : Double = 0
  dynamic var totalPortion     : Double = 0
  
  var listProduct                    = List<ProductRealm>()
  
  convenience init(
    compansationFase : Int,
    timeEating       : Date,
    sugarBefore      : Double,
    totalCarbo       : Double,
    totalInsulin     : Double,
    totalPortion     : Double
      
    ) {
      self.init()
    self.compansationFase = compansationFase
    self.timeEating       = timeEating
    self.sugarBefore      = sugarBefore
    self.totalCarbo       = totalCarbo
    self.totalInsulin     = totalInsulin
    self.totalPortion     = totalPortion

    }
  
  override static func primaryKey() -> String? {
    return DinnersRealm.Property.id.rawValue
  }
}
