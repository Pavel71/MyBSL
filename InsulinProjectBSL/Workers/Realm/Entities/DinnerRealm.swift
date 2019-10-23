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
  
  dynamic var isPreviosDinner: Bool = false

  // Top
  dynamic var shugarBefore: Float = 0
  dynamic var shugarAfter: Float = 0

  dynamic var timeShugarBefore: Date? = nil
  dynamic var timeShugarAfter: Date? = nil
  
  dynamic var correctionInsulin: Float = 0
  
  // Middle
  
  // Product
  
  var listProduct = List<ProductRealm>()
  
  // Place Injections
  dynamic var placeInjection: String = ""
  // Activity
  dynamic var trainName: String = ""
  
  // Footer
  
  dynamic var totalInsulin: Float = 0
  
  
  
  convenience init(shugarBefore: Float,timeShugarBefore: Date, placeInjection: String, trainName: String,listProduct: List<ProductRealm>) {
    self.init()
    
    self.shugarBefore = shugarBefore
    self.timeShugarBefore = timeShugarBefore
    self.placeInjection = placeInjection
    self.trainName = trainName
    self.listProduct = listProduct

  }


  override static func primaryKey() -> String? {
    return ProductRealm.Property.id.rawValue
  }
  
}
