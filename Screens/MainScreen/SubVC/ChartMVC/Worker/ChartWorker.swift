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

enum ChartDataKey: String {
   case insulin = "Инсулин"
   case carbos  = "Углеводы"
   case compansationObjectId  = "mealId"
 }

class ChartWorker {
  
 
  
  func getEntryies(data: [ChartModable]) -> [ChartDataEntry] {
    return data.map(prepareEntry)
  }
  
  private func prepareEntry(data: ChartModable) -> ChartDataEntry {
    
    return getChartEntry(data: data)

  }

}
  
  
  

// MARK: Prepare Chart Entry Model

extension ChartWorker {
  
  private func getChartEntry(data: ChartModable) -> ChartDataEntry {
    
    let time  = convertTime(time: data.time)
    
    let dataObject = getData(compansationObjectId  : data.compansationObjectId)
    
    let entry = ChartDataEntry(
      x    : time,
      y    : data.sugar,
      icon : getImage(data: data),
      data : dataObject
    )
    
//    getImage(data: data)

    return entry
  }
  
  
}


  

// MARK: Work with Time

extension ChartWorker {
  
  private func convertTime(time: Date) -> Double {

     
    let timeString = DateWorker.shared.getOnlyClock(date: time)
    
    let minutes = Double(timeString.dropFirst(3))! / 100
    let hour  = Double(timeString.dropLast(3))!
     
     let double = hour + minutes
     
     
     return double
     
   }
  
}

// MARK: Work with Image

extension ChartWorker {
  
    private func getImage(data: ChartModable) -> NSUIImage? {
      
      
      switch data.dataCase {
        case .correctInsulinData:
          return #imageLiteral(resourceName: "anesthesia")
        case .mealData:
          return #imageLiteral(resourceName: "food")
        case .correctCarboData:
          return #imageLiteral(resourceName: "candy")
        case.sugarData:
          return nil
      }
      
  }
  
}

// MARK: Work with Data

extension ChartWorker {
  
  private func getData(compansationObjectId   : String?) -> [String: Any]? {
    
    guard compansationObjectId != nil else {return nil}
    
    // Нам нужно вернуть только Id Objecta 
    return [
        ChartDataKey.compansationObjectId.rawValue  : compansationObjectId!
    ]


      
  }
  
}
