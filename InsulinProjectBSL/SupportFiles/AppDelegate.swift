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
    ProductRealm(name: "Мандарин", category: "Фрукты и овощи", carboIn100Grm: 11, isFavorits: false),
    ProductRealm(name: "Бананы", category: "Фрукты и овощи", carboIn100Grm: 25, isFavorits: false),

  ]
  
  var meals: [MealRealm] = [

  ]
  
  var dinners: [DinnerRealm] = [

  ]
  
//  var sectionType: [SectionMealTypeRealm] = []
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    

    
    
    initializeRealm()
    initMeals()
    
//    initDinners()
    
//    deInitDaysRealm()
    
    root()
    
    
    return true
  }
  
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
  
    // Здесь мне нужно сделать проверку на дату! и передать информацию в ViewController - сделать какойнить класс с оперативкой
    let appStateService: AppState = AppState.shared
    let tabBarController = appStateService.mainWindow?.rootViewController as! BaseTabBarController
    
    let mainScreenController:MainScreenViewController = tabBarController.viewControllers?.filter{$0.children[0] is MainScreenViewController}[0].children[0] as! MainScreenViewController
    
    mainScreenController.activateApplication()
    
  }
  
  func root() {
    
    // Здесь нужно использовать AppState
    
    let appStateService: AppState = AppState.shared
    
    appStateService.mainWindow = UIWindow(frame: UIScreen.main.bounds)
    appStateService.mainWindow?.rootViewController = BaseTabBarController()
    appStateService.mainWindow?.makeKeyAndVisible()
    
    
    let isOnBoardingComplete = UserDefaults.standard.bool(forKey: UserDefaultsKey.isOnBoardingComplete.rawValue)
    if isOnBoardingComplete == false {
         appStateService.secondWindow = UIWindow(frame: UIScreen.main.bounds)

          let onBoardController = UINavigationController(rootViewController: OnBoardViewController(transitionStyle: .scroll, navigationOrientation: .horizontal))
          
          appStateService.secondWindow?.rootViewController = onBoardController

      //     Это сделаю при запуске приложения первый раз!
          appStateService.secondWindow?.makeKeyAndVisible()
    }
    
 
    
    
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

  private func deInitDaysRealm() {
    let realm = RealmProvider.day.realm
//    print("Init Day Realm")
////    guard  realm.isEmpty else {return}
//
//    print("База Данных пустая!")
//      let blankDay = DayRealm()
//
//      do {
//        realm.beginWrite()
//        realm.deleteAll()
//        realm.add(blankDay, update: .all)
//
//        try realm.commitWrite()
//        print(realm.configuration.fileURL?.absoluteURL as Any,"Day in DB")
//
//      } catch {
//        print(error.localizedDescription)
//      }
    
        try! realm.write {
          realm.deleteAll()
    //      realm.add(dinners)
        }
    
    initCompObjRealm()
    initSugarRealm()
  }
  
  private func initCompObjRealm() {
    let realm = RealmProvider.compObjProvider.realm
    
        try! realm.write {
          realm.deleteAll()
    //      realm.add(dinners)
        }
    
  }
  
  private func initSugarRealm() {
    
    let realm = RealmProvider.sugarProvider.realm
    
  
    
        try! realm.write {
          realm.deleteAll()
    //      realm.add(dinners)
        }
    
  }
  



}

