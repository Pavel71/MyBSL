//
//  NewCompansationObjectScreenModels.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

enum NewCompansationObjectScreen {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getBlankViewModel
        case passCurrentSugar(sugar: String)
      }
    }
    struct Response {
      enum ResponseType {
        case getBlankViewModel
        case updateCurrentSugarInVM(sugar: String)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case setViewModel(viewModel: NewCompObjViewModel)
        
      }
    }
  }
  
}


// MARK: ViewController View Model

struct NewCompObjViewModel {
  
  var sugarCellVM: SugarCellModel
  
  // meal Cell VM
}


// MARK: Sugar Cell VM

struct SugarCellModel: SugarCellable {
  

  var cellState            : SugarCellState
  
  var compansationString   : String?

  var currentSugar         : Double?
  
  var correctionSugarKoeff : Double?
  
  init(
       currentSugar         : Double? = nil,
       correctionSugarKoeff : Double? = nil,
       compansationString   : String? = nil,
       cellState            : SugarCellState = .currentLayer
  ) {
    
    self.cellState            = cellState
    self.currentSugar         = currentSugar
    self.correctionSugarKoeff = correctionSugarKoeff
    self.compansationString   = compansationString
  }
  
  
}
