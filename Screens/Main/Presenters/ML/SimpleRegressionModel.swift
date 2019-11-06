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
  
  
  
  
  
}

// MARK: Predict


extension SimpleRegresiionModel {
  
  static  func getPredictFromSimpleModel(train:[Float],target:[Float],test:[Float]) {
     let simpleLiniear =  SimpleLinearRegression()
     
     // Можно поработать с стохастическим спуском
     let weights = try! simpleLiniear.train(train, output: target)
     
     print("weights",weights)
     
     
     for pred in test {
       let predict = simpleLiniear.predict(weights.0, intercept: weights.1, inputValue: pred)
       print("Simple Linear Predict",predict)
     }
     
     
     
     let rss = simpleLiniear.RSS(train, output: target, slope: weights.0, intercept: weights.1)
     print("RSS Simple",rss)
   }
}


