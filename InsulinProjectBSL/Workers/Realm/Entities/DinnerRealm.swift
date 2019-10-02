//
//  DinnerRealm.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class DinnerRealm: Object {
  
  enum Property: String {
    case id, name
  }
  
  // Поля которые будут в диннере для UI это 1
  // 
  //
  
  dynamic var id: String = UUID().uuidString
  
  
  
  // Top
//  dynamic var shugarBefore: Float = 0
//  dynamic var shugarAfter: Float = 0
//
//  dynamic var timeShugarBefore: Date
//  dynamic var timeShugarAfter: Date
  
  // Product
  
//  let listProduct = List<ProductRealm>()
  
  // Place Injections
  
  // Здесь должен быть функционал обеспечивающий выбор места иньъекции
  
  // Activity
  // указать планируется ли тренировка!
  
  
  
  
//  convenience required init() {
//    self.init()
//
//
//  }
//
//
//  override static func primaryKey() -> String? {
//    return ProductRealm.Property.id.rawValue
//  }
  
}
