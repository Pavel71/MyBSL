//
//  Meal.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 30/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class MealRealm: Object {
  
  enum Property: String {
    case id, name
  }
  
  dynamic var isExpandMeal = false
  
  dynamic var id           : String = ""
  dynamic var name         : String = ""
  
  dynamic var typeMeal     : String = ""

  
  let listProduct          =  List<ProductRealm>()

  
  convenience init(id: String = UUID().uuidString ,
                   name: String,
                   typeMeal: String,
                   isExpandMeal: Bool) {
    self.init()
    self.id           = id
    self.name         = name
    self.typeMeal     = typeMeal
    self.isExpandMeal = isExpandMeal
  
  }
  
  override static func primaryKey() -> String? {
    return MealRealm.Property.id.rawValue
  }
}
