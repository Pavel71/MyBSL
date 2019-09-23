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

    ProductRealm(name: "Яблоко", category: "Фрукты и овощи", carbo: 11, isFavorits: false),
    ProductRealm(name: "Молоко", category: "Молочные продукты", carbo: 4, isFavorits: false),
    ProductRealm(name: "Творог", category: "Молочные продукты", carbo: 3, isFavorits: false),
    ProductRealm(name: "Апельсин", category: "Фрукты и овощи", carbo: 8, isFavorits: false),
    ProductRealm(name: "Абрикос", category: "Фрукты и овощи", carbo: 11, isFavorits: false),
    ProductRealm(name: "Мандарин", category: "Печенья", carbo: 11, isFavorits: false),
    ProductRealm(name: "Бананы", category: "Сладости", carbo: 11, isFavorits: false),

  ]
  
  var meals: [MealRealm] = [
    
//    MealRealm(name: "Обед1"),
//    MealRealm(name: "Обед2"),
//    MealRealm(name: "Обед3"),
  
  ]
  
  var sectionType: [SectionMealTypeRealm] = []
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let breakFast = SectionMealTypeRealm(name: "Завтраки")
    let launch = SectionMealTypeRealm(name: "Обеды")
    
    
    let meals1 = MealRealm(name: "Гречка с грибами",typeMeal: "Завтрак")
    meals1.listProduct.append(ProductRealm(name: "Грибы", category:"Грибы", carbo: 2, isFavorits: false))
    meals1.listProduct.append(ProductRealm(name: "Гречка", category:"Крупы", carbo: 65, isFavorits: false))
    meals1.listProduct.append(ProductRealm(name: "Салат овощной", category:"Овощи", carbo: 2, isFavorits: false))
    meals.append(meals1)
    let meals2 = MealRealm(name: "Омлет с горошком", typeMeal: "Обед")
    meals2.listProduct.append(ProductRealm(name: "Омлет", category:"Молочные продукты", carbo: 2, isFavorits: false))
    meals2.listProduct.append(ProductRealm(name: "Зеленый горошек", category:"Консервый", carbo: 7, isFavorits: false))
    meals2.listProduct.append(ProductRealm(name: "Сыр", category:"Молочные продукты", carbo: 2, isFavorits: false))
    meals2.listProduct.append(ProductRealm(name: "Сыр Капченный", category:"Молочные продукты", carbo: 2, isFavorits: false))
    meals.append(meals2)
    
    breakFast.mealsData.append(meals1)
    launch.mealsData.append(meals2)
    
    sectionType.append(breakFast)
    sectionType.append(launch)
    
    
    root()
    initializeRealm()
//    initSectionMealRealm()
    initMeals()
    
    return true
  }
  
  func root() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    let tabBarController = BaseTabBarController()
    
    window?.rootViewController = tabBarController
    
  }
  
  
//  private func configureNavigationBar() {
//    // NAvBar
//    UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.497985065, green: 0.7887284756, blue: 1, alpha: 1)
//    UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//    // StatusBar
//    let statusBarView = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
//    statusBarView.backgroundColor = #colorLiteral(red: 0.497985065, green: 0.7887284756, blue: 1, alpha: 1)
//    UINavigationBar.appearance().barStyle = .blackTranslucent
//
//    self.window?.rootViewController?.view.insertSubview(statusBarView, at: 0)
//
//    // Title
//    let textAttributes = [
//      NSAttributedString.Key.foregroundColor : UIColor.white,
//      NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Light", size: 24)
//    ]
//
//    UINavigationBar.appearance().titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
//
//    // TabBar
//    UITabBar.appearance().tintColor = .white
//    UITabBar.appearance().barTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//    UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabSelectBG")
//  }
  
  
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
  



}

