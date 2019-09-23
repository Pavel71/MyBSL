//
//  MenuFoodListViewModel.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 17/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



struct MenuProductListViewModel: MenuFoodListCellViewModelable {
  
  var id: String
  
  // MenuFoodListCellViewModelable
  var name: String
  var carboOn100Grm: String
  var isFavorit: Bool
  var isChoosen: Bool
  
  init(id: String,name: String,carboOn100Grm: String,isFavorit: Bool,isChoosen: Bool = false) {
    self.id = id
    self.name = name
    self.carboOn100Grm = carboOn100Grm
    self.isFavorit = isFavorit
    self.isChoosen = isChoosen
  }
  
}
