//
//  DinnerRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



class DinnerRealmManager {
  
  let provider: RealmProvider
  
  init(provider: RealmProvider = RealmProvider.dinners) {
    self.provider = provider
    
  }
  
  
}

// MARK: Save Data

extension DinnerRealmManager {
  
  func saveDinner(dinner:DinnerRealm) {
    
    let realm = provider.realm

    
    try! realm.write {
      realm.add(dinner)
    }
  }

  
}

// MARK: Fetch Data

extension DinnerRealmManager {
  
  func fetchAllData() -> [DinnerRealm] {
    
    let realm = provider.realm
    
    let items = realm.objects(DinnerRealm.self).sorted(byKeyPath: DinnerRealm.Property.timeCreateDinner.rawValue)
    
    return Array(items)
    
  }
}

// MARK: Update Previos Dinner

extension DinnerRealmManager {
  
  // В реалме это последний обед
  func getPreviosDinner() -> DinnerRealm {
    let realm = provider.realm
    guard let lastDinner = realm.objects(DinnerRealm.self).last else {fatalError("Последнего обеда нет")}
    return lastDinner
  }
  
  func updateShugarAfterInPreviosDinner(shugar: Float, compansation: CompansationPosition) {
    
    let realm = provider.realm
    guard realm.objects(DinnerRealm.self).count > 0 else {return}
    // Хорошая ли компенсация у предыдущего обеда

    let lastDinner = getPreviosDinner()
    
    try! realm.write {
      lastDinner.compansationFase = compansation.rawValue
      lastDinner.shugarAfter = shugar
    }
    
    
  }
  
}

// MARK: ML Requests

extension DinnerRealmManager {
  
  
  func getCountTrainObjects() -> Int {
    return provider.realm.objects(DinnerRealm.self).count
  }
  
  func getSimpleTrainData() -> [Float]  {
    
    // Я пока шо то не пойму как взять нужную колонку отсюда! Нам также потребуется и таргет есче
    
    let realm = provider.realm
    
    let carbo = realm.objects(DinnerRealm.self).filter("compansationFase == %@",CompansationPosition.good.rawValue).flatMap{$0.listProduct.map{$0.carboInPortion}}
    
    return Array(carbo)
  }
  
  func getTargretData() -> [Float]  {
    
    // Я пока шо то не пойму как взять нужную колонку отсюда! Нам также потребуется и таргет есче
    
    let realm = provider.realm
    
    let carbo = realm.objects(DinnerRealm.self).filter("compansationFase == %@",CompansationPosition.good.rawValue).flatMap{$0.listProduct.map{$0.userSetInsulinOnCarbo}}
    
    // Здесь нужно брать не актуал инсулин а скорректированный если коректировка не нужна то берется актуалИнсулин
    
    return Array(carbo)
  }
  
}
