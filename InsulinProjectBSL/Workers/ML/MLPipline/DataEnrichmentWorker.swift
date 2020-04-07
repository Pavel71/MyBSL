//
//  DataEnrichmentWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


// Класс отвечает за обогащение данными для объектов котоыре были плохо скомпенсированны!

class DataEnrichmentWorker {
  


  // Создам Pipline по подготовке и обучению данных!

  // 1 Сценарий - Сбив Сахара - Хороший + Плохой +
  // 2 Сценарий - Сахар в норме коррекция продуктов по углеводам Хороший +


  
    
    static let shared: DataEnrichmentWorker = {DataEnrichmentWorker()}()
    
    var sugarCorrectWorker = ShugarCorrectorWorker.shared

    
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

extension  DataEnrichmentWorker {
    
    private  func workWithCorrectSugarByInsulinTypeObj(compObj: CompansationObjectRelam) {

      
      switch compObj.compansationFaseEnum {
        
        case .bad:
          print("Плохо посчитали")
          
          // Компенсировали плохо! Поэтому нужно расчитать в среднем на сколько мы ошиблись по инмулину и добавить это
          workWithSugarCorrectPosition(compObj: compObj)
          
        case .good:
          print("Все норм сахар нормализовался")
          // Записываем что все норм
          writeCorrectInsulinCompSugarToCompObj(
            compObj         : compObj,
            correctInsulin  : compObj.userSetInsulinToCorrectSugar,
            compPosition    : .good)
        
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
      
      let meanInsulinOnSugar = getMeanInsulinValueOnCorrectSugar(compObj: compObj)
      let addingInsulin = meanInsulinOnSugar * sugarError
        
      let resultCorrectSugarCompShouldHaveDone = compObj.userSetInsulinToCorrectSugar + addingInsulin
      
      
        writeCorrectInsulinCompSugarToCompObj(
          compObj        : compObj,
          correctInsulin : resultCorrectSugarCompShouldHaveDone,
          compPosition   : .modifidedForMl)
        
      case .correctUp:
        // Сахар Низкий нужно было сделать меньше инсулина
        
        let sugarError = Double(sugarCorrectWorker.optimalSugarLevel) - sugarAfter
        
        let meanInsulinOnSugar = getMeanInsulinValueOnCorrectSugar(compObj: compObj)
        
        let addingInsulin = meanInsulinOnSugar * sugarError
        
        let resultCorrectSugarCompShouldHaveDone = compObj.userSetInsulinToCorrectSugar - addingInsulin
        
        
        writeCorrectInsulinCompSugarToCompObj(
          compObj        : compObj,
          correctInsulin : resultCorrectSugarCompShouldHaveDone,
          compPosition   : .modifidedForMl)

      default:break
      }
      
      
    }
    
    // Write CorrectInsulinComp
    
    private func writeCorrectInsulinCompSugarToCompObj(
      compObj        : CompansationObjectRelam,
      correctInsulin : Double,
      compPosition   : CompansationPosition) {
      
      CompObjRealmManager.shared.writeCorrectSugarInsuilin(
        compObj              : compObj,
        correctSugarMl       : correctInsulin,
      changeTypeCompPosition : compPosition)
    }
    
    private func getMeanInsulinValueOnCorrectSugar(compObj: CompansationObjectRelam) -> Double {
      
      
      // Концепция в том что я обхожусь данными того объекта который приходит! Так как в целом все данные будут только улучшатся то больших отклонений не должно быть
      
      let shugarDiffLevel         = compObj.sugarDiffToOptimaForMl
      let sugarCorrectInsulin     = compObj.userSetInsulinToCorrectSugar.toFloat()
      
      let middleInsulinOnTheSugar = sugarCorrectInsulin / shugarDiffLevel
      
      
      return Double(middleInsulinOnTheSugar)
      
      
    }
    
    

    
  }


  // MARK: Work wtih Meal Object
extension  DataEnrichmentWorker {
    
    // Здесь мы будим работать с продуктами! Если у нас есче идет и повышенный сахар то его я не учитываю так как мы не знаем точно где мы могли ошибится! Только если человек умышленно сам навредит!
    
   private func  workWithMealTypeObj(compObj: CompansationObjectRelam) {
      // Если пришедший обед хорошо компенсированн то запиши все данные для ML
    
    switch compObj.compansationFaseEnum {
      
      case .good:
        
        CompObjRealmManager.shared.compensationSuccessWriteMlData(compObj: compObj)
        
      case .bad:
        
        // Итак работаем над тем кейсом что был обед - Сахар был в норме - Значит мы ошиблись в продуктах!
        
        print("Обед компенсирован плохо! надо подумать что можно сделать!")
        workWithMealDataInBadMeal(compObj:compObj)
      default:break
    }
    
      
    }
    
    
    private func workWithMealDataInBadMeal(compObj: CompansationObjectRelam) {
      
      // Функция работает как я и хотел теперь определится в этом кейсе с записью компенсации сахара
      // В случае если и сахар высокий и продукты сахар не трогаю так как его компенсировать достаточно легко и ошибки там маловероятны!
      
      let allProductCarboSum     = compObj.listProduct.map{$0.carboInPortion}.sum()
      let allInsulinByCarboMLSum = compObj.listProduct.map{$0.userSetInsulinOnCarbo}.sum()
   
      let meanInsulinByCarbo = allInsulinByCarboMLSum / allProductCarboSum
      
      
      if sugarCorrectWorker.optimalSugarLevel.isLess(than: compObj.sugarAfter) {
        //
        let sugarError = Float(compObj.sugarAfter - sugarCorrectWorker.optimalSugarLevel)
        let shouldHaveDoneInsulinOnMeal = meanInsulinByCarbo * sugarError
        
        CompObjRealmManager.shared.writeInsulinOnCarboInProducts(
          compObj            : compObj,
          correctKoeficient  : shouldHaveDoneInsulinOnMeal,
          isPlus: true)
        
       
      } else {
        
        let sugarError = Float(sugarCorrectWorker.optimalSugarLevel - compObj.sugarAfter)
        let shouldHaveDoneInsulinOnMeal = meanInsulinByCarbo * sugarError
        
        CompObjRealmManager.shared.writeInsulinOnCarboInProducts(
        compObj            : compObj,
        correctKoeficient  : shouldHaveDoneInsulinOnMeal,
        isPlus             : false)
        
      }
      
   
      
      
      
      // ввести новое поле процентное соотношение относительно общего totalCarbo
      // и потом умножать carboInPortion каждого продукта на это соотношение - и так мы узнаем долю продукта в обеде
      
      // потом берем сколько надо было добавить инсулина и прибавляем в том же соотношение
      // Сохраняем!
      
      
      
    }
  

    
}

  // MARK: Get Data From Realm

extension  DataEnrichmentWorker {
    
  //  private func getMeanInsulinValueOnCorrectSugar(compObj: CompansationObjectRelam) -> Double {
  //
  //
  //    // Концепция в том что я обхожусь данными того объекта который приходит! Так как в целом все данные будут только улучшатся то больших отклонений не должно быть
  //
  //    let shugarDiffLevel         = compObj.sugarDiffForMl
  //    let sugarCorrectInsulin     = compObj.userSetInsulinToCorrectSugar.toFloat()
  //
  //    let middleInsulinOnTheSugar = sugarCorrectInsulin / shugarDiffLevel
  //
  //
  //    return Double(middleInsulinOnTheSugar)
  //
  //
  //  }
    

    
  }

  
