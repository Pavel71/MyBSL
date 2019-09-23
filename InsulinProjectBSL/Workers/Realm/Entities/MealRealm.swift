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
  
  
  
  dynamic var id: String = UUID().uuidString
  dynamic var name: String = ""
  
  dynamic var typeMeal: String = ""
  dynamic var isExpandMeal: Bool = false// Это здесь под вопросом! По идеи это поле не должно здесь быть
  
  let listProduct = List<ProductRealm>()

  
  convenience init(name: String,typeMeal: String,isExpandMeal: Bool = false ) {
    self.init()
    self.name = name
    self.typeMeal = typeMeal
    self.isExpandMeal = isExpandMeal
  
  }
  
  override static func primaryKey() -> String? {
    return MealRealm.Property.id.rawValue
  }
}
