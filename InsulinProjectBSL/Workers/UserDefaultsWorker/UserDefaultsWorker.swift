//
//  UserDefaultsWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation

// Класс Оболочка - отвечает за сохранение и изъятие данных из UserDefaults





final class UserDefaultsWorker {
  
  let userDefaults = UserDefaults.standard
  
  
}

// MARK: SET DATA
extension UserDefaultsWorker {
  
  func setDataToUserDefaults(data: [String: Any]) {
    
    UserDefaultsKey.allCases.forEach { (key) in
    
      userDefaults.set(data[key.rawValue], forKey: key.rawValue)
      
    }
    
  }
  
  func setInsulinSupplyValue(insulinSupply: Int) {
    userDefaults.set(insulinSupply, forKey: UserDefaultsKey.insulinSupplyValue.rawValue)

  }

  func setWeights(weights:[Float],key: UserDefaultsKey) {
    userDefaults.set(weights, forKey: key.rawValue)
  }
  
}

// MARK: GET DATA

extension UserDefaultsWorker {
  
  func getSugarLevel(sugarLevelKey: UserDefaultsKey) -> Float {
    userDefaults.float(forKey: sugarLevelKey.rawValue)
  }
  
  func getInsulinSupply() -> Int {
    userDefaults.integer(forKey: UserDefaultsKey.insulinSupplyValue.rawValue)
  }
  
  func getArrayData(typeDataKey: UserDefaultsKey) -> [Float] {
    userDefaults.array(forKey: typeDataKey.rawValue) as! [Float]
  }
  
  
  
  func getAllDataFromUserDefaults() -> [String: Any] {
    
    
    var dataDict = [String: Any]()
    
    UserDefaultsKey.allCases.forEach { (key) in
      switch key {
        
      case .carboCorrectTargetBaseData:
        let carboTarget = userDefaults.array(forKey: key.rawValue) as! [Float]
        dataDict[key.rawValue] = carboTarget
        
      case .carboCorrectTrainBaseData:
        let carboTrain = userDefaults.array(forKey: key.rawValue) as! [Float]
        dataDict[key.rawValue] = carboTrain
        
      case .sugarCorrectTargetBaseData:
        let sugarTarget = userDefaults.array(forKey: key.rawValue) as! [Float]
        dataDict[key.rawValue] = sugarTarget
        
      case .sugarCorrectTrainBaseData:
        let sugarTrain = userDefaults.array(forKey: key.rawValue) as! [Float]
        dataDict[key.rawValue] = sugarTrain
        
        
      case .correctCarboByInsulinWeights:
        
        let carboWeights = userDefaults.array(forKey: key.rawValue) as! [Float]
        dataDict[key.rawValue] = carboWeights
        
      case .correctSugarByInsulinWeights:
        
        let sugarWeights = userDefaults.array(forKey: key.rawValue) as! [Float]
        dataDict[key.rawValue] = sugarWeights
        
      case .higherSugarLevel:
        
        let higherLevel = userDefaults.float(forKey: key.rawValue)
        dataDict[key.rawValue] = higherLevel
        
      case .lowSugarLevel:
        
        let lowLevel = userDefaults.float(forKey: key.rawValue)
        dataDict[key.rawValue] = lowLevel
        
      case .insulinSupplyValue:
        
        let insulinSupplyValue = userDefaults.float(forKey: key.rawValue)
        dataDict[key.rawValue] = insulinSupplyValue
        
      
      }
    }
    
    return dataDict
    

  }
  
  
}
