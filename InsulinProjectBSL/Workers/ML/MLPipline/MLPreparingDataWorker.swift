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
  
  
  // Для обучения используются
  
  // Продукты
  // Train - CarboInPortion
  // Target - InsulinInCarboML
  
  // CompObj - CorrectionSugar
  
  // Train - sugarBefore
  // Target - correctSugarInsulinML
  
  
  
  // к нам приходит предыдущий обед и мы с ним работаем!
  
  // Тут основная проблема в том что если мы будим удалять обеды! Это в целом абсолютно не критично так как мы все закладываем в веса! с другой стороны если человек балуется и фигачит объекты с неправлеьными данными потом их удаляет! Все таки мне кажется мы должны запускать процесс пересчета весов!
  
  
  static func prepareCompObj(compObj: CompansationObjectRelam)  {
    
    print("Пошла работа с ML подготовкой данных")
    
    switch compObj.typeObjectEnum {
    case .correctSugarByCarbo:
      print("Carbo Obj")
    case .correctSugarByInsulin:
      print("Insulin")
    case .mealObject:
      print("Meal Obj")
    }
    
    switch compObj.compansationFaseEnum {
      
      
    case .bad:
      print("Bad need preapring")
      
      // Так тут надо действовать поэтапно
      // 1. Нужно определить была ли компенсация сахара?
      // 2. Нужно проверять все продукты
      
      workWithSugarCorrectPosition(compObj: compObj)
      
      
    case .good:
      print("Every thing alright need writing")
      
      // Мне нужно взять все продукты и записать поля для ML
      // Нужно записать коррекцию сахара для ML
      CompObjRealmManager.shared.compensationSuccessWriteMlData(compObj: compObj)

    default: break
    
    }
    
    
  }
  
  private static func workWithSugarCorrectPosition(compObj: CompansationObjectRelam) {
    
    
    switch compObj.correctSugarPosition {
    case .correctDown:
      print("Сахар был низкий")
    case .correctUp:
      print("Сахар был высоким")
      
      // теперь здесь нужно сделать корректировку и записать скорректированный сахар
      
      // нужно как то высчитать корректировку по сахару или кстати это можно делать только на объектах которые маркируются как без продуктов питания! просто сбив сахара! это будет гораздо точнее!
      
    case .dontCorrect:
      print("Сахар был в норме")
      
      CompObjRealmManager.shared.setCorrectSugarInsuilin(compObj: compObj, correctSugarMl: compObj.userSetInsulinToCorrectSugar)
      
    default:break
    }
  }

  
}
