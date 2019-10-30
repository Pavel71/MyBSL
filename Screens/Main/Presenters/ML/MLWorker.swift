//
//  MLworker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 30.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import CoreML
//import CreateML


// Class отвечает за обработку данных и получение прогноза инсулина

class MLWorker {
  
  
  // Нам нужно 1вое это trainData
  // нам нужно testData
  
  static func getPredictInsulin(data:[DinnerViewModel]) {
    
    // Пока валдиацию не делаю из - за нехватки времени
    
    // Я понимаю что testData будут отвалидированны и меть нужные поля заполненными
    guard let testData = data.last else {return}
    let trainData = Array(data.dropLast())
    
    print(testData)
    
  }
  
  
  static func getMLData() -> [String: MLDataValueConvertible] {
    
  }
  
  
  
  
  
}
