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
  
  
  // Products
  private static let productConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("products.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [ProductRealm.self])
  
  public static var products: RealmProvider = {
    return RealmProvider(config: productConfig)
  }()
  
  
  // Meal
  private static let mealConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("meals.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [MealRealm.self,ProductRealm.self])
  
  public static var meals: RealmProvider = {
    return RealmProvider.init(config: mealConfig)
  }()
  
  // Dinners
  
  private static let dinnerConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("dinners.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [DinnerRealm.self,ProductRealm.self])
  
  public static var dinners: RealmProvider = {
    return RealmProvider.init(config: dinnerConfig)
  }()
  
  // Days
  
  private static let dayConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("day.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [DayRealm.self,SugarRealm.self,CompansationObjectRelam.self,ProductRealm.self])
  
  public static var day: RealmProvider = {
    return RealmProvider.init(config: dayConfig)
  }()
  
  
  private static let compObjConfig = Realm.Configuration(
    fileURL: try! Path.inDocuments("compObj.realm"),
    schemaVersion: 1,
    deleteRealmIfMigrationNeeded: true, // Это для тестирования
    objectTypes: [CompansationObjectRelam.self,ProductRealm.self])
  
  public static var compObjProvider: RealmProvider = {
    return RealmProvider.init(config: compObjConfig)
  }()
  
  private static let sugarConfig = Realm.Configuration(
     fileURL: try! Path.inDocuments("sugar.realm"),
     schemaVersion: 1,
     deleteRealmIfMigrationNeeded: true, // Это для тестирования
     objectTypes: [SugarRealm.self])
   
   public static var sugarProvider: RealmProvider = {
     return RealmProvider.init(config: sugarConfig)
   }()
  
//  private static let sectionMealTypeConfig = Realm.Configuration(
//    fileURL: try! Path.inDocuments("sectionMealType.realm"),
//    schemaVersion: 1,
//    deleteRealmIfMigrationNeeded: true, // Это для тестирования
//    objectTypes: [SectionMealTypeRealm.self,MealRealm.self, ProductRealm.self])
//
//  public static let sectionMealTypes: RealmProvider = {
//    return RealmProvider(config: sectionMealTypeConfig)
//  }()
  
}
