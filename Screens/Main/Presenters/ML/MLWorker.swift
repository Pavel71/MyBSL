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




// Class отвечает за обработку данных и получение прогноза инсулина

class MLWorker {
  
  
  var categoryLabelOrdinalDict:[String: Int] = [:]
  
  
  func getPredictInsulin(data:[DinnerViewModel]) -> [Double] {
    
    setCategoryDict(data: data)
    
    // Пока валдиацию не делаю из - за нехватки времени
    
    // Я понимаю что testData будут отвалидированны и меть нужные поля заполненными
    guard let testData = data.last else {return []}
    let trainData = Array(data.dropLast())
    
    simpleModel(trainData: trainData, testData: testData)
    ridgeRegressiomModel(trainData: trainData, testData: testData)
    

    
    
    var predictionsInsulin:[Double] = []
    
    
    return predictionsInsulin
    
    
    
  }
  
  // Simple Model
  
  private func simpleModel(trainData:[DinnerViewModel],testData:DinnerViewModel) {
    
    let test = testData.productListInDinnerViewModel.productsData.map{Float($0.carboInPortion)}
     
     let train = getTrainDataCarbo(data: trainData)
     let target = getTargetDataInsulin(data: trainData)
     
     
     
     SimpleRegresiionModel.getPredictFromSimpleModel(train: train,target:target,test:test)
    
  }
  
  // RidgeRegressionModel
  
  private func ridgeRegressiomModel(
    trainData:[DinnerViewModel],
    testData:DinnerViewModel
  ) {
    
        
    
        let target = getTargetDataInsulin(data: trainData)
        let trainData = getTrainRidgeRegressionModel(data: trainData)
        let test = getTrainRidgeRegressionModel(data: [testData])
    
    
    print("Test Ridge",test)
    
        
    RidgeRegressionModel.getPredictFromRidgeRegressionModel(trainRegression: trainData, target: target, testRidge: test)
        

    
  }
  
  
  // MARK: Prepare Data To RidgeRegressionModel
  
  private  func getTrainRidgeRegressionModel(data:[DinnerViewModel]) -> [[Float]] {
    
    let carbo = getTrainDataCarbo(data: data)
    let category = getCategorProductFuture(data: data)
    
    return [carbo,category]
    
    
  }

  
  
}


// Prepare Data

// MARK: Future Preprocessing

extension MLWorker {
  
  //MARK: 1.Carbo
   
   // Принимаем все данные которые есть -> Возвращаем Массив с Углеводами
   private  func getTrainDataCarbo(data:[DinnerViewModel]) -> [Float] {
     return data.flatMap(getCarboArray)
   }
   
   private  func getCarboArray(dinner:DinnerViewModel) -> [Float] {
     return dinner.productListInDinnerViewModel.productsData.map{Float($0.carboInPortion)}
   }
  
  // MARK: 2.Category
  
  private  func getCategorProductFuture(data:[DinnerViewModel]) -> [Float] {
   
    return data.flatMap(getCategoryToFloat)
  }
  
  private  func getCategoryToFloat(dinner:DinnerViewModel) -> [Float] {
    
    // Нужно сделать лэйбел инкодинг руками
    
    let categoryList = dinner.productListInDinnerViewModel.productsData.map{$0.category}

    return categoryList.map{Float(categoryLabelOrdinalDict[$0] ?? 0)}
  }
  
  
  // Get Category Dict
  private  func setCategoryDict(data:[DinnerViewModel]) {
    let setCat =  Array(
      Set(
        data.flatMap{$0.productListInDinnerViewModel.productsData.map{$0.category}}
      )
    )

    categoryLabelOrdinalDict = setCat.reduce(into: [:]) { (dict, category) in
      dict[category] = setCat.firstIndex(of: category)!
    }
    
    print(categoryLabelOrdinalDict)
    

  }
  
  
  
  // MARK: Target
   

   private  func getTargetDataInsulin(data:[DinnerViewModel]) -> [Float] {
     return data.flatMap(getInsulinArray)
   }
   
   private  func getInsulinArray(dinner:DinnerViewModel) -> [Float] {
     return dinner.productListInDinnerViewModel.productsData.map{Float($0.insulinValue!)}
   }
  
}
