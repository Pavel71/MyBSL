//
//  DayRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


class DayRealmManager {
  
  let provider: RealmProvider
  
  init(provider: RealmProvider = RealmProvider.day) {
    self.provider = provider
    
  }
  
}

// MARK: Dummy Data

extension DayRealmManager {
  
  // Пока задача будет такой! нужно вернуть 1 день и псмотреть шо из этого получится! Мазафака!
  
  func getDummyRealmData() -> DayRealm {
    
    let meal1Id = "111"
    let meal2Id = "222"
    let meal3Id = "333"
    let insulinCOmpansationObjectID = "444"
    let carboCompansationObjectID = "555"
    
    let testDay = DayRealm(date: Date())

    let dinners1 = getDummyDInner()
    dinners1.id  = meal1Id
    let dinners2 = getDummyDInner2()
    dinners2.id  = meal2Id
    
    // Insulin Compansation
    
    let insulinCopmansationObject = CompansationObjectRelam(
      typeObject: TypeCompansationObject.correctSugarByInsulin.rawValue,
      sugarBefore: 12.5,
      sugarAfter: 0,
      timeCreate: Date(timeIntervalSince1970: 1574845200),
      compansationFase: CompansationPosition.bad.rawValue,
      carbo: 0,
      insulin: 1.0)
    insulinCopmansationObject.id = insulinCOmpansationObjectID
    
    // Carbo Compansation
    
    let carboCompansationObject = CompansationObjectRelam(
      typeObject: TypeCompansationObject.correctSugarByCarbo.rawValue,
      sugarBefore: 2.5,
      sugarAfter: 0,
      timeCreate: Date(timeIntervalSince1970: 1574841600),
      compansationFase: CompansationPosition.progress.rawValue,
      carbo: 5.0,
      insulin: 0)
    carboCompansationObject.id  = carboCompansationObjectID
    // Тут я также могу добавить еще и продукт который был употребленн!
    
    let dinner3  = getDummyDInner()
    dinner3.id   = meal3Id
    
    testDay.listDinners.append(objectsIn: [dinners1,carboCompansationObject,insulinCopmansationObject,dinners2,dinner3])
    
    let sugars = getSugars()
  
    testDay.listSugar.append(objectsIn: sugars)
    
    return testDay
  }
  
  // Sugars
  
  private func getSugars() -> [SugarRealm] {
    
   
    
    let sugarMeal = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574838000),
      sugar      : 6.0,
      dataCase   : ChartDataCase.mealData.rawValue,
      compansationObjectId   : "111"
    )
    
    let carboSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574841600),
      sugar      : 2.5,
      dataCase   : ChartDataCase.correctCarboData.rawValue,
      compansationObjectId  : "555"
    )
    
    let simpleSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574841600),
      sugar      : 7.5,
      dataCase   : ChartDataCase.sugarData.rawValue,
      compansationObjectId  : nil
    )
    
    
    
    let correctInsulinSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574845200),
      sugar      : 12.5,
      dataCase   : ChartDataCase.correctInsulinData.rawValue,
      compansationObjectId     : "444"
    )
    
    let sugarMeal2 = SugarRealm(
         time       : Date(timeIntervalSince1970: 1574849000),
         sugar      : 6.0,
         dataCase   : ChartDataCase.mealData.rawValue,
         compansationObjectId     : "222"
       )
    
    let sugarMeal3 = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574852000),
      sugar      : 8.0,
      dataCase   : ChartDataCase.mealData.rawValue,
      compansationObjectId     : "333"
    )
    
    return [sugarMeal,carboSugar,simpleSugar,correctInsulinSugar,sugarMeal2,sugarMeal3]
    
  }
  
  
  // Dinner
  
  private func getDummyDInner() -> CompansationObjectRelam {
    
    let compansationObjectLikeMeal = CompansationObjectRelam(
      typeObject  : TypeCompansationObject.mealObject.rawValue,
      sugarBefore : 5.0,
      sugarAfter  : 0,
      timeCreate  : Date(),
      compansationFase: CompansationPosition.progress.rawValue,
      carbo       : 13.0,
      insulin     : 1.5)
    
//    let dinner = DinnersRealm(
//      compansationFase    : CompansationPosition.progress.rawValue,
//         timeEating       : Date(timeIntervalSince1970: 1574838000),
//         sugarBefore      : 6.0,
//         totalCarbo       : 5,
//         totalInsulin     : 0.5,
//         totalPortion     : 100
//
//
//       )
    let product1 = ProductRealm(
         name          : "Молоко",
         category      : "Молочные продукты",
         carboIn100Grm : 5,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
         isFavorits    : false,
         actualInsulin : 0.5
    )
    let product2 = ProductRealm(
      name          : "Яблоко",
      category      : "Фрукты",
      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
      isFavorits    : false,
      actualInsulin : 1
    )
    
    let product3 = ProductRealm(
      name          : "Мандарин",
      category      : "Фрукты",
      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
      isFavorits    : false,
      actualInsulin : 1
    )
       
    compansationObjectLikeMeal.listProduct.append(objectsIn: [product1,product2,product3])
       
    return compansationObjectLikeMeal
  }
  
  private func getDummyDInner2() -> CompansationObjectRelam {
    
    let compansationObjectLikeMeal = CompansationObjectRelam(
    typeObject  : TypeCompansationObject.mealObject.rawValue,
    sugarBefore : 8.0,
    sugarAfter  : 0,
    timeCreate  : Date(),
    compansationFase: CompansationPosition.progress.rawValue,
    carbo       : 13.0,
    insulin     : 1.5)
    
    let product1 = ProductRealm(
         name          : "Печенье",
         category      : "Сладости",
         carboIn100Grm : 25,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
         isFavorits    : false,
         actualInsulin : 1
    )
    let product2 = ProductRealm(
      name          : "Суп с картошкой",
      category      : "Суп",
      carboIn100Grm : 3,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
      isFavorits    : false,
      actualInsulin : 0.3
    )
    
    let product3 = ProductRealm(
      name          : "Мандарин",
      category      : "Фрукты",
      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
      isFavorits    : false,
      actualInsulin : 1
    )
       
    compansationObjectLikeMeal.listProduct.append(objectsIn: [product1,product2,product3])
       
    return compansationObjectLikeMeal
  }
  
}
