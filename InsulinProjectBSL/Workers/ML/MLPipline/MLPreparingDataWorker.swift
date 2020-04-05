//
//  MLPreparingDataWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Создам Pipline по подготовке и обучению данных!

class MLPreparingDataWorker {
  
  static let shared: MLPreparingDataWorker = {MLPreparingDataWorker()}()
  
  var sugarCorrectWorker = ShugarCorrectorWorker.shared
  // Для обучения используются
  
  // Продукты
  // Train - CarboInPortion
  // Target - InsulinInCarboML
  
  // CompObj - CorrectionSugar
  
  // Train - sugarBefore
  // Target - correctSugarInsulinML
  
  
  
  // к нам приходит предыдущий обед и мы с ним работаем!
  
  // Тут основная проблема в том что если мы будим удалять обеды! Это в целом абсолютно не критично так как мы все закладываем в веса! с другой стороны если человек балуется и фигачит объекты с неправлеьными данными потом их удаляет! Все таки мне кажется мы должны запускать процесс пересчета весов!
  
  // Нужно будет подумать об изменение position после хорошо компенсированных объектов!
  
  
  func prepareCompObj(compObj: CompansationObjectRelam)  {
    
    print("Пошла работа с ML подготовкой данных")
    
    switch compObj.typeObjectEnum {
      
    case .correctSugarByCarbo:
      print("Carbo Obj")
      
    case .correctSugarByInsulin:
      print("Insulin")
      workWithCorrectSugarByInsulinTypeObj(compObj: compObj)
      
      
    case .mealObject:
      workWithMealTypeObj(compObj: compObj)
      
      print("Meal Obj")
    }
    
//    switch compObj.compansationFaseEnum {
//
//
//    case .bad:
//      print("Bad need preapring")
//
//      // Так тут надо действовать поэтапно
//      // 1. Нужно определить была ли компенсация сахара?
//      // 2. Нужно проверять все продукты
//
//      workWithSugarCorrectPosition(compObj: compObj)
//
//
//    case .good:
//      print("Every thing alright need writing")
//
//      // Мне нужно взять все продукты и записать поля для ML
//      // Нужно записать коррекцию сахара для ML
//      CompObjRealmManager.shared.compensationSuccessWriteMlData(compObj: compObj)
//
//    default: break
//
//    }
    
    
  }
  
  
  
  


  
}

// MARK: Work with Correct Sugar By Insulin Object

extension  MLPreparingDataWorker {
  
  private  func workWithCorrectSugarByInsulinTypeObj(compObj: CompansationObjectRelam) {
    
    print("Обрабатываем компенсацию повышенного сахара")
    
    // Итак сюда мы попали значит у нас сахар был плох и мы его дополнительно сбивали без продуктов! Чтобы был чистый сценарий
    
    switch compObj.compansationFaseEnum {
    case .bad:
      print("Плохо посчитали")
      
      // Компенсировали плохо! Поэтому нужно расчитать в среднем на сколько мы ошиблись по инмулину и добавить это
      workWithSugarCorrectPosition(compObj: compObj)
      
    case .good:
      print("Все норм сахар нормализовался")
      // Записываем что все норм
      CompObjRealmManager.shared.setCorrectSugarInsuilin(
        compObj: compObj,
        correctSugarMl: compObj.userSetInsulinToCorrectSugar)
      
    case .dontCalculated:
      print("Прошло много времени не учитываю в расчете")
      break
    case .progress:
      print("Сюда не может попасть")
      break
    }
    
  }
  
  
  private  func workWithSugarCorrectPosition(compObj: CompansationObjectRelam) {
    
    // мне нужно выяснить в каую сторону я ошибся сахар вырос или упал!

    let sugarAfter = compObj.sugarAfter
    
    
    switch compObj.correctSugarPosition {

    case .correctDown:
      // Сахар Высокий нужно больше инсулина
      
      // Теперь я знаю на сколько я ошибся - Дальше мне нужно посчитать сколько на этот сахар мне нужно было добавить инсулина! и прибавить это кол-во к гserSetInsulin!
      
    let sugarError = Float(sugarAfter) - sugarCorrectWorker.optimalSugarLevel
      
      print(sugarError, "Sugar Error")
      
    case .correctUp:
      // Сахар Низкий нужно было меньше инсулина
      
      let sugarError = sugarCorrectWorker.optimalSugarLevel - Float(sugarAfter)
      print(sugarError,"SugarError")


    default:break
    }
  }
  
}


// MARK: Work wtih Compansation Products

extension  MLPreparingDataWorker {
  
  // Здесь мы будим работать с продуктами! Если у нас есче идет и повышенный сахар то его я не учитываю так как мы не знаем точно где мы могли ошибится! Только если человек умышленно сам навредит!
  
 private func  workWithMealTypeObj(compObj: CompansationObjectRelam) {
    
  }
  
}
