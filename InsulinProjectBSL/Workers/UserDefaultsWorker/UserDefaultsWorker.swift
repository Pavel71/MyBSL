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
  
  func setDataToUserDefaults(userDefaultsNetwrokModel: UserDefaultsNetworkModel) {
    
    // Проверить это говно!
    
    setInsulinSupplyValue(insulinSupply: userDefaultsNetwrokModel.insulinSupplyValue)
    
    setWeights(weights: userDefaultsNetwrokModel.correctCarboByInsulinWeights, key: .correctCarboByInsulinWeights)
    setWeights(weights: userDefaultsNetwrokModel.correctSugarByInsulinWeights, key: .correctSugarByInsulinWeights)
    
    setArrayFloat(arr: userDefaultsNetwrokModel.carboCorrectTargetBaseData, key: .carboCorrectTargetBaseData)
    setArrayFloat(arr: userDefaultsNetwrokModel.carboCorrectTrainBaseData, key: .carboCorrectTrainBaseData)
    
    setArrayFloat(arr: userDefaultsNetwrokModel.sugarCorrectTrainBaseData, key: .sugarCorrectTrainBaseData)
    setArrayFloat(arr: userDefaultsNetwrokModel.sugarCorrectTargetBaseData, key: .sugarCorrectTargetBaseData)
    
    setSugarLevel(sugarLevel: userDefaultsNetwrokModel.lowSugarLevel, key: .lowSugarLevel)
    setSugarLevel(sugarLevel: userDefaultsNetwrokModel.higherSugarLevel, key: .higherSugarLevel)
    

    
  }
  
  func setInsulinSupplyValue(insulinSupply: Int) {
    userDefaults.set(insulinSupply, forKey: UserDefaultsKey.insulinSupplyValue.rawValue)

  }

  func setWeights(weights:[Float],key: UserDefaultsKey) {
    userDefaults.set(weights, forKey: key.rawValue)
  }
  
  func setArrayFloat(arr:[Float],key: UserDefaultsKey) {
    userDefaults.set(arr, forKey: key.rawValue)
  }
  
  func setSugarLevel(sugarLevel: Float,key: UserDefaultsKey) {
    userDefaults.set(sugarLevel, forKey: key.rawValue)

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
    userDefaults.array(forKey: typeDataKey.rawValue) as? [Float] ?? []
  }
  
  
  
  func getAllDataFromUserDefaults() -> [String: Any] {
    
    
    var dataDict = [String: Any]()
    
    UserDefaultsKey.allCases.forEach { (key) in
      switch key {
        
      case .carboCorrectTargetBaseData:
        let carboTarget = userDefaults.array(forKey: key.rawValue) as? [Float] ?? []
        dataDict[key.rawValue] = carboTarget
        
      case .carboCorrectTrainBaseData:
        let carboTrain = userDefaults.array(forKey: key.rawValue) as? [Float] ?? []
        dataDict[key.rawValue] = carboTrain
        
      case .sugarCorrectTargetBaseData:
        let sugarTarget = userDefaults.array(forKey: key.rawValue) as? [Float] ?? []
        dataDict[key.rawValue] = sugarTarget
        
      case .sugarCorrectTrainBaseData:
        let sugarTrain = userDefaults.array(forKey: key.rawValue) as? [Float] ?? []
        dataDict[key.rawValue] = sugarTrain
        
        
      case .correctCarboByInsulinWeights:
        
        let carboWeights = userDefaults.array(forKey: key.rawValue) as? [Float] ?? []
        dataDict[key.rawValue] = carboWeights
        
      case .correctSugarByInsulinWeights:
        
        let sugarWeights = userDefaults.array(forKey: key.rawValue) as? [Float] ?? []
        dataDict[key.rawValue] = sugarWeights
        
      case .higherSugarLevel:
        
        let higherLevel = userDefaults.float(forKey: key.rawValue)
        dataDict[key.rawValue] = higherLevel
        
      case .lowSugarLevel:
        
        let lowLevel = userDefaults.float(forKey: key.rawValue)
        dataDict[key.rawValue] = lowLevel
        
      case .insulinSupplyValue:
        
        let insulinSupplyValue = userDefaults.integer(forKey: key.rawValue)
        dataDict[key.rawValue] = insulinSupplyValue
        
      
      }
    }
    
    return dataDict
    

  }
  
  // MARK: Ckear ALl Data
  
  func clearAllData() {
    UserDefaultsKey.allCases.forEach{userDefaults.removeObject(forKey: $0.rawValue)}
  }
  
  
}
