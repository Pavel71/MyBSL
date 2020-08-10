//
//  SugarMetricConverter.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 29.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//


// Класс отвечает за преобразвоание сахаров из mgdl в mmol

import Foundation


class SugarMetricConverter {
  
  var userDefaultsWorker : UserDefaultsWorker!
  
  init() {
    userDefaultsWorker = ServiceLocator.shared.getService()
  }
  
  var metric : SugarMetric {
    userDefaultsWorker.getMetric()
  }
  
  
  func setMetric(metric: SugarMetric) {
    userDefaultsWorker.setSugarMetric(sugarMetric: metric, key: .sugarMetric)
  }
  
  func convertMmolToMgdl(mmolSugar : Double) -> Double {
    (mmolSugar * 18).roundToDecimal(0)
  }
  
  func convertMgdltoMmol(mgdlSugar: Double) -> Double {
    (mgdlSugar / 18).roundToDecimal(2)
  }
  
  func convertMgdlSugarStringToMmolSugarString(mgdlSugarString: String) -> String {
    
    let mgdlSugarDouble = (mgdlSugarString as NSString).doubleValue
    let mmolSugarDouble = convertMgdltoMmol(mgdlSugar: mgdlSugarDouble)
    return String(mmolSugarDouble)
    
  }
  
  func convertMmolSugarStringToMgdlSugarString(mmolSugarString: String) -> String {
    
    let mmolSugarDouble = (mmolSugarString as NSString).doubleValue
    let mgdlSugarDouble = convertMmolToMgdl(mmolSugar: mmolSugarDouble)
    return String(mgdlSugarDouble)
    
  }
  
  
//  func convertatingSugar(sugar : Double) -> Double {
//    
//    var sugarConverted: Double
//    switch metric {
//    case .mmoll:
//      sugarConverted =  sugar * 18
//    case .mgdl:
//      sugarConverted =  sugar / 18
//    }
//    return sugarConverted.roundToDecimal(2)
//  }
//  
  func isMgdlMetric() -> Bool {
    metric == .mgdl
  }
  
}
