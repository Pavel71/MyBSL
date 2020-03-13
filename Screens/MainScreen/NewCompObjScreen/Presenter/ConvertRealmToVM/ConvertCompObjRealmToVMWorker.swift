//
//  ConvertCompObjRealmToVMWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.03.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Class Отвечает за преобразование объекта из CompObjRealm to NewCompVM


final class ConvertCompObjRealmToVMWorker {
  
  // Нужно прописать всю логику заполнения модели из реалм объекта и все Остальное должно работать сразу же!
  
  static func convertCompObjRealmToVM(compObjRealm:CompansationObjectRelam) -> NewCompObjViewModel {
    
    
    return NewCompObjViewModel(sugarCellVM: <#T##SugarCellModel#>, addMealCellVM: <#T##AddMealCellModel#>, injectionCellVM: <#T##InjectionPlaceModel#>, resultFooterVM: <#T##ResultFooterModel#>, isValidData: <#T##Bool#>)
  }
  
}
