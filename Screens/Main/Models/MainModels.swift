//
//  MainModels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

enum Main {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
      }
    }
    struct Response {
      enum ResponseType {
        case some
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
      }
    }
  }
  
}


struct MainViewModel {
  
  var headerViewModelCell: MainTableViewHeaderCellable
  
  var dinnerCollectionViewModel: [DinnerViewModel]
  
  
}

// Header

struct MainHeaderViewModel: MainTableViewHeaderCellable {
  
  var isMenuViewControoler: Bool
  
  var lastInjectionValue: String
  
  var lastTimeInjectionValue: String
  
  var lastShugarValueLabel: String
  
  var insulinSupplyInPanValue: String
  
  init(lastInjectionValue: String,lastTimeInjectionValue: String,lastShugarValueLabel: String,insulinSupplyInPanValue: String,isMenuViewControoler: Bool = false) {
    
    self.lastInjectionValue = lastInjectionValue
    self.lastTimeInjectionValue = lastTimeInjectionValue
    self.lastShugarValueLabel = lastShugarValueLabel
    self.insulinSupplyInPanValue = insulinSupplyInPanValue
    self.isMenuViewControoler = isMenuViewControoler
  }
  
  
}

struct MainDinnerViewModel {
  
  
}
