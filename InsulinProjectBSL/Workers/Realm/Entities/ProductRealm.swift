//
//  Product.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class ProductRealm: Object {
  
  enum Property: String {
    case id, name
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var name: String = ""
  dynamic var category: String  = ""
  dynamic var carbo: Int = 0
  dynamic var portion: Int = 100
  
  dynamic var isFavorits: Bool = false
  
  convenience init(name: String, category: String, carbo: Int, isFavorits: Bool, portion: Int = 100) {
    self.init()
    
    self.name = name
    self.category = category
    self.carbo = carbo
    self.portion = portion
    self.isFavorits = isFavorits
    
  }
  
  
  override static func primaryKey() -> String? {
    return ProductRealm.Property.id.rawValue
  }
  
}
