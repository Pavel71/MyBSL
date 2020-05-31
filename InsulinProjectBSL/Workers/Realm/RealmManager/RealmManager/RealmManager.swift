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
  
}


// MARK: Set Netwrok Data To Realm

extension RealmManager {
  
  
  
  func setNetwrokdDataToRealm(fireStoreModel: FireStoreNetwrokModels) {
    
    setCompObjs(compObjNetwrokModels : fireStoreModel.compObjs)
    setSugars(sugarNetworkModels     : fireStoreModel.sugars)
    setDays(dayNetworkModels         : fireStoreModel.days)
    setMeals(mealNetworkModels       : fireStoreModel.meals)
    setProducts(productNetworkModels : fireStoreModel.products)
  }
  
  private func setDays(dayNetworkModels: [DayNetworkModel]) {
    let days = dayNetworkModels.map(convertWorker.convertDayNetworkModelsToRealm)
    dayRealmManager.setDaysToRealm(days: days)
  }
  
  private func setSugars(sugarNetworkModels:[SugarNetworkModel]) {
    
    let sugars = sugarNetworkModels.map(convertWorker.convertSugarsNetwrokModelToRealm)
    sugarRealmManager.setSugarToRealm(sugars: sugars)
  }
  
  private func setCompObjs(compObjNetwrokModels:[CompObjNetworkModel]) {
    let compObjs = compObjNetwrokModels.map(convertWorker.convertCompObjsNetworkModelToRealm)
    
    compObjRealmManager.setCompObjsToRealm(compObjs: compObjs)
  }
  private func setMeals(mealNetworkModels: [MealNetworkModel]) {
    let meals = mealNetworkModels.map(convertWorker.convertMealNetwrokToMealRealm)
    mealRealmManager.setMealsToRealm(meals: meals)
  }
  
  private func setProducts(productNetworkModels:[ProductNetworkModel]) {
    let products = productNetworkModels.map(convertWorker.convertProductNEtwrokModelToProductRealm)
    productRealmManager.setProductsToRealm(products: products)
  }
  
}

