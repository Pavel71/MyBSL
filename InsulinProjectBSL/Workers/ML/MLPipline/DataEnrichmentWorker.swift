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

  // 1 Теперь мне нужно убедится что я вношу изменения в Стату Компенсации на modife


  
    
    static let shared: DataEnrichmentWorker = {DataEnrichmentWorker()}()
    
    var sugarCorrectWorker = ShugarCorrectorWorker.shared
    var compObjRealmManager = CompObjRealmManager.shared

    
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
      
      compObjRealmManager.writeCorrectSugarInsuilin(
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
    
    
   private func  workWithMealTypeObj(compObj: CompansationObjectRelam) {
      // Если пришедший обед хорошо компенсированн то запиши все данные для ML
    
    switch compObj.compansationFaseEnum {
      
      case .good:
        
        CompObjRealmManager.shared.compensationSuccessWriteMlData(compObj: compObj)
        
      case .bad:
        
        // Итак работаем над тем кейсом что был обед - Сахар был в норме - Значит мы ошиблись в продуктах!
        
        
        workWithMealDataInBadMeal(compObj:compObj)
      default:break
    }
    
      
    }
    
    
    private func workWithMealDataInBadMeal(compObj: CompansationObjectRelam) {
      
      writeCorrectInsulinCompSugarToCompObj(
      compObj         : compObj,
      correctInsulin  : compObj.userSetInsulinToCorrectSugar,
      compPosition    : .modifidedForMl)
      
      let allProductCarboSum     = compObj.listProduct.map{$0.carboInPortion}.sum()
      let allInsulinByCarboMLSum = compObj.listProduct.map{$0.userSetInsulinOnCarbo}.sum()
   
      let meanInsulinByCarbo = allInsulinByCarboMLSum / allProductCarboSum
      
      
      if sugarCorrectWorker.optimalSugarLevel.isLess(than: compObj.sugarAfter) {
        //
        let sugarError = Float(compObj.sugarAfter - sugarCorrectWorker.optimalSugarLevel)
        let shouldHaveDoneInsulinOnMeal = meanInsulinByCarbo * sugarError
        
        compObjRealmManager.writeInsulinOnCarboInProducts(
          compObj            : compObj,
          correctKoeficient  : shouldHaveDoneInsulinOnMeal,
          isPlus: true)
        
       
      } else {
        
        let sugarError = Float(sugarCorrectWorker.optimalSugarLevel - compObj.sugarAfter)
        let shouldHaveDoneInsulinOnMeal = meanInsulinByCarbo * sugarError
        
        compObjRealmManager.writeInsulinOnCarboInProducts(
        compObj            : compObj,
        correctKoeficient  : shouldHaveDoneInsulinOnMeal,
        isPlus             : false)
        
      }

      
    }
  

    
}



  
