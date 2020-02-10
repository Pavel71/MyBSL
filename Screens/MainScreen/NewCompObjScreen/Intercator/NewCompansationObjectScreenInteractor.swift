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

  
  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {

    
    catchViewModelRequest(request: request)
  }
  
}

// MARK: Catch View Model Requests

extension NewCompansationObjectScreenInteractor {
  
  private func catchViewModelRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    switch request {
    case .getBlankViewModel:
      presenter?.presentData(response: .getBlankViewModel)
      
    case .passCurrentSugar(let sugar):
      presenter?.presentData(response: .updateCurrentSugarInVM(sugar: sugar))
      
    case .passIsNeedProductList(let isNeed):
      presenter?.presentData(response: .updateAddMealStateInVM(isNeed: isNeed))
      
      
    case .addProductsInProductList(let products):
      
      presenter?.presentData(response: .addProductsInProductListVM(products: products))
    case .deleteProductsFromProductList(let products):
      presenter?.presentData(response: .deleteProductsInProductListVM(products: products))
    default:break
    }
    
  }
  
  
  
  
}


