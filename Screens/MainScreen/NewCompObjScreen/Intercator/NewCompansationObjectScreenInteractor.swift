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
      
    case .updatePlaceInjection(let place):
      presenter?.presentData(response: .updatePlaceInjection(place: place))
      
    case .saveCompansationObjectInRealm(let viewModel):
      // итак нам нужен реалм менеджер по дням который сохранит объект реалма в день
      let realmCompansationObject = convertViewModelToRealmObject(viewModel: viewModel)
      
    default:break
    }
    
  }
  
  
  // MARK: Work With Product List
  
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


// MARK: Convert View Model to Realm Object
extension NewCompansationObjectScreenInteractor {
  
  
  private func convertViewModelToRealmObject(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {
    
    return CompansationObjectRelam(
      
      typeObject: .mealObject,
      sugarBefore: 5.0,
      sugarAfter: 0,
      timeCreate: Date(),
      compansationFase: .progress,
      carbo: 20,
      insulin: 10)
    
  }
  
}







