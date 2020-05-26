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
  
  enum Property                    : String {case id}
             
             
  dynamic var id                   : String = ""
             
             
  // Propertyies
  dynamic var sugar                : Double = 0  // Сами показатели сахара
  dynamic var time                 : Date = Date()       // Время когда установленн сахар
             
  dynamic var dataCase             : Int = 0     // Тип данных которые приходят в график
  
  var chartDataCase: ChartDataCase {
    set {dataCase = newValue.rawValue}
    get {ChartDataCase.init(rawValue: dataCase) ?? ChartDataCase.mealData}
  }

  dynamic var compansationObjectId : String?

  
  convenience init(
    id                   : String = UUID().uuidString,
    time                 : Date,
    sugar                : Double,
    dataCase             : ChartDataCase,
    compansationObjectId : String?
    
    ) {
      self.init()
    self.id                   = id
    self.sugar                = sugar
    self.time                 = time
    self.dataCase             = dataCase.rawValue
    self.compansationObjectId = compansationObjectId

    }
  
  
  override static func primaryKey() -> String? {
    return SugarRealm.Property.id.rawValue
  }
}
