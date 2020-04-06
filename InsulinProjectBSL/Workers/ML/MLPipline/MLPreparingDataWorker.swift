//
//  MLPreparingDataWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import RealmSwift



// Создам Pipline по подготовке и обучению данных!



// Проблема в том что я имею объекты которые например еще не проверенны - мы их проверили и справили

// но потом мне нужно брать только проверенные данны - мне не нужно брать данные где могут содержатся ошибки

// Как мне написать эту логику

// 1. Можно брать для исправления плохих объектов только хорошие - и считать по ним так как если они хорошие то у них все данные будут заполнены!

// 2. тоже самое для обучение мы будим брать только Объекты где компенсация будет хорошей
     // Если таких нет то мы пока что пропускаем исправление

class MLPreparingDataWorker {
  
  static let shared: MLPreparingDataWorker = {MLPreparingDataWorker()}()
  
  var sugarCorrectWorker = ShugarCorrectorWorker.shared
  // Для обучения используются
  
  
  // Какие проблемы - в том что для корректировки я беру не скорректированные данны- Чтобы брать скорректированные тогда мне нужно dropать 2 последних объекта - текущий и тот которые мы сейчас правим!
  
  
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
    


    
    
  }
  
  
  
  


  
}

// MARK: Work with Correct Sugar By Insulin Object

extension  MLPreparingDataWorker {
  
  private  func workWithCorrectSugarByInsulinTypeObj(compObj: CompansationObjectRelam) {
    
    // По хорошему нужно проверить есть с чего мне брать данные для корректировки
    // Если нет то пропустить правку Как только появится хорошо компенсированный объект то мы можем приступить к исправлению!
    
    
    // или вообще не обращатся к истории в жопу ее! просто взять все данные из текущего обеда! и его же подкорректировать! нужно только сделать еще 1 флаг! что объект был модифицированн! Для статистики и я буду брать тогда для обучения данные из хороших объектов и тех которые прошли модификацию
    
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
        writeCorrectInsulinCompSugarToCompObj(compObj: compObj, correctInsulin: compObj.userSetInsulinToCorrectSugar)
      
    default: break
    }
    
  }
  
  
  private  func workWithSugarCorrectPosition(compObj: CompansationObjectRelam) {
    
    // мне нужно выяснить в каую сторону я ошибся сахар вырос или упал!

    let sugarAfter = compObj.sugarAfter
    
    switch compObj.correctSugarPosition {

    case .correctDown:
      // Сахар Высокий нужно было сделать Больше инсулина
      
    let sugarError = sugarAfter - Double(sugarCorrectWorker.optimalSugarLevel)
    
    let meanInsulinOnSugar = getMeanInsulinValueOnCorrectSugar()
    let addingInsulin = meanInsulinOnSugar * sugarError
      
    print(sugarError, "Sugar Error")
    print(meanInsulinOnSugar,"Mean Insulin On Sugar")
    let resultCorrectSugarCompShouldHaveDone = compObj.userSetInsulinToCorrectSugar + addingInsulin
    print("Нужно было сделать столько инсулина",resultCorrectSugarCompShouldHaveDone)
    
      writeCorrectInsulinCompSugarToCompObj(compObj: compObj, correctInsulin: resultCorrectSugarCompShouldHaveDone)
      
    case .correctUp:
      // Сахар Низкий нужно было сделать меньше инсулина
      
      let sugarError = Double(sugarCorrectWorker.optimalSugarLevel) - sugarAfter
      print(sugarError,"SugarError")
      let meanInsulinOnSugar = getMeanInsulinValueOnCorrectSugar()
      let addingInsulin = meanInsulinOnSugar * sugarError
      print(meanInsulinOnSugar,"Mean Insulin On Sugar")
      let resultCorrectSugarCompShouldHaveDone = compObj.userSetInsulinToCorrectSugar - addingInsulin
      print("Нужно было сделать столько инсулина",resultCorrectSugarCompShouldHaveDone)
      
      writeCorrectInsulinCompSugarToCompObj(compObj: compObj, correctInsulin: resultCorrectSugarCompShouldHaveDone)

    default:break
    }
    
    
  }
  
  // Write CorrectInsulinComp
  
  private func writeCorrectInsulinCompSugarToCompObj(
    compObj: CompansationObjectRelam,correctInsulin: Double) {
    
    CompObjRealmManager.shared.writeCorrectSugarInsuilin(
      compObj: compObj, correctSugarMl: correctInsulin)
  }
  
  

  
}


