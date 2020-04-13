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
  
  
  init() {
    
    learnByCorrectionVM = LearnByCorrectionVM()
    learnByFoodVM       = LearnByFoodVM()
    
  }
  
  
  // Метод запускает сбор данных с дочерних VM и передает их в ML Worker
  
  
  


  
  
}


// MARK: ML Works

extension OnBoardVM {
  
  func learnML() {
    
    
    // Save Sugar LEvel In User Defaults
    saveSugarLevelInUserDefaults()
    
    let correctionData    = fetchInsulinValueByCorrectionSugar()
    let insulinByFoodData = fetchInsulinValueByFoodData()

    trainModel(traing: correctionData.train, target: correctionData.target, keyWeights: .correctSugarByInsulinWeights)
    
    trainModel(traing: insulinByFoodData.train, target: insulinByFoodData.target, keyWeights: .correctCarboByInsulinWeights)
    
    
//    let correctionWeights = getWeightsByData(traing: correctionData.train, target: correctionData.target)
//
//    let insulinByFoodsWeights = getWeightsByData(traing: insulinByFoodData.train, target: insulinByFoodData.target)
  
    


    
  }
  
  private func saveSugarLevelInUserDefaults() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(learnByCorrectionVM.sugarLevelVM.sugarLowerLevel, forKey: UserDefaultsKey.lowSugarLevel.rawValue)
    userDefaults.set(learnByCorrectionVM.sugarLevelVM.sugarHigherLevel, forKey: UserDefaultsKey.higherSugarLevel.rawValue)
  }
  
//  private func saveWeightsinUserDefaults(weights:(Float,Float), key:String) {
//    let userDefault = UserDefaults.standard
//    
//    userDefault.set([weights.0,weights.1], forKey: key)
//  }
  
  // Обучим модель! Когда обучим модель мы автоматом сохраним данные в UserDefaults
  
  private func trainModel(traing: [Float],target:[Float],keyWeights: UserDefaultsKey) {
    
    let mlWorker = MLWorker(typeWeights: keyWeights)
    
    mlWorker.trainModelAndSetWeights(trainData: traing, target: target)
    
    
  }
  

  
  // MARK: Fetch Data
  
  private func fetchInsulinValueByCorrectionSugar() -> (train:[Float],target:[Float]) {
    
    // Так теперь мы видим данные нам нужно засетить Сахар в В User Defaults
    // потом добавить туда Веса!
    

    
    var train  = learnByCorrectionVM.tableData.map{Float(abs($0.sugar - learnByCorrectionVM.sugarLevelVM.optimalSugarLevel))}
    var target = learnByCorrectionVM.tableData.map{Float($0.correctionInsulin!)}
    
    // Обогатим данные идеальным сахаром и инмсулином на этот сахар
    // Траин 0 - так как нет разницы с идеальным сахаром
    train.insert(0, at: 0)
    target.insert(0, at: 0)
    
    return (train:train,target:target)
  }
  
  private func fetchInsulinValueByFoodData() -> (train:[Float],target:[Float]) {
    var train  = learnByFoodVM.tableData.map{Float($0.carbo)}
    var target = learnByFoodVM.tableData.map{Float($0.insulin!)}
    // При нулевых углеводах = 0 инсулина
    train.insert(0, at: 0)
    target.insert(0, at: 0)
    return (train:train,target:target)
  }
  
}
