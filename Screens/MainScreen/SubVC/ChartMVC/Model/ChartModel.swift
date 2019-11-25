//
//  ChartModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//



import Foundation


enum ChartDataCase {
  case sugarData
  case correctInsulinData
  case mealData
}

protocol ChartModable {
  
  var dataCase: ChartDataCase { get set }
  var sugar: Double {get set}
  var time: Date {get set}
  
}


// Или сделать что она может содержать 3 модели

// Only Sugar
struct ChartSugarModel:ChartModable {
  
  var sugar: Double
  var time: Date
  var dataCase: ChartDataCase

}


// Meal Chart
struct ChartMealModel: ChartModable {
  
  var dataCase: ChartDataCase

  var sugar: Double
  var time: Date
  
  var totalCarbo: Double
  var totalInsulin: Double
  
}

// COrrectInsulinChart

struct ChartCorrectInsulinModel: ChartModable{
  var dataCase: ChartDataCase
  
  var sugar: Double
  
  var time: Date
  
  var correctInsulin: Double
}






//class DummyData {
//  
//  // Функция вернет разные модельки
//  
//  static func getDummyModel() -> [ChartModable] {
//    
//    
//    let meal1 = ChartMealModel(
//      dataCase: .mealData,
//      sugar: 5.7,
//      time: Date(timeIntervalSince1970: 1574674427),
//      totalCarbo: 35.0,
//      totalInsulin: 3.5)
//    
//    let shugar1 = ChartSugarModel(
//      sugar: 6.5,
//      time: Date(timeIntervalSince1970: 1574678027),
//      dataCase: .sugarData)
//    
//    let meal2 = ChartMealModel(
//    dataCase: .mealData,
//    sugar: 7.7,
//    time: Date(timeIntervalSince1970: 1574681627),
//    totalCarbo: 25.0,
//    totalInsulin: 2.5)
//    
//    let correctInsulinModel = ChartCorrectInsulinModel(
//      dataCase: .correctInsulinData,
//      sugar: 12.0,
//      time: Date(timeIntervalSince1970: 1574685227),
//      correctInsulin: 0.5)
//    
//    let shugar2 = ChartSugarModel(
//         sugar: 4.5,
//         time: Date(timeIntervalSince1970: 1574688827),
//         dataCase: .sugarData)
//    
//    return [shugar1,meal2,correctInsulinModel,shugar2,meal1]
//    
//  }
//}
