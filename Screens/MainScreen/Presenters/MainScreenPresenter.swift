//
//  MainScreenPresenter.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainScreenPresentationLogic {
  func presentData(response: MainScreen.Model.Response.ResponseType)
}

class MainScreenPresenter: MainScreenPresentationLogic {
  weak var viewController: MainScreenDisplayLogic?
  
  func presentData(response: MainScreen.Model.Response.ResponseType) {
  
  }
  
}
