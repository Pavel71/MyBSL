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
  
  func getCurrentChurtEntry(data: ChartModable) -> ChartDataEntry {
    
    switch data.dataCase {
    case .sugarData:
      let data = data as! ChartSugarModel
      return getSugarChartEntry(data: data)
    case .mealData:
      let data = data as! ChartMealModel
      return getMealChartEntryData(data: data)
      
    case .correctInsulinData:
      let data = data as! ChartCorrectInsulinModel
      return getCorrectInsulinChartEntryData(data: data)
    }
    
  }

  
  private func configureDataInChartEntry(data: Any) {
    
  }
}
  
  
  

// MARK: Prepare Chart Entry Model

extension ChartWorker {
  
  private func getSugarChartEntry(data: ChartSugarModel) -> ChartDataEntry {
      let time = convertTime(time: data.time)
      return ChartDataEntry(x: time, y: data.sugar)
    }
    
    private func getMealChartEntryData(data: ChartMealModel) -> ChartDataEntry {
      
      let time = convertTime(time: data.time)
      // здесь кстати также может быть и коррекционный инсулин!
      let mealData = [
        "Углеводы": data.totalCarbo,
        "Инсулин": data.totalInsulin
      ]
      
      return ChartDataEntry(
        x: time,
        y: data.sugar,
        icon: #imageLiteral(resourceName: "food"),
        data: mealData)
      
    }
    
    private func getCorrectInsulinChartEntryData(data: ChartCorrectInsulinModel) -> ChartDataEntry {
      let time = convertTime(time: data.time)
      let correctData = [
        "Корр. инсулин": data.correctInsulin
      ]
      return ChartDataEntry(
        x: time,
        y: data.sugar,
        icon: #imageLiteral(resourceName: "anesthesia"),
        data: correctData)
    }
  
}
  

// MARK: Work with Time

extension ChartWorker {
  
  private func convertTime(time: Date) -> Double {
     print("Convert time")
     // Короче задача такая нам приходит время нужно конверитровать его в Double с сохраннеием минут в формате 10:30
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "hh:mm"
    
     // Короче идея простая вычленять только часы и передавать их! Точное время будет всегда известно так как оно лежит в данных а не на плоскоксти!
     
     let timeString = dateFormatter.string(from: time)
    print(timeString,"Time string")
     let minutes = Double(timeString.dropFirst(3))! / 100
     let hour  = Double(timeString.dropLast(3))!
     
     let double = hour + minutes
     
     print("Return Double",double)
     return double
     
   }
  
}
