//
//  Day.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift



// Так вообщем здесь структкурка такая у нас есть день и он содержит

// 1. список данных по движению сахара
// 2. Обеды потребляемые в течении дня





@objcMembers class DayRealm: Object {
  
  enum Property : String {case id}
  
  enum DayType {
    case newDay,pastDay
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var date: Date = Date() // Дата будет создаватся при создание объекта
  
  dynamic var listSugarID   = List<String>()
  dynamic var listCompObjID = List<String>()
  
  
  
//  var listSugar          = List<SugarRealm>()
//  var listCompObj        = List<CompansationObjectRelam>()
  
  var dayType: DayType {
    
    return date.onlyDate()!.compareDateByDay(with: Date()) ? .newDay : .pastDay
  }
  
  convenience  init(
    date: Date
    ) {
      self.init()
    
    self.date = date
   
    }
  
  
  override static func primaryKey() -> String? {
     return DayRealm.Property.id.rawValue
   }
  
  
  
}
