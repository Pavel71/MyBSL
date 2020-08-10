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
  
  var learnByCorrectionVM  : LearnByCorrectionVM
  var learnByFoodVM        : LearnByFoodVM
   
   
  let userDefaults         : UserDefaultsWorker!
  let sugarMetricConvertor : SugarMetricConverter!
  let addService           : AddService!
  
  
  init() {
    
    learnByCorrectionVM  = LearnByCorrectionVM()
    learnByFoodVM        = LearnByFoodVM()
    addService           = ServiceLocator.shared.getService()
    userDefaults         = ServiceLocator.shared.getService()
    sugarMetricConvertor = ServiceLocator.shared.getService()
  }
  
  func clearAllFields() {
    learnByCorrectionVM.clearAllData()
    learnByFoodVM.clearAllData()
  }

}

// MARK: FireStore

extension OnBoardVM {
  
  func setDataToFireStore(complation:@escaping ((Result<Bool,NetworkFirebaseError>)) -> Void) {
    

    let userDefDataDict = userDefaults.getAllDataFromUserDefaults()
    
    print("USer Defaults Data To FireStore",userDefDataDict["sugarCorrectTrainBaseData"])
    
    // здесь мы должны сохранить userDefaults and наш новый день в базу данных!
    
    addService.addUserDefaultsDataToFirebase(userDefaltsData: userDefDataDict) { (result) in
      
      switch result {
      case .failure(let error):
        
        complation(.failure(error))
        
        
      case .success(_):

        complation(.success(true))
        
      }
      
      
    }
  }
  
}


// MARK: ML Works

extension OnBoardVM {
  
  func learnMlModel(train: [Float], target: [Float],keyWeights:UserDefaultsKey ) {
      let mlWorker = MLWorker(typeWeights: keyWeights)
     
      mlWorker.trainModelAndSetWeights(trainData: train, target: target)
  }
  
  func setDataToUserDefaults() {
    // Save Sugar LEvel In User Defaults
    saveSugarLevelInUserDefaults()
    saveInsulinSupplyValue()
    
    let sugarMetric = learnByCorrectionVM.getMetric()
    saveSugarMetricToUserDefaults(sugarMetric: sugarMetric)
    
    let correctionData    = fetchInsulinValueByCorrectionSugar()
    let insulinByFoodData = fetchInsulinValueByFoodData()
    
    print("Train Data",correctionData.train)
    
    saveBaseTrainAndTargetDataInUserDefaultsCorrectSugar(train: correctionData.train, target: correctionData.target)
    
    saveBaseTrainAndTargetDataInUserDefaultsCorrectCarbo(train: insulinByFoodData.train, target: insulinByFoodData.target)
    
    
    learnMlModel(train: correctionData.train, target: correctionData.target, keyWeights: .correctSugarByInsulinWeights)
    
    learnMlModel(train: insulinByFoodData.train, target: insulinByFoodData.target, keyWeights: .correctCarboByInsulinWeights)
  }
  
  
  
  // MARK: Save
  
  private func saveSugarMetricToUserDefaults(sugarMetric: SugarMetric) {
    userDefaults.setSugarMetric(sugarMetric: sugarMetric, key: .sugarMetric)
  }
  
  private func saveInsulinSupplyValue() {
    userDefaults.setInsulinSupplyValue(insulinSupply: 300)
    
  }
  
  private func saveSugarLevelInUserDefaults() {
    
    let sugarLevelModel = learnByCorrectionVM.getSugarLevelToSaveData()
    
    userDefaults.setSugarLevel(sugarLevel: sugarLevelModel.sugarLowerLevel, key: .lowSugarLevel)
    
    userDefaults.setSugarLevel(sugarLevel: sugarLevelModel.sugarHigherLevel, key: .higherSugarLevel)
    
  }
  
  private func saveBaseTrainAndTargetDataInUserDefaultsCorrectSugar(train:[Float],target: [Float]) {
    
    userDefaults.setArrayFloat(arr: train, key: .sugarCorrectTrainBaseData)
    userDefaults.setArrayFloat(arr: target, key: .sugarCorrectTargetBaseData)
  }
  
  private func saveBaseTrainAndTargetDataInUserDefaultsCorrectCarbo(train:[Float],target: [Float]) {
    userDefaults.setArrayFloat(arr: train, key: .carboCorrectTrainBaseData)
    userDefaults.setArrayFloat(arr: target, key: .carboCorrectTargetBaseData)
  }
  
  // Обучим модель! Когда обучим модель мы автоматом сохраним данные в UserDefaults
  

  

  
  // MARK: Fetch Data
  
  private func fetchInsulinValueByCorrectionSugar() -> (train:[Float],target:[Float]) {
    
    // Так теперь мы видим данные нам нужно засетить Сахар в В User Defaults
    // потом добавить туда Веса!
    
    // Ужасно все коряво! Просто жесть!
    var tableData      = learnByCorrectionVM.getTableData()
    
    // Нужно вернуть данные в изначальное значение!
    if learnByCorrectionVM.getMetric() == .mgdl {
      print("mgdl")
      tableData = tableData.map { (modal) -> LearnByCorrectionCellModal in
        LearnByCorrectionCellModal(
          sugar             : sugarMetricConvertor.convertMgdltoMmol(mgdlSugar:modal.sugar),
          correctionInsulin : modal.correctionInsulin)
      }
    }
    print(tableData)
    
    var train :[Float] = tableData.map(prepareMlData)
    var target         = tableData.map{Float($0.correctionInsulin!)}
    
    // Обогатим данные идеальным сахаром и инмсулином на этот сахар
    // Траин 0 - так как нет разницы с идеальным сахаром
    train.insert(0, at: 0)
    target.insert(0, at: 0)
    
    return (train:train,target:target)
  }
  
  private func prepareMlData(viewModel:LearnByCorrectionCellModal) -> Float {
    
    let sugarLevelModel = learnByCorrectionVM.getSugarLevelToSaveData()
 
    let oprimalSugar    = sugarLevelModel.optimalSugarLevel
    
    
    let sugar           = viewModel.sugar.toFloat()

    let mlSugarDiffData = abs(sugar - oprimalSugar)
    
    return mlSugarDiffData
  }
  
  private func fetchInsulinValueByFoodData() -> (train:[Float],target:[Float]) {
    var train  = learnByFoodVM.tableData.map{$0.carbo.toFloat()}
    var target = learnByFoodVM.tableData.map{$0.insulin!.toFloat()}
    // При нулевых углеводах = 0 инсулина
    train.insert(0, at: 0)
    target.insert(0, at: 0)
    return (train:train,target:target)
  }
  
}
