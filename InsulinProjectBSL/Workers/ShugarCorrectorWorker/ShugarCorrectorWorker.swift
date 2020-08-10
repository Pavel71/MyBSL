//
//  ShugarCorrectorWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 21.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// Класс отвечает за корректировку сахара инсулином! Без Продуктов питания

// Нужно повнимательней поработать с этим классом! Работа будет не простая но все получится!

// Надо решить какую задачу? Я хер знает! Человек вводит данные по сахару в mgdl 140 мне нужно понять какой это сахар чтобы заполнить правельно SugarViewModelCell в норме или нет! Соотвесвенно я его конвертирую в mmol
// По большому случаю мне нужно просто менять mgdl сахар в mmol

final class ShugarCorrectorWorker {
  
  
  let userDefaultsWorker   : UserDefaultsWorker!
  
  // Эти значения будут браться из Настроек пользователя!
  private var bottomShugarLevel: Float {
    
    userDefaultsWorker.getSugarLevel(sugarLevelKey: .lowSugarLevel)

  }
  private var higherShuagrLevel: Float {
    userDefaultsWorker.getSugarLevel(sugarLevelKey: .higherSugarLevel)
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


  
}
