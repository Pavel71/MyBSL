//
//  NewCompansationObjectScreenInteractor.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol NewCompansationObjectScreenBusinessLogic {
  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType)
}

class NewCompansationObjectScreenInteractor: NewCompansationObjectScreenBusinessLogic {

  var presenter: NewCompansationObjectScreenPresentationLogic?
  var service: NewCompansationObjectScreenService?
  
  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    if service == nil {
      service = NewCompansationObjectScreenService()
    }
  }
  
}
