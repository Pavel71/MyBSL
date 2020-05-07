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
  let userDefaultsWorker: UserDefaultsWorker!
  
  private var weights:(Float,Float)  = (0,0)
  
  
  init() {
    
    let locator = ServiceLocator.shared
    userDefaultsWorker = locator.getService()
    
    
  }
  
  
  // Test Period
  private var testInsulinByFoodWeights:(Float,Float) = (0.081395335, 0.2558142)
  
  // Newer 0.081395335, 0.2558142
  // New (0.081395335, 0.2558142)
  // Old (0.060631208), (0.17524958)
  
  private var testInsulinByCorrectionSugarWeights: (Float,Float) = (0.13607857, -0.10890615)
  
  // Newer 0.13607857, -0.10890615
  // New (0.14666663, -0.223333)
  
  // Old - 0.14666663, -1.1399995
  
  // Когда мы жмем получить вес мы должны достать его из юзер дефолтса! Когда сохраняем вес мы должны сохранить их в UserDefaults
  // Получается нам сюда нужно передать только ключ по которому мы получим веса!
  

  func getWeights() -> (Float,Float) {
    return weights
  }
  
  func setWeights(weights:(Float,Float)) {
    self.weights = weights
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
  
  func trainModelAndSetNewWeights(train:[Float],target:[Float]) -> (Float,Float){
    
    weights = linearModel.train(train, output: target)

    // Посмотреть на ошибку!
    let rss = linearModel.RSS(train, output: target, slope: weights.0, intercept: weights.1)
    print("Rss",rss)
    
    return weights
    
     
   }
  
  
//  private func saveWeightsinUserDefaults(weights:(Float,Float), key:String) {
//
//    userDefaults.set([weights.0,weights.1], forKey: key)
//  }
//
//  private func getWeightsFromUD(userDefKey: UserDefaultsKey) -> [Float] {
//
//    return userDefaults.array(forKey: userDefKey.rawValue) as! [Float]
//
//  }
  
}


