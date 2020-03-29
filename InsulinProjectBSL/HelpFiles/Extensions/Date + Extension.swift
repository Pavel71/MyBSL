//
//  Date + Extension.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.03.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
  
  func dayBefore() -> Date {
      return Calendar.current.date(byAdding: .day, value: -1, to: self)!
  }
  func dayAfter() -> Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: self)!
  }
  
  func month() -> Int {
    
    return Calendar.current.component(.month, from: self)
  }
  
  
  func onlyDate() -> Date? {
         
    let calender = Calendar.current
    var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
    dateComponents.timeZone = NSTimeZone.system
    return calender.date(from: dateComponents)
         
    }
  
  func compareDate(with date : Date) -> Bool {
    let order = NSCalendar.current.compare(self, to: date, toGranularity: .hour)
      switch order {
      case .orderedSame:
          return true
      default:
          return false
      }
  }
}
