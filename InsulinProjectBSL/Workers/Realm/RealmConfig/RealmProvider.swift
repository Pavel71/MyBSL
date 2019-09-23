//
//  RealmProvider.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
  
  let configuration: Realm.Configuration
  
  init(config: Realm.Configuration) {
    configuration = config
  }
  
  var realm: Realm {
    return try! Realm(configuration: configuration)
  }

  // MARK: - Realm Models

  private static let productConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("products.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [ProductRealm.self])
  
  public static var products: RealmProvider = {
    return RealmProvider(config: productConfig)
  }()
  
  private static let mealConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("meals.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [MealRealm.self,ProductRealm.self])
  
  public static var meals: RealmProvider = {
    return RealmProvider.init(config: mealConfig)
  }()
  
  private static let sectionMealTypeConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("sectionMealType.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [SectionMealTypeRealm.self,MealRealm.self, ProductRealm.self])
  
  public static let sectionMealTypes: RealmProvider = {
    return RealmProvider(config: sectionMealTypeConfig)
  }()
  
}
