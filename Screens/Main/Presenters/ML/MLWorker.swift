//
//  MLworker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 30.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import CoreML




// Class отвечает за обработку данных и получение прогноза инсулина

class MLWorker {
  
  
  // Нам нужно 1вое это trainData
  // нам нужно testData
  
  static func getPredictInsulin(data:[DinnerViewModel]) -> [Double] {
    
    // Пока валдиацию не делаю из - за нехватки времени
    
    // Я понимаю что testData будут отвалидированны и меть нужные поля заполненными
    guard let testData = data.last else {return []}
    let trainData = Array(data.dropLast())
    
    print(testData)
    
    let data = testData.productListInDinnerViewModel.productsData.map{Double($0.carboInPortion)}
    
    
    // Модель!
    let model = InsulinModelTree()
    
    // Нам нужно ее сначал обновить
    
    
    
    
    var predictionsInsulin:[Double] = []
    
    for productCarbo in data {
      
      print(productCarbo)
      
      let prediction = try? model.prediction(Carbo: productCarbo)
      guard let predInsulin = prediction?.Insulin else {return []}
      print(predInsulin)
      predictionsInsulin.append(predInsulin)
    }
    print("Prediction",predictionsInsulin)
    
    
    
    return predictionsInsulin
    
    
    
  }
  
  
  private func updateModel() {
    
    // need
    // train data
    // configuration
    //
    
    let model = InsulinModelTree()
    
    let bundle = Bundle(for: InsulinModelTree.self)
    let updateModelUrl = bundle.url(forResource: "InsulinModelTree", withExtension: ".mlmodel")
    
    
    
      
    
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
