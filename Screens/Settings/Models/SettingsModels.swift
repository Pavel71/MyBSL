//
//  SettingsModels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

enum Settings {
   
  enum Model {
    struct Request {
      enum RequestType {
        case logOut
        case getViewModel
      }
    }
    struct Response {
      enum ResponseType {
        case logOut(result: Result<Bool,NetworkFirebaseError>)
        case configureViewModel
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case logOut(result: Result<Bool,NetworkFirebaseError>)
        case displayViewModel(viewModel: SettingsViewModel)
      }
    }
  }
  
}


struct SettingsViewModel {
  var sugarMetricsViewModel: SugarMeuserViewModel
}

struct SugarMeuserViewModel : ChangeSugarMeuserCellable {
  var metrics: SugarMetric
  
}
