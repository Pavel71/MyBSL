//
//  MainPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
  func presentData(response: Main.Model.Response.ResponseType)
}

class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  func presentData(response: Main.Model.Response.ResponseType) {
  
  }
  
}
