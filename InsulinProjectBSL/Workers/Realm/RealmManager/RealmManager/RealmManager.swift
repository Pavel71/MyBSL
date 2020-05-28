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
  
  init() {
    let locator = ServiceLocator.shared
    
    dayRealmManager     = locator.getService()
    mealRealmManager    = locator.getService()
    productRealmManager = locator.getService()
    sugarRealmManager   = locator.getService()
    compObjRealmManager = locator.getService()
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
    let days = dayNetworkModels.map(convertDayNetworkModelsToRealm)
    dayRealmManager.setDaysFromFireStore(days: days)
  }
  
  private func setSugars(sugarNetworkModels:[SugarNetworkModel]) {
    
    let sugars = sugarNetworkModels.map(convertSugarsNetwrokModelToRealm)
    sugarRealmManager.setSugarFromFireStore(sugars: sugars)
  }
  
  private func setCompObjs(compObjNetwrokModels:[CompObjNetworkModel]) {
    let compObjs = compObjNetwrokModels.map(convertCompObjsNetworkModelToRealm)
    
    compObjRealmManager.setCompObjsFromFireStore(compObjs: compObjs)
  }
  private func setMeals(mealNetworkModels: [MealNetworkModel]) {
    let meals = mealNetworkModels.map(convertMealNetwrokToMealRealm)
    mealRealmManager.setMealsFromFireStore(meals: meals)
  }
  
  private func setProducts(productNetworkModels:[ProductNetworkModel]) {
    let products = productNetworkModels.map(convertProductNEtwrokModelToProductRealm)
    productRealmManager.setProductsFromFireStore(products: products)
  }
  
}

// MARK: Convert NetwrokModel to Realm Data
extension RealmManager {
  
  
  // MARK: Convert Days
  
  private func convertDayNetworkModelsToRealm(dayNetworkModel: DayNetworkModel) -> DayRealm {
    
    let day = DayRealm(id : dayNetworkModel.id, date: Date(timeIntervalSince1970: dayNetworkModel.date))
    
    day.listSugarID.append(objectsIn: dayNetworkModel.listSugarID)
    day.listCompObjID.append(objectsIn: dayNetworkModel.listCompObjID)
    return day
  }
  
  
  // MARK: Convert CompObjs
  
  private func convertCompObjsNetworkModelToRealm(compObjModel: CompObjNetworkModel) -> CompansationObjectRelam {
    
    let compObj = CompansationObjectRelam(
      id                       : compObjModel.id,
      timeCreate               : Date(timeIntervalSince1970:compObjModel.timeCreate),
      typeObject               : TypeCompansationObject(rawValue: compObjModel.typeObject)!,
      sugarBefore              : compObjModel.sugarBefore,
      insulinOnTotalCarbo      : compObjModel.insulinOnTotalCarbo,
      insulinInCorrectionSugar : compObjModel.userSetInsulinToCorrectSugar,
      totalCarbo               : compObjModel.totalCarbo,
      placeInjections          : compObjModel.placeInjections)
    
    
    compObj.insulinToCorrectSugarML      = compObjModel.insulinToCorrectSugarML
    compObj.sugarAfter                   = compObjModel.sugarAfter
    compObj.compansationFase             = compObjModel.compansationFase
    
    let productList = compObjModel.listProduct.map(convertProductNEtwrokModelToProductRealm)
    compObj.listProduct.append(objectsIn: productList)
    
    return compObj
  }
  
  // MARK: Convert Sugars
  
  private func convertSugarsNetwrokModelToRealm(sugarNetworkModel: SugarNetworkModel) -> SugarRealm {
    
    let sugar = SugarRealm(
      id                   : sugarNetworkModel.id,
      time                 : Date(timeIntervalSince1970: sugarNetworkModel.time),
      sugar                : sugarNetworkModel.sugar,
      dataCase             : ChartDataCase(rawValue: sugarNetworkModel.dataCase)!,
      compansationObjectId : sugarNetworkModel.compansationObjectId)
    
    return sugar
    
  }
  
  
  // MARK: Convert Meals
  
  private func convertMealNetwrokToMealRealm(mealNetworkModel: MealNetworkModel) -> MealRealm {
    let meal = MealRealm(
      id           : mealNetworkModel.id,
      name         : mealNetworkModel.name,
      typeMeal     : mealNetworkModel.typeMeal,
      isExpandMeal : mealNetworkModel.isExpandMeal)
    
    let listProduct = mealNetworkModel.listProduct.map(convertProductNEtwrokModelToProductRealm)
    
    meal.listProduct.append(objectsIn: listProduct)
    return meal
  }
  
  // MARK: Convert Product
  
  private func convertProductNEtwrokModelToProductRealm(productNetworkModel: ProductNetworkModel) -> ProductRealm {
    
    let product = ProductRealm(
      id            : productNetworkModel.id,
      name          : productNetworkModel.name,
      category      : productNetworkModel.category,
      carboIn100Grm : productNetworkModel.carboIn100grm,
      isFavorits    : productNetworkModel.isFavorits,
      portion       : productNetworkModel.portion,
      actualInsulin : productNetworkModel.userSetInsulinOnCarbo)
    
    product.percantageCarboInMeal = productNetworkModel.percantageCarboInMeal
    product.insulinOnCarboToML    = productNetworkModel.insulinOnCarboToML
    
    return product
  }
  
}
