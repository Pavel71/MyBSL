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
    
    let items = realm.objects(DinnerRealm.self).sorted(byKeyPath: DinnerRealm.Property.timeCreateDinner.rawValue, ascending: false)
    
    return Array(items)
    
  }
}
