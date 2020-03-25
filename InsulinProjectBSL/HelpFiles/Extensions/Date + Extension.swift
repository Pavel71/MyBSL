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
}
