//
//  AddMealVMWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



class AddMealVMWorker {
  
  
  static func changeNeedProductList(isNeed: Bool, viewModel: inout NewCompObjViewModel) {
    viewModel.addMealCellVM.cellState = isNeed ? .productListState : .defaultState
  }
  
}
