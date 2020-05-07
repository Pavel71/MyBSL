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
      }
    }
    struct Response {
      enum ResponseType {
        case logOut(result: Result<Bool,NetworkFirebaseError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case logOut(result: Result<Bool,NetworkFirebaseError>)
      }
    }
  }
  
}
