//
//  DateWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


class DateWorker {
  
  private let dateFormatter:DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd-MM-yy HH:mm"
    return df
  }()
  
  static let shared: DateWorker = {
    let cls = DateWorker()
    return cls
  }()
  
  func getTimeString(date: Date?) -> String {
    
    if let date = date {
      return dateFormatter.string(from: date)
    }
    return ""
    
  }
  
}