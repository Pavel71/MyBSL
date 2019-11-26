//
//  Sugar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift




@objcMembers class SugarRealm: Object {
  
  enum Property         : String {case id}
  
  
  dynamic var id        : String = UUID().uuidString
  
  
  // Propertyies
  dynamic var sugar     : Double = 0  // Сами показатели сахара
  dynamic var time      : Date?       // Время когда установленн сахар
  
  dynamic var dataCase  : Int = 0     // Тип данных которые приходят в график
  dynamic var data      : [String:Double]?
  
  convenience init(
    time      : Date,
    sugar     : Double,
    typeSugar : Int,
    data      : [String: Double]?
    ) {
      self.init()
    self.sugar     = sugar
    self.time      = time
    self.dataCase  = dataCase
    self.data      = data
   
    }
  
  override static func primaryKey() -> String? {
    return SugarRealm.Property.id.rawValue
  }
}
