//
//  SettingsPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol SettingsPresentationLogic {
  func presentData(response: Settings.Model.Response.ResponseType)
}

class SettingsPresenter: SettingsPresentationLogic {
  weak var viewController: SettingsDisplayLogic?
  
  func presentData(response: Settings.Model.Response.ResponseType) {
    
    switch response {
    case .logOut(let result):
      viewController?.displayData(viewModel: .logOut(result: result))
    default:break
    }
  
  }
  
  
  
  
}
