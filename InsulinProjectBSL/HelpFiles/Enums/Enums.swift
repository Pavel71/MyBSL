//
//  Enums.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 30/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

enum Segment: Int {
  case allProducts
  case favorits
  case meals
}

enum State {
  case closed
  case open
  
  var opposite: State {
    switch self {
    case .open: return .closed
    case .closed: return .open
    }
  }
}

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
  
}