// MARK: Work wtih Meal Object

extension  MLPreparingDataWorker {
  
  // Здесь мы будим работать с продуктами! Если у нас есче идет и повышенный сахар то его я не учитываю так как мы не знаем точно где мы могли ошибится! Только если человек умышленно сам навредит!
  
 private func  workWithMealTypeObj(compObj: CompansationObjectRelam) {
    // Если пришедший обед хорошо компенсированн то запиши все данные для ML
  
  switch compObj.compansationFaseEnum {
    
    case .good:
      
      CompObjRealmManager.shared.compensationSuccessWriteMlData(compObj: compObj)
      
    case .bad:
      
      // Итак работаем над тем кейсом что был обед - Сахар был в норме - Значит мы ошиблись в продуктах!
      
      print("Обед компенсирован плохо! надо подумать что можно сделать!")
      prepareMealDataInBadMeal(compObj:compObj)
    default:break
  }
  
    
  }
  
  
  private func prepareMealDataInBadMeal(compObj: CompansationObjectRelam) {
    
    // итак расчет на обед зависит от углеводов - для того чтобы подправить все это дело
    // мне нужно пройтись по всем объектам - meal - собрать все углеводы - и все дозировки инсуилна
    
    // Сперва мне нужно узнать какая ошибка у меня
    // не мне важно знать и направление!
    
    let allProductCarboSum     = CompObjRealmManager.shared.fetchAllCarbo().sum()
    let allInsulinByCarboMLSum = CompObjRealmManager.shared.fetchAllInsulinOnCarboMl().sum()
    let meanInsulinByCarbo = allProductCarboSum / allInsulinByCarboMLSum
    
    if sugarCorrectWorker.optimalSugarLevel.isLess(than: compObj.sugarAfter) {
      //
      let sugarError = compObj.sugarAfter - sugarCorrectWorker.optimalSugarLevel
      
      print("Ошибка сахара из за углеводов",sugarError)
      print("В среднем инсулина на углеводы",meanInsulinByCarbo)
    } else {
      let sugarError = sugarCorrectWorker.optimalSugarLevel - compObj.sugarAfter
      print("Ошибка сахара из за углеводов",sugarError)
      print("В среднем инсулина на углеводы",meanInsulinByCarbo)
    }
    
//    switch compObj.correctSugarPosition {
//    case .correctDown:
//      // Сахар Высокий нужно было сделать Больше инсулина
//      let sugarError = compObj.sugarAfter - sugarCorrectWorker.optimalSugarLevel
//
//      print("Ошибка сахара из за углеводов",sugarError)
//      print("В среднем инсулина на углеводы",meanInsulinByCarbo)
//      // Так ошибка известна - Теперь нужно расчитать сколько в среднем инсулина идет на углевод -
//
//    case .correctUp:
//      // Сахар Низкий нужно было сделать Меньше инсулина
//      let sugarError = sugarCorrectWorker.optimalSugarLevel - compObj.sugarAfter
//      print("Ошибка сахара из за углеводов",sugarError)
//      print("В среднем инсулина на углеводы",meanInsulinByCarbo)
//
//    default: break
//    }
    
    
    
    
    // Итак тут собраны все Данные!
    
    
    
  }
  
}

// MARK: Get Data From Realm


extension  MLPreparingDataWorker {
  
  private func getMeanInsulinValueOnCorrectSugar() -> Double {
    
    let sugarCorrectCompObjs = CompObjRealmManager.shared.fetchCompObjByTypeCompObj(typeObj: .correctSugarByInsulin, compFase: .good)
    
    let sugarsDiffSum  = sugarCorrectCompObjs.map{Double($0.sugarDiffForMl)}.sum()
    
    print(sugarsDiffSum, "Сумма разницы сахара до идеального сахар")
    
    // Здесь я должен буду брать уже хорошие показатели или можно не паритс
    let insulinCorrectSum = sugarCorrectCompObjs.map{$0.userSetInsulinToCorrectSugar}.sum()
    
    print(insulinCorrectSum,"Сумма инсулиновых инъекций")
    
    let insulinOnTheSugar = insulinCorrectSum / sugarsDiffSum
    
    print(insulinOnTheSugar,"Среднее значение инсулина на сахар")

    return insulinOnTheSugar
    
  }
  

  
}
