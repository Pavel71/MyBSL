//
//  DinnerViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



// Пока напишу здесь класс Валидатор









// DinnerViewModelCellable
struct DinnerViewModel: DinnerViewModelCellable {
  
  var isPreviosDinner: Bool
  
  
  var shugarTopViewModel: ShugarTopViewModelable
  var productListInDinnerViewModel: ProductListInDinnerViewModel
  
  var placeInjection: String
  var train: String?
  var totalInsulin: Float

}


struct ShugarTopViewModel: ShugarTopViewModelable {
  
  
  // Корректирующий инсулин
  var isNeedInsulinCorrectByShugar: Bool 
  var correctInsulinByShugar: Float
  
  var isPreviosDinner: Bool
  
  var shugarBeforeValue: Float
  
  var shugarAfterValue: Float
  
  var timeBefore: Date?
  
  var timeAfter: Date?
  
  init(isPreviosDinner: Bool,shugarBeforeValue: Float,shugarAfterValue: Float,timeBefore: Date?,timeAfter: Date?,correctInsulinByShugar: Float = 0.0,isNeedInsulinCorrectByShugar:Bool = false) {
    self.isPreviosDinner = isPreviosDinner
    self.shugarBeforeValue = shugarBeforeValue
    self.shugarAfterValue = shugarAfterValue
    self.timeBefore = timeBefore
    self.timeAfter = timeAfter
    self.correctInsulinByShugar = correctInsulinByShugar
    self.isNeedInsulinCorrectByShugar = isNeedInsulinCorrectByShugar
  }
  
  
}


