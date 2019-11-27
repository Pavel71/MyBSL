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
  
  dynamic var time             : Date?
  dynamic var compansationFase : Int = 0
  
  var listProduct                    = List<ProductRealm>()
  
  convenience init(
    compansationFase: Int,
    time: Date
      
    ) {
      self.init()
    self.compansationFase = compansationFase
    self.time = time

    }
  
  override static func primaryKey() -> String? {
    return DinnersRealm.Property.id.rawValue
  }
}
