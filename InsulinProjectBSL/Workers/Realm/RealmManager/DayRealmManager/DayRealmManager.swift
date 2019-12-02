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
    
    let testDay = DayRealm(date: Date())

    let dinners1 = getDummyDInner()
    dinners1.id  = meal1Id
    let dinners2 = getDummyDInner2()
    dinners2.id  = meal2Id
    
    let dinner3  = getDummyDInner()
    dinner3.id   = meal3Id
    testDay.listDinners.append(objectsIn: [dinners1,dinners2,dinner3])
    
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
      insulin    : 0.5,
      totalCarbo : 5,
      mealId     : "111"
    )
    
    let simpleSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574841600),
      sugar      : 7.5,
      dataCase   : ChartDataCase.sugarData.rawValue,
      insulin    : 0,
      totalCarbo : 0,
      mealId     : nil
    )
    
    let correctInsulinSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574845200),
      sugar      : 12.5,
      dataCase   : ChartDataCase.correctInsulinData.rawValue,
      insulin    : 0.5,
      totalCarbo : 0,
      mealId     : nil
    )
    
    let sugarMeal2 = SugarRealm(
         time       : Date(timeIntervalSince1970: 1574849000),
         sugar      : 6.0,
         dataCase   : ChartDataCase.mealData.rawValue,
         insulin    : 1.5,
         totalCarbo : 15,
         mealId     : "222"
       )
    
    let sugarMeal3 = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574852000),
      sugar      : 8.0,
      dataCase   : ChartDataCase.mealData.rawValue,
      insulin    : 2.5,
      totalCarbo : 25,
      mealId     : "333"
    )
    
    return [sugarMeal,simpleSugar,correctInsulinSugar,sugarMeal2,sugarMeal3]
    
  }
  
  
  // Dinner
  
  private func getDummyDInner() -> DinnersRealm {
    
    let dinner = DinnersRealm(
      compansationFase    : CompansationPosition.progress.rawValue,
         timeEating       : Date(timeIntervalSince1970: 1574838000),
         sugarBefore      : 6.0,
         totalCarbo       : 5,
         totalInsulin     : 0.5,
         totalPortion     : 100
         
         
       )
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
       
    dinner.listProduct.append(objectsIn: [product1,product2,product3])
       
    return dinner
  }
  
  private func getDummyDInner2() -> DinnersRealm {
    
    let dinner = DinnersRealm(
      compansationFase    : CompansationPosition.progress.rawValue,
         timeEating       : Date(timeIntervalSince1970: 1574849000),
         sugarBefore      : 6.0,
         totalCarbo       : 15,
         totalInsulin     : 1.5,
         totalPortion     : 200
         
         
       )
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
       
    dinner.listProduct.append(objectsIn: [product1,product2,product3])
       
    return dinner
  }
  
}
