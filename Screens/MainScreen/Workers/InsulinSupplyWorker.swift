//
//  InsulinSupplyWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


// Класс отвечает за работу с InsulinSupplyView

class InsulinSupplyWorker {
  
  let userDefaults = UserDefaults.standard
  
}


// MARK: Calculated InsulinSupplyValue

extension InsulinSupplyWorker {
  
  enum InsulinSupplyCalculatedType {
    case add,delete,update
  }
  
  func updateInsulinSupplyValue(totalInsulin: Float,updatedType: InsulinSupplyCalculatedType) {
    
    
    let currentSupplyValue = userDefaults.integer(forKey: UserDefaultsKey.insulinSupplyValue.rawValue).toFloat()
    
    switch updatedType {
      
      case .add:
        
        userDefaults.set((currentSupplyValue - totalInsulin).rounded(.toNearestOrAwayFromZero).toInt(), forKey: UserDefaultsKey.insulinSupplyValue.rawValue)
      
      case .delete:
        
        userDefaults.set((currentSupplyValue + totalInsulin).rounded(.toNearestOrAwayFromZero).toInt(), forKey: UserDefaultsKey.insulinSupplyValue.rawValue)
      
      case .update:
        
        userDefaults.set((currentSupplyValue + totalInsulin).rounded(.toNearestOrAwayFromZero).toInt(), forKey: UserDefaultsKey.insulinSupplyValue.rawValue)
        
        
        
    }

  }
  
  
  
}
