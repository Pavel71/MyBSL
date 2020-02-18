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
    workWithProductList(request: request)
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
      
      
    default:break
    }
    
  }
  
  private func workWithProductList(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    switch request {
       
       
     case .addProductsInProductList(let products):
       
       presenter?.presentData(response: .addProductsInProductListVM(products: products))
       
     case .deleteProductsFromProductList(let products):
       presenter?.presentData(response: .deleteProductsInProductListVM(products: products))
      
      
    case .updatePortionInProduct(let portion, let index):
      
      presenter?.presentData(response: .updatePortionInProduct(portion: portion, index: index))
    case .updateInsulinByPerson(let insulin, let index):
      presenter?.presentData(response: .updateInsulinByPerson(insulin: insulin, index: index))
       
     default:break
     }
    
  }
  
  
  
  
}


