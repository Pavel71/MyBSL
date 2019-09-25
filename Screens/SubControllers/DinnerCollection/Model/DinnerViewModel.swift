//
//  DinnerViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


struct DinnerViewModel: DinnerViewModelCell {
  
  var shugar: String
  
  var products: [ProductViewModel]
  
  var insulin: String
  
  var shugarAfterMeal: String?
  
  
}
