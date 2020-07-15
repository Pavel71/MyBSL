//
//  RealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation



// Класс отвечает за доступ ко всем остальным реалм менеджерам
class RealmManager {
  
  private var dayRealmManager     : NewDayRealmManager!
  private var mealRealmManager    : MealRealmManager!
  private var productRealmManager : FoodRealmManager!
  private var sugarRealmManager   : SugarRealmManager!
  private var compObjRealmManager : CompObjRealmManager!
  private var convertWorker       : ConvertorWorker!
  
  init() {
    let locator = ServiceLocator.shared
    
    dayRealmManager     = locator.getService()
    mealRealmManager    = locator.getService()
    productRealmManager = locator.getService()
    sugarRealmManager   = locator.getService()
    compObjRealmManager = locator.getService()
    convertWorker       = locator.getService()
  }
  
}

// MARK: Realm Manager Clear Old Data

extension RealmManager {
  
  func deleteAllDataFromRealm() {
    
     print("Очищаем старую базу данных")
      
      dayRealmManager.deleteDaysRealm()
      mealRealmManager.deleteAllMeals()
      productRealmManager.deleteAllProducts()
      sugarRealmManager.deleteAllSugars()
      compObjRealmManager.deleteAllCompObjs()
      
    
    
  }
  
  func deleteEmptyDayFromRealm() {
    dayRealmManager.deleteCurrentDay()
  }
  
}

// MARK: Fetch Stats Data
extension RealmManager {
  
  // Нужно переделать это все! Реалм менеджер просто достает данные а ] уже с ними раюотаю в презентере!
  
  func fetchStatsData() -> CrudeStatsData {
    
    // Mean Insulin On The Carbo
    
    // Нужно взять все дни и получить все углеводы сумму потом получить весь инсулин сумму и разделить углеводы на сумму
    
    let allCompObj:[CompansationObjectRelam] = Array(compObjRealmManager.fetchAllCompObj())
    
    
    
    // Mean Sugar For 10 Days
    let allDays                = dayRealmManager.fetchAllDays()
    let las10Days :[DayRealm]  = allDays.suffix(10)
    
    let sugarsFor10Days = las10Days.flatMap{
      $0.listSugarID.compactMap(self.sugarRealmManager.fetchSugarByPrimeryKey)
    }
    
    // PieChart Model
    let goodCompCount   = compObjRealmManager.fetchCompObjCount(typeObj: .good)
    let badCompObjCount = compObjRealmManager.fetchCompObjCount(typeObj: .modifidedForMl)
    
    
    return CrudeStatsData(
      allCompObj       : allCompObj,
      sugarFor10Days   : sugarsFor10Days,
      goodCompObjCount : goodCompCount,
      badCompObjCount  : badCompObjCount)
  }
  
}

// MARK: Set Netwrok Data To Realm

extension RealmManager {
  
  
  
  func setNetwrokdDataToRealm(fireStoreModel: FireStoreNetwrokModels) {
    
//    setCompObjs(compObjNetwrokModels : fireStoreModel.compObjs)
//    setSugars(sugarNetworkModels     : fireStoreModel.sugars)
    setDays(dayNetworkModels         : fireStoreModel.days)
    setMeals(mealNetworkModels       : fireStoreModel.meals)
    setProducts(productNetworkModels : fireStoreModel.products)
  }
  
  private func setDays(dayNetworkModels: [DayNetworkModel]) {
//    var (days,compObjs,sugarObjs) = dayNetworkModels.map(convertWorker.convertDayNetworkModelsToRealm)
    
    dayNetworkModels.forEach { (dayNetwork) in
      let (day,compObj,sugarObj) = convertWorker.convertDayNetworkModelsToRealm(dayNetworkModel: dayNetwork)
      dayRealmManager.setDaysToRealm(days: [day])
      sugarObj.forEach(sugarRealmManager.addOrUpdateNewSugarRealm(sugarRealm: ))
      compObj.forEach(compObjRealmManager.addOrUpdateNewCompObj(compObj:))
    }
    
//    dayRealmManager.setDaysToRealm(days: days)
  }
  
//  private func setSugars(sugarNetworkModels:[SugarNetworkModel]) {
//
//    let sugars = sugarNetworkModels.map(convertWorker.convertSugarsNetwrokModelToRealm)
//    sugarRealmManager.setSugarToRealm(sugars: sugars)
//  }
//
//  private func setCompObjs(compObjNetwrokModels:[CompObjNetworkModel]) {
//    let compObjs = compObjNetwrokModels.map(convertWorker.convertCompObjsNetworkModelToRealm)
//
//    compObjRealmManager.setCompObjsToRealm(compObjs: compObjs)
//  }
  private func setMeals(mealNetworkModels: [MealNetworkModel]) {
    let meals = mealNetworkModels.map(convertWorker.convertMealNetwrokToMealRealm)
    mealRealmManager.setMealsToRealm(meals: meals)
  }
  
  private func setProducts(productNetworkModels:[ProductNetworkModel]) {
    let products = productNetworkModels.map(convertWorker.convertProductNEtwrokModelToProductRealm)
    productRealmManager.setProductsToRealm(products: products)
  }
  
}

