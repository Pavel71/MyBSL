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
  

  private let simpleRegressionModel:SimpleRegresiionModel
  
  
  
  init(typeWeights: UserDefaultsKey) {
    self.simpleRegressionModel = SimpleRegresiionModel(typeWeights: typeWeights)
  }
  
  
  
//  var categoryLabelOrdinalDict:[String: Int] = [:]
  
  func getPredict(testData: [Float]) -> [Float] {
    
    let predicts = simpleRegressionModel.getPredict(test: testData)
    return predicts
  }
  
  func trainModelAndSetWeights(trainData:[Float],target:[Float]) {
    simpleRegressionModel.trainModelAndSetNewWeights(train: trainData, target: target)
  }
  
  func getRegressionWeights() -> (Float,Float) {
    return simpleRegressionModel.getWeights()
  }
  
  


  
}

