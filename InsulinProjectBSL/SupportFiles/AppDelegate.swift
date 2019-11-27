//
//  AppDelegate.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  let items: [ProductRealm] = [

    ProductRealm(name: "Яблоко", category: "Фрукты и овощи", carboIn100Grm: 11, isFavorits: false),
    ProductRealm(name: "Молоко", category: "Молочные продукты", carboIn100Grm: 4, isFavorits: false),
    ProductRealm(name: "Творог", category: "Молочные продукты", carboIn100Grm: 3, isFavorits: false),
    ProductRealm(name: "Апельсин", category: "Фрукты и овощи", carboIn100Grm: 8, isFavorits: false),
    ProductRealm(name: "Абрикос", category: "Фрукты и овощи", carboIn100Grm: 11, isFavorits: false),
    ProductRealm(name: "Мандарин", category: "Печенья", carboIn100Grm: 11, isFavorits: false),
    ProductRealm(name: "Бананы", category: "Сладости", carboIn100Grm: 11, isFavorits: false),

  ]
  
  var meals: [MealRealm] = [

  ]
  
  var dinners: [DinnerRealm] = [

  ]
  
//  var sectionType: [SectionMealTypeRealm] = []
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
//    let breakFast = SectionMealTypeRealm(name: "Завтраки")
//    let launch = SectionMealTypeRealm(name: "Обеды")
//
//
//    let meals1 = MealRealm(name: "Гречка с грибами",typeMeal: "Завтрак")
//    meals1.listProduct.append(ProductRealm(name: "Грибы", category:"Грибы", carboIn100Grm: 2, isFavorits: false))
//    meals1.listProduct.append(ProductRealm(name: "Гречка", category:"Крупы", carboIn100Grm: 65, isFavorits: false))
//    meals1.listProduct.append(ProductRealm(name: "Салат овощной", category:"Овощи", carboIn100Grm: 2, isFavorits: false))
//    meals.append(meals1)
//    let meals2 = MealRealm(name: "Омлет с горошком", typeMeal: "Обед")
//    meals2.listProduct.append(ProductRealm(name: "Омлет", category:"Молочные продукты", carboIn100Grm: 2, isFavorits: false))
//    meals2.listProduct.append(ProductRealm(name: "Зеленый горошек", category:"Консервый", carboIn100Grm: 7, isFavorits: false))
//    meals2.listProduct.append(ProductRealm(name: "Сыр", category:"Молочные продукты", carboIn100Grm: 2, isFavorits: false))
//    meals2.listProduct.append(ProductRealm(name: "Сыр Капченный", category:"Молочные продукты", carboIn100Grm: 2, isFavorits: false))
//    meals.append(meals2)
//
//    breakFast.mealsData.append(meals1)
//    launch.mealsData.append(meals2)
//
//    sectionType.append(breakFast)
//    sectionType.append(launch)
    
    
    initializeRealm()
    initMeals()
    
//    initDinners()
    
    root()
    
    
    return true
  }
  
  func root() {
    
    
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    let tabBarController = BaseTabBarController()
    
    window?.rootViewController = tabBarController
    
  }
  
 
  
  
  private func initializeRealm() {
    // Здесь указываем с какой схемой Realm работаем!
    let realm = RealmProvider.products.realm
    guard realm.isEmpty else { return }

    try! realm.write {
//      realm.deleteAll()
      items.forEach({ (product) in
        realm.add(product)
      })

    }
  }
  
  private func initMeals() {
    let realm = RealmProvider.meals.realm
 
    guard realm.isEmpty else { return }
    
    try! realm.write {
//      realm.deleteAll()
      realm.add(meals)
    }
    
  }
  
  private func initDinners() {
    let realm = RealmProvider.dinners.realm
//    guard realm.isEmpty else { return }

//    let dummyDinner = DinnerRealm(shugarBefore: 0, shugarAfter: 0, timeShugarBefore: Date(), timeShugarAfter: nil, placeInjection: "", trainName: "", correctionInsulin: 0, totalInsulin: 0,isPreviosDinner: false)
//    dinners.append(dummyDinner)
    
    try! realm.write {
      realm.deleteAll()
//      realm.add(dinners)
    }
    
  }
  



}

