//
//  MLworker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 30.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import MachineLearningKit
import Upsurge
import CoreML


//enum KeyWeights: String {
//   case correctionSugar, insulinByFood
// }

// Class отвечает за обработку данных и получение прогноза инсулина

class MLWorker {
  
  var userDefaultsWorker            : UserDefaultsWorker!
  private let simpleRegressionModel : SimpleRegresiionModel
  
  var typeWeights                   : UserDefaultsKey
  
  
  init(typeWeights: UserDefaultsKey) {
    
    let locator                = ServiceLocator.shared
    userDefaultsWorker         = locator.getService()
    self.typeWeights           = typeWeights
    self.simpleRegressionModel = SimpleRegresiionModel()
  }
  
  
  
//  var categoryLabelOrdinalDict:[String: Int] = [:]
  
  func getPredict(testData: [Float]) -> [Float] {

    
    let weights = userDefaultsWorker.getArrayData(typeDataKey: typeWeights)
    simpleRegressionModel.setWeights(weights: (weights[0],weights[1]))
    
    let predicts = simpleRegressionModel.getPredict(test: testData)
    return predicts
  }
  
  func trainModelAndSetWeights(trainData:[Float],target:[Float]) {
    
    let weights = simpleRegressionModel.trainModelAndSetNewWeights(train: trainData, target: target)
    let arrWeaights = [weights.0,weights.1]
    
    userDefaultsWorker.setWeights(weights: arrWeaights, key: typeWeights)

    
  }
  

  


  
}

