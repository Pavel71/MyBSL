//
//  ShugarCorrectorWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 21.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// Класс отвечает за корректировку сахара инсулином! Без Продуктов питания

final class ShugarCorrectorWorker {
  
  
  let userDefaultsWorker: UserDefaultsWorker!
  
  // Эти значения будут браться из Настроек пользователя!
  private var bottomShugarLevel: Float {
    
    userDefaultsWorker.getSugarLevel(sugarLevelKey: .lowSugarLevel)
//    userDefaults.float(forKey: UserDefaultsKey.lowSugarLevel.rawValue)
  }
  private var higherShuagrLevel: Float {
    userDefaultsWorker.getSugarLevel(sugarLevelKey: .higherSugarLevel)
//    userDefaults.float(forKey: UserDefaultsKey.higherSugarLevel.rawValue)
  }
  
  var optimalSugarLevel : Double {
     Double(bottomShugarLevel + higherShuagrLevel) / 2
  }
  

  
  
  var isNeedCorrectShugarByInsulin: Bool = false
  // Этот бул для того надо ли показать текстфилд или нет
  private var isUserHaveToSetData: Bool = true
  
  var correctionInsulinByShugar: Float? 


  
  init() {
    let locator = ServiceLocator.shared
    userDefaultsWorker = locator.getService()
  }
//

  
  func getCorrectInsulinBySugarPosition(sugar: Float) -> CorrectInsulinPosition {
    
    let isNeedCorrect = isPreviosDinnerFalledCompansation(shugarValue: sugar)
    return isNeedCorrect ? .needCorrect : .dontCorrect
  }
  
  func isPreviosDinnerFalledCompansation(shugarValue: Float) -> Bool {

    if shugarValue == 0 {
      return false
    } else {
      return shugarValue > higherShuagrLevel || shugarValue < bottomShugarLevel
    }
  }
  
  func getWayCorrectPosition(sugar: Float) -> CorrectInsulinPosition {
    
    if sugar < bottomShugarLevel && sugar > 0 {
      return .correctUp
      
    } else if sugar > higherShuagrLevel {
      return .correctDown
    } else if sugar == -1 {
      return .progress
    }

    return .dontCorrect
  }
  
  // MARK: Prepare Data to Sugar Train
  
  func getSugasrTrainData(currentSugar: Double) -> Float {
    
    return abs(optimalSugarLevel - currentSugar.roundToDecimal(2)).toFloat()
  }

  
  
//  func getInsulinCorrectionByShugar(shugarValue: Float) -> Float? {
//    // Если 0 то значит мы сетим первый раз с viewModel!
////    guard shugarValue != 0 else {return}
//    
////    let valueFloat = (shugarValue as NSString).floatValue
//
//    isNeedCorrectShugarByInsulin =  isPreviosDinnerFalledCompansation(shugarValue: shugarValue)
//    
//    
//    if isNeedCorrectShugarByInsulin {
//      
//      // Здесь должен быть еще 1 флаг ждем данные от пользователя? или считаем сами
//      if isUserHaveToSetData {
//        // Пользователь сам введет данные пока это флаг не измениться а измениться он после 10 обдеов например
//        correctionInsulinByShugar = nil
//        
//      } else {
//        
//        // Здесь будет идти автоматический расчет дозировки инсулина
//        print("Считаем Корректировку сахара с помощью Алгоритма")
//        
//      }
//
//    } else {
//      correctionInsulinByShugar = 0
//    }
//    
//    return correctionInsulinByShugar
//    
//    
//    
//  }
  
}
