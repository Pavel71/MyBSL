//
//  LearnByCorrectionVM.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

// Нам нужно также знать какой уровень сахар человек будет считать оптимальным для себя! Нужно дать ему возможность выбрать!


// Здесь нам нужно будет добавить поле для указания метрики! Если метрика меняется то и поменять кейборды и текстовые поля!

// все эти поля должны собиратся в DTO - что бы было всегда понятно что и откуда и куда идет! Тогда можно проследить дорожку!




class LearnByCorrectionVM {
  
  
  // MARK: Validate
  
  var isFillAllFields = false {
    
    didSet {
      didUpdateValidForm!(isFillAllFields)
    }
    
  }
  var didUpdateValidForm: ((Bool) -> Void)?
  
  
  // MARK:  Model
  
  private var learnByCorrectionModel = LearnByCorrectionModel(
    metric            : .mmoll,
    lowerSliderValue  : 0.3,
    higherSliderValue : 0.5)

  
  func addInsulinInObject(insulinValue: Double, index: Int) {
    
    learnByCorrectionModel.tableData[index].correctionInsulin = insulinValue
    
    checkAllCorrectionFiedls()
  }
  
 
  
  
  func checkAllCorrectionFiedls() {
    
    
    isFillAllFields = learnByCorrectionModel.tableData.filter {$0.correctionInsulin == nil}.isEmpty
    
  }
  
  func clearAllData() {
    learnByCorrectionModel.tableData = [
      LearnByCorrectionCellModal(sugar: 9.0, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 12.0, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 15.0, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 18.0, correctionInsulin: nil),
      LearnByCorrectionCellModal(sugar: 21.0, correctionInsulin: nil),
    ]
    learnByCorrectionModel.metrics = .mmoll
  }
  
  
  
}

// MARK: Change Metric

extension LearnByCorrectionVM {
  
  func setMetric(metric: SugarMetric,lowerSliderValue: CGFloat,higherSliderValue: CGFloat) {
    learnByCorrectionModel = LearnByCorrectionModel(
      metric            : metric,
      lowerSliderValue  : lowerSliderValue,
      higherSliderValue : higherSliderValue)
    
  }
}

// MARK: Get

extension LearnByCorrectionVM {
  
  func getTableData() -> [LearnByCorrectionCellModal] {
     learnByCorrectionModel.tableData
   }
  func getMetric() -> SugarMetric {
    learnByCorrectionModel.metrics
  }
  
  func getSugarLevelModelToUpdateUI() -> SugarLevelModel {
    // Когда этот ебучий метод вызывается мы должны сверится с метркиой! И если я решил все преобразоввывать к обычной метрике! То надо все это дерьмо конвертировать!
    // Какое же уебищное решение! Такая адская путаница что я в ахуе!
    // Эти конвертациии убивают мозг
    // я думаю что мне нужно 2 модели сделать!
    
    learnByCorrectionModel.sugarLevelModel
  }
  
  func getSugarLevelToSaveData() -> SugarLevelModel{
    
    // Возвращаем модель обратно! Но я понимимаю что так нельзя делать! нужно это изменить!
    if learnByCorrectionModel.metrics == .mgdl {
      
      return SugarLevelModel(
        lowerSliderValue  : learnByCorrectionModel.sugarLevelModel.lowerSliderValue ,
        higherSliderValue : learnByCorrectionModel.sugarLevelModel.higherSliderValue,
        metric            : .mmoll)
    }
    
    return learnByCorrectionModel.sugarLevelModel
    
  }
}
  
  
//}
// MARK: Work with sugarLevelVM

extension LearnByCorrectionVM {

  func updateSugarLevelVM(
    lowerSliderValue  : CGFloat,
    higherSliderValue : CGFloat) {
    
    learnByCorrectionModel.sugarLevelModel.lowerSliderValue  = lowerSliderValue
    learnByCorrectionModel.sugarLevelModel.higherSliderValue = higherSliderValue
  }
}
