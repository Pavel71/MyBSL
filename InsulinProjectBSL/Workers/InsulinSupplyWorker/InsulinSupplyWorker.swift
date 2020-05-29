//
//  InsulinSupplyWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


// Класс отвечает за работу с InsulinSupplyView

final class InsulinSupplyWorker {

  var userDefaultsWorker: UserDefaultsWorker!
  
  init () {
    userDefaultsWorker = ServiceLocator.shared.getService()
  }
}


// MARK: Calculated InsulinSupplyValue

extension InsulinSupplyWorker {
  
  enum InsulinSupplyCalculatedType {
    case add,delete,update
  }
  
  // в идеале здесь записать в реалм изменение Supply! Все будет в 1ом месте!
  
  func setNewInsulinSupplyToUserDefaults(
    totalInsulin: Float,
    updatedType: InsulinSupplyCalculatedType) {
    
    
    let currentSupplyValue = userDefaultsWorker.getInsulinSupply().toFloat()
      
    
    var resultValue: Int
    
    switch updatedType {
      
      case .add:
        
        resultValue = (currentSupplyValue - totalInsulin).rounded(.toNearestOrAwayFromZero).toInt()
      
      case .delete:
        
        resultValue = (currentSupplyValue + totalInsulin).rounded(.toNearestOrAwayFromZero).toInt()
      
      case .update:
        
        resultValue = (currentSupplyValue + totalInsulin).rounded(.toNearestOrAwayFromZero).toInt()
    }
    
    userDefaultsWorker.setInsulinSupplyValue(insulinSupply: resultValue)
  }
  
  
  
}
