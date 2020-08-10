//
//  AppDelegate.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate  {

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
  

  
  let appStateService: AppState = AppState.shared
  
//  var sectionType: [SectionMealTypeRealm] = []
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    activateFirebase()
    iniitServiceLocator()
    
//    clearAllData()
//    addBaseProducts()
//    initMeals()
    
//    initDinners()
//    
//    deInitDaysRealm()
//    clearUserDefaultsFields()
    
    root()
    
    checkLoginIN()
    
    
    return true
  }
  
  // MARK: ACTIVATE FIREBASE
  private func activateFirebase() {
    FirebaseApp.configure()
  }
  
  
  private func checkLoginIN() {
    
    if Auth.auth().currentUser == nil {
      
      // Не залогинены
      appStateService.removeMainWindowController()
      appStateService.loginRegisterWindow?.makeKeyAndVisible()
      
    } else {
      appStateService.setMainTabBarController()
      appStateService.mainWindow?.makeKeyAndVisible()
    }
  }
  
  private func clearAllData() {
    clearUserDefaultsFields()
    RealmManager().deleteAllDataFromRealm()
  }
  
  // MARK: CLEAR USERDEFAULTS Fields
  private func clearUserDefaultsFields() {
    
    UserDefaultsKey.allCases.forEach{UserDefaults.standard.removeObject(forKey: $0.rawValue)}
    
    
  }
  
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
    let appStateService: AppState = AppState.shared
    
    appStateService.pushUpdateMainScreenViewControllerMethod()
        
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    print("Закрывают приложение")
    let listner: ListnerService! = ServiceLocator.shared.getService()
    listner.removeAllListners()
    // Возможно здесь нужно есче почистить userDefault and Realm
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    print("Приложени на бэкграунде")
  }
  
  // MARK: Root
  
  func root() {
    
    // Здесь нужно использовать AppState
    
   
    
    // Set MainWindow
    let dummyViewController = UIViewController()
    dummyViewController.view.backgroundColor = .white
    appStateService.mainWindow = UIWindow(frame: UIScreen.main.bounds)
    appStateService.mainWindow?.rootViewController =  dummyViewController

    
    
    // Set LoginRegister Window
    appStateService.loginRegisterWindow = UIWindow(frame: UIScreen.main.bounds)
    
    let loginRegisterController = UINavigationController(rootViewController: RegistrationController())
    appStateService.loginRegisterWindow?.rootViewController = loginRegisterController
    
    
    
    
    // Set OnBoarding Window
    appStateService.onBoardingWindow = UIWindow(frame: UIScreen.main.bounds)

    let onBoardController = UINavigationController(rootViewController: OnBoardViewController(transitionStyle: .scroll, navigationOrientation: .horizontal))
    
    appStateService.onBoardingWindow?.rootViewController = onBoardController


  }
  
 
 
  



}


// Help Func

// MARK: Register Services

extension AppDelegate {
  
   private func iniitServiceLocator() {
    
    setNetWorkService()

    
    let locator = ServiceLocator.shared
    
    
    locator.addService(service: UserDefaultsWorker())
    locator.addService(service: SugarMetricConverter())
    locator.addService(service: ShugarCorrectorWorker())
    
    locator.addService(service: CompObjRealmManager())
    locator.addService(service: SugarRealmManager())
    locator.addService(service: FoodRealmManager())
    locator.addService(service: MealRealmManager())
    locator.addService(service: NewDayRealmManager())
    locator.addService(service: RealmManager())
    locator.addService(service: InsulinSupplyWorker())
    locator.addService(service: DataEnrichmentWorker())
    locator.addService(service: ConvertorWorker())
     
    }
  
  private func setNetWorkService() {
    
    let locator = ServiceLocator.shared
    
    locator.addService(service: AddService())
    locator.addService(service: UpdateService())
    locator.addService(service: FetchService())
    locator.addService(service: DeleteService())
    locator.addService(service: ButchWritingService())
    locator.addService(service: ListnerService())
    
    
  }
    
    private func addBaseProducts() {
      // Здесь указываем с какой схемой Realm работаем!
      let realm = RealmProvider.products.realm
      guard realm.isEmpty else { return }

      try! realm.write {
//        realm.deleteAll()
        items.forEach({ (product) in
          realm.add(product)
        })

      }
    }
    
//    private func initMeals() {
//      let realm = RealmProvider.meals.realm
//
//      guard realm.isEmpty else { return }
//
//      try! realm.write {
//  //      realm.deleteAll()
//        realm.add(meals)
//      }
//
//    }

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

