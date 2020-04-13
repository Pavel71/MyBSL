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
  
  
//  func getPredictInsulin(data:[DinnerViewModel]) -> [Double] {
//
//    // Я понимаю что testData будут отвалидированны и меть нужные поля заполненными
//    guard let testData = data.last else {return []}
//    let trainData = Array(data.dropLast())
//
//    return getPredictFromSimpleModel(trainData: trainData, testData: testData)
//
//
//  }
  
  // Simple Model
  
//  private func getPredictFromSimpleModel(trainData:[DinnerViewModel],testData:DinnerViewModel) -> [Double] {
//
//    let test = testData.productListInDinnerViewModel.productsData.map{Float($0.carboInPortion)}
//
//     let train = getTrainDataCarbo(data: trainData)
//     let target = getTargetDataInsulin(data: trainData)
//
//     let predicts = SimpleRegresiionModel.getPredictFromSimpleModel(train: train,target:target,test:test)
//    return predicts
//
//  }

  
}


// Prepare Data

// MARK: Future Preprocessing

//extension MLWorker {
//
//  //MARK: 1.Carbo
//
//   // Принимаем все данные которые есть -> Возвращаем Массив с Углеводами
//   private  func getTrainDataCarbo(data:[DinnerViewModel]) -> [Float] {
//     return data.flatMap(getCarboArray)
//   }
//
//   private  func getCarboArray(dinner:DinnerViewModel) -> [Float] {
//     return dinner.productListInDinnerViewModel.productsData.map{Float($0.carboInPortion)}
//   }
//
//
//
//
//
//  // MARK: Target
//
//
//   private  func getTargetDataInsulin(data:[DinnerViewModel]) -> [Float] {
//     return data.flatMap(getInsulinArray)
//   }
//
//   private  func getInsulinArray(dinner:DinnerViewModel) -> [Float] {
//     return dinner.productListInDinnerViewModel.productsData.map{Float($0.insulinValue!)}
//   }
//
//}










 // RidgeRegressionModel
//
//  private func ridgeRegressiomModel(trainData:[DinnerViewModel],testData:DinnerViewModel) {
//
//
//
//
//        let target = getTargetDataInsulin(data: trainData)
//        let trainData = getTrainRidgeRegressionModel(data: trainData)
//        let test = getTrainRidgeRegressionModel(data: [testData])
//
//
//    print("Test Ridge",test)
//
//
//    RidgeRegressionModel.getPredictFromRidgeRegressionModel(trainRegression: trainData, target: target, testRidge: test)
//
//
//
//  }
//
//
//  // MARK: Prepare Data To RidgeRegressionModel
//
//  private  func getTrainRidgeRegressionModel(data:[DinnerViewModel]) -> [[Float]] {
//
//    let carbo = getTrainDataCarbo(data: data)
//    let category = getCategorProductFuture(data: data)
//
//    return [carbo,category]
//
//
//  }


  // MARK: 2.Category
  
//  private  func getCategorProductFuture(data:[DinnerViewModel]) -> [Float] {
//
//    return data.flatMap(getCategoryToFloat)
//  }
//
//  private  func getCategoryToFloat(dinner:DinnerViewModel) -> [Float] {
//
//    // Нужно сделать лэйбел инкодинг руками
//
//    let categoryList = dinner.productListInDinnerViewModel.productsData.map{$0.category}
//
//    return categoryList.map{Float(categoryLabelOrdinalDict[$0] ?? 0)}
//  }
//
//
//  // Get Category Dict
//  private  func setCategoryDict(data:[DinnerViewModel]) {
//    let setCat =  Array(
//      Set(
//        data.flatMap{$0.productListInDinnerViewModel.productsData.map{$0.category}}
//      )
//    )
//
//    categoryLabelOrdinalDict = setCat.reduce(into: [:]) { (dict, category) in
//      dict[category] = setCat.firstIndex(of: category)!
//    }
//
//    print(categoryLabelOrdinalDict)
//
//
//  }
