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

struct MainHeaderViewModel: MainTableViewHeaderCellable {
  
  var lastInjectionValue: String
  
  var lastTimeInjectionValue: String
  
  var lastShugarValueLabel: String
  
  var insulinSupplyInPanValue: String
  
  
}
