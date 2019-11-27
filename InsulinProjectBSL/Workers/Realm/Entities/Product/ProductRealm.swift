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
  dynamic var carboIn100grm: Int = 0
  dynamic var portion: Int = 100
  
  var carboInPortion: Float {
    return (Float(carboIn100grm) * (Float(portion) / 100))
  }
  
  dynamic var actualInsulin: Float = 0
  dynamic var goodCompansationinsulin: Float = 0
  
  dynamic var isFavorits: Bool = false
  
  convenience init(name: String, category: String, carboIn100Grm: Int, isFavorits: Bool, portion: Int = 100, actualInsulin: Float = 0) {
    self.init()
    
    self.name = name
    self.category = category
    self.carboIn100grm = carboIn100Grm
    self.portion = portion
    self.isFavorits = isFavorits
    self.actualInsulin = actualInsulin
    
  }
  
  
  override static func primaryKey() -> String? {
    return ProductRealm.Property.id.rawValue
  }
  
}