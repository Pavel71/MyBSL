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
  
  
  // Test Period
  private var testInsulinByFoodWeights = (Float(0.060631208), Float(0.17524958))
  private var testInsulinByCorrectionSugarWeights = (Float(0.14666663), Float(-1.1399995))
  
  // Когда мы жмем получить вес мы должны достать его из юзер дефолтса! Когда сохраняем вес мы должны сохранить их в UserDefaults
  // Получается нам сюда нужно передать только ключ по которому мы получим веса!
  private var weights:(Float,Float) {
    
    set {
      
      switch typeWeights {
        case .correctionSugar:
          saveWeightsinUserDefaults(weights: newValue, key: KeyWeights.correctionSugar.rawValue)
        case.insulinByFood:
          saveWeightsinUserDefaults(weights: newValue, key: KeyWeights.insulinByFood.rawValue)
      }
      
    }
    
    get {
      // Так тут будет сделанна подгрузка из Юзер дефолтса
      switch typeWeights {
        case .correctionSugar:
          // Достань из юзердефолтса
          return testInsulinByCorrectionSugarWeights
        case .insulinByFood:
          return testInsulinByFoodWeights
    
      }
    }
  }
  
  
  var typeWeights:KeyWeights
  
  init(typeWeights: KeyWeights) {
    self.typeWeights = typeWeights
  }
  
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
  
  
  private func saveWeightsinUserDefaults(weights:(Float,Float), key:String) {
    let userDefault = UserDefaults.standard
    
    userDefault.set([weights.0,weights.1], forKey: key)
  }
}


