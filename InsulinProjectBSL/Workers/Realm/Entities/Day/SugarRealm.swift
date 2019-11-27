//
//  Sugar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift
import Realm



@objcMembers class SugarRealm: Object {
  
  enum Property          : String {case id}
   
   
  dynamic var id         : String = UUID().uuidString
   
   
  // Propertyies
  dynamic var sugar      : Double = 0  // Сами показатели сахара
  dynamic var time       : Date = Date()       // Время когда установленн сахар
   
  dynamic var dataCase   : Int = 0     // Тип данных которые приходят в график
   
  dynamic var insulin    : Double?
  dynamic var totalCarbo : Double?
//  dynamic var data      : [Double]? // Не разрешает хранить словарь!
  
  
  // Здесь какая идея сейчас у мнея эти данные разнятся! тоесть они не свзянна сахара и обеды! а можно сделать так что обед всегда содержит сахар тоесть там будут данные какой сахар до еды каким стал после еды!
  
  convenience init(
    time       : Date,
    sugar      : Double,
    dataCase   : Int,
    insulin    : Double?,
    totalCarbo : Double?
    
    ) {
      self.init()
    self.sugar      = sugar
    self.time       = time
    self.dataCase   = dataCase
    self.insulin    = insulin
    self.totalCarbo = totalCarbo
    
   
    }
  
  
  override static func primaryKey() -> String? {
    return SugarRealm.Property.id.rawValue
  }
}
