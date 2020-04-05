//
//  ChartVMWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import Charts

// Класс отвечает за преобразование данных из реалма в ViewModel


class ChartVMWorker {
  
  
  static func getChartViewModel(sugarRealm: SugarRealm) -> SugarViewModel {
  
    
     let sugarViewModel = SugarViewModel(
       compansationObjectId : sugarRealm.compansationObjectId,
       dataCase             : ChartDataCase(rawValue: sugarRealm.dataCase)!,
       sugar                : sugarRealm.sugar,
       time                 : sugarRealm.time
       
       
     )
     
    return sugarViewModel
   }
  
  
  
  
  
}
