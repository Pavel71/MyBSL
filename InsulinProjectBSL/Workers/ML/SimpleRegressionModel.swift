//
//  SimpleRegressionModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 06.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import MachineLearningKit
import Upsurge


class SimpleRegresiionModel {
  
  let linearModel = SimpleLinearRegression()
  
  // Потом когда веса установленные можно сохранять их в юзерДефолтс
  private var weights:(Float,Float) = (0,0)
  
  
  func getWeights() -> (Float,Float) {
    return weights
  }
  
}

// MARK: Predict


extension SimpleRegresiionModel {
  
  // Predict
  func getPredict(test:[Float]) -> [Float] {
    
    return test.map(predict)
    
  }
  
  private func predict(test: Float) -> Float {
    return linearModel.predict(weights.0, intercept: weights.1, inputValue: test)
  }
  
 
}

// MARK: Train

extension SimpleRegresiionModel {
  
  func trainModelAndSetNewWeights(train:[Float],target:[Float]){
     
     weights = try! linearModel.train(train, output: target)
    
    // Посмотреть на ошибку!
    let rss = linearModel.RSS(train, output: target, slope: weights.0, intercept: weights.1)
    print("Rss",rss)
     
   }
}


