//
//  RidgeRegressionModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 06.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import MachineLearningKit
import Upsurge


class RidgeRegressionModel {
  
}

// MARK: Predict

extension RidgeRegressionModel {
  
  static  func getPredictFromRidgeRegressionModel(trainRegression:[[Float]],target:[Float],testRidge:[[Float]]) {
    
    
    
    let ridgeModel = RidgeRegression()
    
    // 2 признака + 1 интерсептор
    let initial_weights = Matrix<Float>(rows: 3, columns: 1, elements: [0.10354779,0.11, -0.21002007])
    
    let weights = try! ridgeModel.train(trainRegression, output: target, initialWeights: initial_weights, stepSize: Float(1e-8), l2Penalty: 0.1,maxIterations: 1000)
    
    print("Ridge Weights",weights)
    
    let rss = try! ridgeModel.RSS(trainRegression, observation: target)
    print("Ridge RSS",rss)
    
    
    for (index, _) in testRidge.enumerated() {
      
      let carbo = testRidge[0][index]
      let category = testRidge[1][index]
      let interceptor = Float(1.0)
      print(carbo,category)
      
      let predict = ridgeModel.predict([carbo,category,interceptor], yourWeights: weights.elements)
      print("Predict for 2 future RidgeRegressor",predict)
    }
    
//    getLossoPredict(trainRegression: trainRegression, target: target, testRidge: testRidge)
//
//    getPolyPredict(trainRegression: trainRegression, target: target, testRidge: testRidge)
    
    
  }
  
  
  static private func getLossoPredict(trainRegression:[[Float]],target:[Float],testRidge:[[Float]]) {
    let lassoRegression = LassoRegression()
    
    // 2 признака + 1 интерсептор
    let initial_weights = Matrix<Float>(rows: 3, columns: 1, elements: [0.10354779,0.1, -0.21002007])
    
    let weights = try! lassoRegression.train(trainRegression, output: target, initialWeights: initial_weights, l1Penalty: 0.08, tolerance: 0.001)
    
    print("Lasso Weights",weights)
    
    let rss = try! lassoRegression.RSS(trainRegression, observation: target)
    print("Lasso RSS",rss)
    
    
    
    for (index, _) in testRidge.enumerated() {
      
      let carbo = testRidge[0][index]
      let category = testRidge[1][index]
      let interceptor = Float(1.0)
      
      
      let predict = lassoRegression.predict([carbo,category,interceptor], yourWeights: weights.elements)
      print(carbo,category)
      print("Predict for 2 future LassoRegeression",predict)
    }
  }
  
  
  static private func getPolyPredict(trainRegression:[[Float]],target:[Float],testRidge:[[Float]]) {
    let pollyRegression = PolynomialLinearRegression()
    
    // 2 признака + 1 интерсептор
    let initial_weights = Matrix<Float>(rows: 3, columns: 1, elements: [0.10354779,0.0, -0.21002007])
    
    let weights = try! pollyRegression.train(trainRegression, output: target, initialWeights: initial_weights, stepSize: Float(4e-12), tolerance: Float(1e9))
    
    print("Polly Weights",weights)
    
    let rss = try! pollyRegression.RSS(trainRegression, observation: target)
    print("Polly RSS",rss)
    
    
    for (index, _) in testRidge.enumerated() {
      
      let carbo = testRidge[0][index]
      let category = testRidge[1][index]
      let interceptor = Float(1.0)
      
      
      let predict = pollyRegression.predict([carbo,category,interceptor], yourWeights: weights.elements)
      print(carbo,category)
      print("Predict for 2 future PollyRegression",predict)
    }
  }
  
}
