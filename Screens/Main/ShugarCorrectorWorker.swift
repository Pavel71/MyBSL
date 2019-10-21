//
//  ShugarCorrectorWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 21.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// Класс отвечает за корректировку сахара инсулином! Без Продуктов питания

class ShugarCorrectorWorker {
  
  // Эти значения будут браться из Настроек пользователя!
  private var bottomShugarLevel: Float
  private var higherShuagrLevel: Float
  
  var isNeedCorrectShugarByInsulin: Bool = false
  private var isUserHaveToSetData: Bool = true
  
  var correctionInsulinByShugar: Float?

  
  // Singleton
  
  static let shared: ShugarCorrectorWorker = {
    
    // Эти показатели будут браться из Настроек
    let bottomLevel:Float = 4.5
    let higherLevel:Float = 7.5
    
    let shugarCorrectorClass = ShugarCorrectorWorker(bottomShugarLevel: bottomLevel,higherShuagrLevel:higherLevel)
    
    return shugarCorrectorClass
    
  }()
  
  init(bottomShugarLevel: Float,higherShuagrLevel: Float) {
    self.bottomShugarLevel = bottomShugarLevel
    self.higherShuagrLevel = higherShuagrLevel
  }
  
  
  func setInsulinCorrectionByShugar(shugarValue: String) {
    
    let valueFloat = (shugarValue as NSString).floatValue

    isNeedCorrectShugarByInsulin =  valueFloat > higherShuagrLevel || valueFloat < bottomShugarLevel
    
    if isNeedCorrectShugarByInsulin {
      
      // Здесь должен быть еще 1 флаг ждем данные от пользователя? или считаем сами
      if isUserHaveToSetData {
        // Пользователь сам введет данные пока это флаг не измениться а измениться он после 10 обдеов например
        correctionInsulinByShugar = nil
        
      } else {
        
        // Здесь будет идти автоматический расчет дозировки инсулина
        print("Считаем обеды по формуле")
        
      }

    } else {
      correctionInsulinByShugar = 0
    }
    
    
    
  }
  
}
