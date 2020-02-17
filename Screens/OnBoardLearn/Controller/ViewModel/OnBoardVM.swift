//
//  OnBoardVM.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



// Теперь мне нужно настроить OnBoarding на отдельное UIWindow

class OnBoardVM {
  
  var learnByCorrectionVM : LearnByCorrectionVM
  var learnByFoodVM       : LearnByFoodVM
  
  var mlWorker : MLWorker
  
  
  
  init() {
    
    learnByCorrectionVM = LearnByCorrectionVM()
    learnByFoodVM       = LearnByFoodVM()
    
    mlWorker            = MLWorker()
    
  }
  
  
  // Метод запускает сбор данных с дочерних VM и передает их в ML Worker
  
  
  


  
  
}


// MARK: ML Works

extension OnBoardVM {
  
  func learnML() {
    
    let correctionData    = fetchInsulinValueByCorrectionSugar()
    let insulinByFoodData = fetchInsulinValueByFoodData()

    
    let correctionWeights = getWeightsByData(traing: correctionData.train, target: correctionData.target)
    
    let insulinByFoodsWeights = getWeightsByData(traing: insulinByFoodData.train, target: insulinByFoodData.target)
  
    
    saveWeightsinUserDefaults(
      weights: correctionWeights,
      key: MLWorker.KeyWeights.correctionSugar.rawValue
    )
    
    saveWeightsinUserDefaults(
      weights: insulinByFoodsWeights,
      key: MLWorker.KeyWeights.insulinByFood.rawValue
    )

    
  }
  
  private func saveWeightsinUserDefaults(weights:(Float,Float), key:String) {
    let userDefault = UserDefaults.standard
    
    userDefault.set([weights.0,weights.1], forKey: key)
  }
  
  private func getWeightsByData(traing: [Float],target:[Float]) -> (Float,Float) {
    mlWorker.trainModelAndSetWeights(
         trainData: traing, target: target
       )
       
     return mlWorker.getRegressionWeights()
  }
  
  
  // MARK: Fetch Data
  
  private func fetchInsulinValueByCorrectionSugar() -> (train:[Float],target:[Float]) {
    
    let train  = learnByCorrectionVM.tableData.map{Float($0.sugar)}
    let target = learnByCorrectionVM.tableData.map{Float($0.correctionInsulin!)}
    return (train:train,target:target)
  }
  
  private func fetchInsulinValueByFoodData() -> (train:[Float],target:[Float]) {
    let train  = learnByFoodVM.tableData.map{Float($0.carbo)}
    let target = learnByFoodVM.tableData.map{Float($0.insulin!)}
    return (train:train,target:target)
  }
  
}
