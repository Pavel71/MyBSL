//
//  StatsInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol StatsBusinessLogic {
  func makeRequest(request: Stats.Model.Request.RequestType)
}

class StatsInteractor: StatsBusinessLogic {

  var presenter: StatsPresentationLogic?
  var service: StatsService?
  
  func makeRequest(request: Stats.Model.Request.RequestType) {
    if service == nil {
      service = StatsService()
    }
  }
  
}
