//
//  HeaderCellWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


// Класс отвечает за логику обработки viewmodel в header

class HeaderCellWorker {
  
  
  private let supplyInsulinValue: Float = 0
  
  static let shared:HeaderCellWorker = {
    let cls = HeaderCellWorker()
    return cls
  }()
  
  
  func getSupplyValue() -> Float {
    return supplyInsulinValue
  }
  
  
}
