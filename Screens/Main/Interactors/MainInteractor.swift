//
//  MainInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainBusinessLogic {
  func makeRequest(request: Main.Model.Request.RequestType)
}

class MainInteractor: MainBusinessLogic {

  var presenter: MainPresentationLogic?
  var service: MainService?
  
  func makeRequest(request: Main.Model.Request.RequestType) {
    if service == nil {
      service = MainService()
    }
    
    
    workWithRealm(request: request)
    workWithViewModel(request: request)
    
  }
  
  private func workWithRealm(request: Main.Model.Request.RequestType) {
    
    switch request {
      
      case .getViewModel:
      let data = DinnerData.getMainViewModelDummy()
      // Пока вместо Реалма статичные данны
       presenter?.presentData(response: .prepareViewModel(viewModel: data))
      
      // Это возможно нужно перенести во ViewModel func
    case .addProductInNewDinner(let products):
      presenter?.presentData(response: .addProductInDinner(products: products))
      
    case .deleteProductFromDinner(let products):
      presenter?.presentData(response: .deleteProductFromDinner(products: products))
      
    default: break
    }
  }
  
  
  private func workWithViewModel(request: Main.Model.Request.RequestType) {
    
    switch request {
      case .setInsulinInProduct(let insulin, let rowProduct,let isPreviosDinner):
        presenter?.presentData(response: .setInsulinInProduct(insulin: insulin, rowProduct: rowProduct,isPreviosDInner: isPreviosDinner))
      
      case .setPortionInProduct(let portion, let row):
        presenter?.presentData(response: .setPortionInProduct(portion: portion, rowProduct: row))
      
      case .setPlaceIngections(let place):
        presenter?.presentData(response: .setPlaceIngections(place: place))
      case .setShugarBefore(let shugarBefore):
        presenter?.presentData(response: .setShugarBefore(shugarBefore: shugarBefore))
    case .setShigarBeforeInTime(let time):
      presenter?.presentData(response: .setShigarBeforeInTime(time: time))

    default:break
    }
    
  }
  
}
