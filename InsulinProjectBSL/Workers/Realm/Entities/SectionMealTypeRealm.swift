//
//  SectionMealType.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 02/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import RealmSwift

@objcMembers class SectionMealTypeRealm: Object {
  
  
  enum Property: String {
    case id, name
  }
  
  dynamic var name: String = ""
  dynamic var isExpandSection: Bool = false
  
  let mealsData = List<MealRealm>()
  
  dynamic var id: String = UUID().uuidString
  
  convenience init(name: String) {
    self.init()
    self.name = name
    
  }
  
  override static func primaryKey() -> String? {
    return SectionMealTypeRealm.Property.id.rawValue
  }
}
