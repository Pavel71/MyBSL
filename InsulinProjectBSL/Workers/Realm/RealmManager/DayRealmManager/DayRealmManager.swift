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
    
    let testDay = DayRealm(date: Date())

    let dinners = getDummyDInner()
    testDay.listDinners.append(dinners)
    
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
      totalCarbo : 5
    )
    
    let simpleSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574841600),
      sugar      : 7.5,
      dataCase   : ChartDataCase.sugarData.rawValue,
      insulin    : 0,
      totalCarbo : 0
    )
    
    let correctInsulinSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574845200),
      sugar      : 12.5,
      dataCase   : ChartDataCase.correctInsulinData.rawValue,
      insulin    : 0.5,
      totalCarbo : 0
    )
    
    return [sugarMeal,simpleSugar,correctInsulinSugar]
    
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
       let product = ProductRealm(
         name          : "Молоко",
         category      : "Молочные продукты",
         carboIn100Grm : 5,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
         isFavorits    : false,
         actualInsulin : 0.5)
       
       dinner.listProduct.append(product)
    return dinner
  }
  
}
