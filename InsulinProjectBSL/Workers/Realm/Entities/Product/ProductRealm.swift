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
  
  dynamic var id                    : String = ""
  dynamic var name                  : String = ""
  dynamic var category              : String = ""
  dynamic var carboIn100grm         : Int    = 0
  dynamic var portion               : Int    = 100
  
  dynamic var percantageCarboInMeal : Float = 0
  
  
  var carboInPortion: Float {
    return (Float(carboIn100grm) * (Float(portion) / 100))
  }
  
  var setPercentageCarboInMeal: Double {
    set{percantageCarboInMeal = carboInPortion / newValue.toFloat()}
    get{return Double(self.percantageCarboInMeal)}
  }
  
  dynamic var userSetInsulinOnCarbo : Float = 0
  dynamic var insulinOnCarboToML    : Float = 0
  
  dynamic var isFavorits: Bool = false
  
  convenience init(
      id : String = UUID().uuidString,
      name                  : String,
      category              : String,
      carboIn100Grm         : Int,
      isFavorits            : Bool,
      portion               : Int = 100,
      actualInsulin         : Float = 0
  ) {
    self.init()
    
    self.id                    = id
    self.name                  = name
    self.category              = category
    self.carboIn100grm         = carboIn100Grm
    self.portion               = portion
    self.isFavorits            = isFavorits
    self.userSetInsulinOnCarbo = actualInsulin
    
    
    
    
  }
  
  
  
  
  override static func primaryKey() -> String? {
    return ProductRealm.Property.id.rawValue
  }
  
}
