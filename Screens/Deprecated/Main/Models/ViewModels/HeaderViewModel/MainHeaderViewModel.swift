//
//  MainHeaderViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 08.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


// Header

struct MainHeaderViewModel: MainTableViewHeaderCellable {
  

  
  var lastInjectionValue: Float
  
  var lastTimeInjectionValue: Date?
  
  var lastShugarValue: Float
  
  var insulinSupplyInPanValue: Float
  
  init(lastInjectionValue: Float,lastTimeInjectionValue: Date?,lastShugarValue: Float,insulinSupplyInPanValue: Float) {
    
    self.lastInjectionValue = lastInjectionValue
    self.lastTimeInjectionValue = lastTimeInjectionValue
    self.lastShugarValue = lastShugarValue
    self.insulinSupplyInPanValue = insulinSupplyInPanValue

  }
  
  
}
