//
//  SettingsInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol SettingsBusinessLogic {
  func makeRequest(request: Settings.Model.Request.RequestType)
}

class SettingsInteractor: SettingsBusinessLogic {

  var presenter: SettingsPresentationLogic?
  var service: SettingsService?
  
  func makeRequest(request: Settings.Model.Request.RequestType) {
    if service == nil {
      service = SettingsService()
    }
  }
  
}
