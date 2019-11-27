//
//  ChartWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


import Foundation
import Charts


// Класс Отвечает за обработку данных для графика

class ChartWorker {
  
  func getEntryies(data: [ChartModable]) -> [ChartDataEntry] {

    return data.map(getCurrentChurtEntry)
  }
  
  private func getCurrentChurtEntry(data: ChartModable) -> ChartDataEntry {
    
    return getChartEntry(data: data)
    
//    switch data.dataCase {
//    case .sugarData:
//      let data = data as! ChartSugarModel
//      return getSugarChartEntry(data: data)
//    case .mealData:
//      let data = data as! ChartMealModel
//      return getMealChartEntryData(data: data)
//
//    case .correctInsulinData:
//      let data = data as! ChartCorrectInsulinModel
//      return getCorrectInsulinChartEntryData(data: data)
//    }
    
  }

  
  private func configureDataInChartEntry(data: Any) {
    
  }
}
  
  
  

// MARK: Prepare Chart Entry Model

extension ChartWorker {
  
  private func getChartEntry(data: ChartModable) -> ChartDataEntry {
    let time  = convertTime(time: data.time)
    
    let entry = ChartDataEntry(
    x    : time,
    y    : data.sugar,
    icon : getImage(imageCase: data.dataCase),
    data : getData(dataCase: data.dataCase, insulin: data.insulin, carbo: data.carbo )
    )

    
    return entry
  }
  

  
//  private func getSugarChartEntry(data: ChartSugarModel) -> ChartDataEntry {
//      let time = convertTime(time: data.time)
//      return ChartDataEntry(x: time, y: data.sugar)
//    }
//
//    private func getMealChartEntryData(data: ChartMealModel) -> ChartDataEntry {
//
//      let time = convertTime(time: data.time)
//      // здесь кстати также может быть и коррекционный инсулин!
//      let mealData = [
//        "Углеводы": data.totalCarbo,
//        "Инсулин": data.totalInsulin
//      ]
//
//      return ChartDataEntry(
//        x: time,
//        y: data.sugar,
//        icon: #imageLiteral(resourceName: "food"),
//        data: mealData)
//
//    }
//
//    private func getCorrectInsulinChartEntryData(data: ChartCorrectInsulinModel) -> ChartDataEntry {
//      let time = convertTime(time: data.time)
//      let correctData = [
//        "Корр. инсулин": data.correctInsulin
//      ]
//      return ChartDataEntry(
//        x: time,
//        y: data.sugar,
//        icon: #imageLiteral(resourceName: "anesthesia"),
//        data: correctData)
//    }
  
}


  

// MARK: Work with Time

extension ChartWorker {
  
  private func convertTime(time: Date) -> Double {

     
    let timeString = DateWorker.shared.getOnlyClock(date: time)
    
    let minutes = Double(timeString.dropFirst(3))! / 100
    let hour  = Double(timeString.dropLast(3))!
     
     let double = hour + minutes
     
     print("Return Double",double)
     return double
     
   }
  
}

// MARK: Work with Image

extension ChartWorker {
  
    private func getImage(imageCase: ChartDataCase) -> NSUIImage? {

      switch imageCase {
        case .correctInsulinData:
          return #imageLiteral(resourceName: "anesthesia")
        case .mealData:
          return #imageLiteral(resourceName: "food")
        case.sugarData:
        return nil
      }
      
  }
  
}

// MARK: Work with Data

extension ChartWorker {
  
  private func getData(
    dataCase : ChartDataCase,
    insulin  : Double?,
    carbo    : Double?
  ) -> [String: Double]? {

      switch dataCase {
        case .correctInsulinData:
          return [ChartDataKey.insulin.rawValue : insulin!]
        case .mealData:
          return [
            ChartDataKey.insulin.rawValue : insulin!,
            ChartDataKey.carbos.rawValue  : carbo!
        ]
        case.sugarData:
        return nil
      }
      
  }
  
}