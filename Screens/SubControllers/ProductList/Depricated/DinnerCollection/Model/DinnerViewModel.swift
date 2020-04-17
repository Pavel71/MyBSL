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
  
  
  // Dinner States
  
  var compansationFase: CompansationPosition
  var dinnerPosition: DinnerPosition
  var correctInsulinByShugarPosition: CorrectInsulinPosition
  
  
  var isPreviosDinner: Bool // Deprecated
  
  
  var shugarTopViewModel: ShugarTopViewModelable
  var productListInDinnerViewModel: ProductListInDinnerViewModel
  
  var placeInjection: String
  var train: String?
  var totalInsulin: Float

}


struct ShugarTopViewModel: ShugarTopViewModelable {
 
  

  // Корректирующий инсулин
 
  var correctInsulinByShugar: Float
  
//  var isNeedInsulinCorrectByShugar: Bool// Deprecated
//  var correctInsulinPosition: CorrectInsulinPosition
//
//  var dinnerPosition: DinnerPosition
//  var isPreviosDinner: Bool // Deprecateed
  
  var shugarBeforeValue: Float
  
  var shugarAfterValue: Float
  
  var timeBefore: Date?
  
  var timeAfter: Date?
  
  init(
  
    shugarBeforeValue: Float,
    shugarAfterValue: Float,
    timeBefore: Date?,
    timeAfter: Date?,
    correctInsulinByShugar: Float = 0.0
    
  ) {

    self.shugarBeforeValue            = shugarBeforeValue
    self.shugarAfterValue             = shugarAfterValue
    self.timeBefore                   = timeBefore
    self.timeAfter                    = timeAfter
    self.correctInsulinByShugar       = correctInsulinByShugar
    
  }
  
  
}


