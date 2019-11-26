//
//  MainScreenModels.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

// MARK: Main Screen Road Map

enum MainScreen {
   
  enum Model {
    
    struct Request {
      enum RequestType {
        case getViewModel
      }
    }
    
    struct Response {
      enum ResponseType {
        case prepareViewModel
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case setViewModel
      }
    }
  }
  
}

// MARK: Main Screen ViewModel

struct MainScreenViewModel: MainScreenViewModelable {
  
  var chartViewModel: ChartViewModel

}
