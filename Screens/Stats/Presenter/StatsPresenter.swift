//
//  StatsPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol StatsPresentationLogic {
  func presentData(response: Stats.Model.Response.ResponseType)
}

class StatsPresenter: StatsPresentationLogic {
  weak var viewController: StatsDisplayLogic?
  
  func presentData(response: Stats.Model.Response.ResponseType) {
  
  }
  
}
