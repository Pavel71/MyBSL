//
//  DinnerViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


struct DinnerViewModel: DinnerViewModelCellable {
  
  var isPreviosDinner: Bool = false
  
  var productListViewModel: [ProductListViewModel]
  
  var shugarBeforeEat: String
  
  var shugarAfterMeal: String?
  
  
}
