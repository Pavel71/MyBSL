//
//  DinnerViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// DinnerViewModelCellable
struct DinnerViewModel: DinnerViewModelCellable {
  
  var shugarTopViewModel: ShugarTopViewModelable
  var productListInDinnerViewModel: ProductListInDinnerViewModel

}




struct ShugarTopViewModel: ShugarTopViewModelable {
  
  var isPreviosDinner: Bool
  
  var shugarBeforeValue: String
  
  var shugarAfterValue: String
  
  var timeBefore: String
  
  var timeAfter: String
  
  
}


