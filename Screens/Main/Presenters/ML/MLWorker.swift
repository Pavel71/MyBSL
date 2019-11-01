//
//  MLworker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 30.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import CoreML
import MachineLearningKit




// Class отвечает за обработку данных и получение прогноза инсулина

class MLWorker {
  
  
  // Нам нужно 1вое это trainData
  // нам нужно testData
  
  @available(iOS 13.0, *)
  static func getPredictInsulin(data:[DinnerViewModel]) -> [Double] {
    
    // Пока валдиацию не делаю из - за нехватки времени
    
    // Я понимаю что testData будут отвалидированны и меть нужные поля заполненными
    guard let testData = data.last else {return []}
    let trainData = Array(data.dropLast())
    
    print(testData)
    
    let test = testData.productListInDinnerViewModel.productsData.map{Double($0.carboInPortion)}
    
    
    
    
//    let dataManager = MLDataManager
//    dataManager
//    NeuralNetwork
    
    
    // Simple linear Model
    
    let train = getTrainDataCarbo(data: data)
    let target = getTargetDataInsulin(data: data)
    
    print("Train and Targt",train,target,train.count,target.count)
    
    let simpleLiniear =  SimpleLinearRegression()
    let weights = try! simpleLiniear.train(train, output: target)
    
    print("weights",weights)
    let predict = simpleLiniear.predict(weights.0, intercept: weights.1, inputValue: Float(test[0]))
    print("Simple Linear Predict",predict)
    
    // Это ошибка но уже видно что работать будет просто превосходно это то что мне нужно! Я могу на бэке обучать веса и сохранять их для модели потом в момент предикта просто их подставлять и через 2 обеда опять обновлять веса-это все можно будет хранить в юзердефолтсах!
    
    let rss = simpleLiniear.RSS(train, output: target, slope: weights.0, intercept: weights.1)
    print("RSS",rss)
    
    
    // XGB
    
    let xgbModel = XGBModel()

    for carbo in test {
      let pred = try? xgbModel.prediction(f0: carbo)
      print("XGB predict",pred?.target)
    }
    
    
    
//    /coremlc: compiler error:  Encountered an error while compiling a neural network model: Espresso exception: "Unsupported configuration": inner product needs 2 inputs for gradients; given 1
    
//    if #available(iOS 13.0, *) {
//      print("Multy Array",try? MLMultiArray(dataCarbo))
//    }
    //Failure verifying inputs.
    // Модель!
    if #available(iOS 13.0, *) {
//      let model = SimpleInsulinUpdatable()
//      let prediction = try? model.prediction(carbo: MLMultiArray(dataCarbo))
//      print(prediction?.insulin)
//      let prediction = try? model.prediction(features: MLMultiArray(dataCarbo))
//      print(prediction)
//        var predictionsInsulin:[Double] = []
//
//          for productCarbo in data {
//
//            print(productCarbo)
//
//            let prediction = try? model.prediction(carbo: MLMultiArray(data))
//            guard let predInsulin = prediction?.Insulin else {return []}
//            print(predInsulin)
//            predictionsInsulin.append(predInsulin)
//          }
//          print("Prediction",predictionsInsulin)
      
    } else {
      // Fallback on earlier versions
    }
    
    // Нам нужно ее сначал обновить
    
    
    
    
    var predictionsInsulin:[Double] = []
    
//    for productCarbo in data {
//
//      print(productCarbo)
//
////      let prediction = try? model.prediction(Carbo: productCarbo)
////      guard let predInsulin = prediction?.Insulin else {return []}
////      print(predInsulin)
////      predictionsInsulin.append(predInsulin)
//    }
//    print("Prediction",predictionsInsulin)
    
    
    
    return predictionsInsulin
    
    
    
  }
  
  // MARK: Prepare Data To Model
  
  private static func getTargetDataInsulin(data:[DinnerViewModel]) -> [Float] {
    let target = data.dropLast().flatMap(getInsulinArray)
       return target
  }
  
  private static func getInsulinArray(dinner:DinnerViewModel) -> [Float] {
    return dinner.productListInDinnerViewModel.productsData.map{Float($0.insulinValue!)}
  }
  
  // Принимаем все данные которые есть -> Возвращаем Массив с Углеводами
  private static func getTrainDataCarbo(data:[DinnerViewModel]) -> [Float] {
    let train = data.dropLast().flatMap(getCarboArray)
    return train
  }
  
  private static func getCarboArray(dinner:DinnerViewModel) -> [Float] {
    return dinner.productListInDinnerViewModel.productsData.map{Float($0.carboInPortion)}

  }
  
  
  
  
  private func updateModel() {
    
    // need
    // train data
    // configuration
    //
    
//    let model = InsulinModelTree()
//
//    let bundle = Bundle(for: InsulinModelTree.self)
//    let updateModelUrl = bundle.url(forResource: "InsulinModelTree", withExtension: ".mlmodel")
    
    
    
      
    
//    let updateTask = MLUpdateTask(
//      forModelAt: updateModelUrl,
//      trainingData: <#T##MLBatchProvider#>,
//      configuration: <#T##MLModelConfiguration?#>) { (mlcontext) in
//
//        model.model = mlcontext.model
//    }
    // updateTask.resume()
      
      
  }
  

  
  
}
