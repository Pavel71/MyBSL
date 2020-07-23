//
//  UserDefaultsEnum.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation



// MARK: User Defaults Enums

enum UserDefaultsKey: String,CaseIterable {
  
  case lowSugarLevel
  case higherSugarLevel
  
  case correctSugarByInsulinWeights  // Weights
  case correctCarboByInsulinWeights  // Weights
  
  
  case sugarCorrectTrainBaseData
  case sugarCorrectTargetBaseData
  
  case carboCorrectTrainBaseData
  case carboCorrectTargetBaseData
  
  
  case insulinSupplyValue
  
  case sugarMetric
  
}
