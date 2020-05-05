//
//  SaveService.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation
import Firebase


// Класс отвечает за сохранение данных в FIrebase

final class SaveService {
  
  
  static func saveUserDataToFirebase(completion: @escaping ((Result<Bool,NetworkFirebaseError>)) -> Void) {
    
    
    // 1. Нужно достать все данные из userDefaults
    
    let userDefDict = fetchAllDataFromUserDefaults()
    
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    
    Firestore.firestore().collection(FirebaseKeyPath.users.rawValue).document(currentUserID).collection(FirebaseKeyPath.Users.userDefaultsData.rawValue).document(currentUserID).setData(userDefDict) { (error) in
      
      if error != nil {
        completion(.failure(.saveUserDefaultsDataError))
      }
      
      completion(.success(true))
      
    }
    
  }
  
  
  private static func fetchAllDataFromUserDefaults() -> [String: Any] {
    
    let userDefaults = UserDefaults.standard
    
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
