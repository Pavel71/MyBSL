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
  
  var mainViewModel: MainViewModel!
  
  
  func presentData(response: Main.Model.Response.ResponseType) {
    
    
    switch response {
    case .prepareViewModel(let data):
      // Тут под вопросом может быть просто сразу отсюда брать но не важно
      mainViewModel = data
      
      passViewModelInViewController()
    default:break
    }
    
    updateMainViewModel(response: response)
  }
  
  
  private func createDinnerViewModel() {
    
  }
  
  // Прикол в том что мы будем разрешать пользователю редактировать предыдущий обед!
  // Для этого нужно учесть еще несколько полей для обеда кстати!
  //  1. Фактическая дозировка инсулина
  //  2. Правельная дозировка инсулина
  
  private func updateMainViewModel(response: Main.Model.Response.ResponseType) {
    
    switch response {
      
    case .deleteProductFromDinner(let products):
      
      let firstDinnerModel = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData
      
      let currentArray = MainWorker.deleteProducts(products: products, newDinnerProducts: firstDinnerModel)
        mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData = currentArray
      
      passViewModelInViewController()
      
    case .addProductInDinner(let products):
      
      
      let firstDinnerModel = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData
      let currentArray = MainWorker.addProducts(products: products, newDinnerProducts: firstDinnerModel)
      mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData.insert(contentsOf: currentArray, at: 0)
      
      passViewModelInViewController()
      
    case .setInsulinInProduct(let insulin,let rowProduct,let isPreviosDinner):
      
      let dinnerNumber = isPreviosDinner ? 1:0
      guard let floatInsulin = Float(insulin) else {return}
      mainViewModel.dinnerCollectionViewModel[dinnerNumber].productListInDinnerViewModel.productsData[rowProduct].insulinValue = floatInsulin
      passViewModelInViewController()
      
    case .setPortionInProduct(let portion,let rowProduct):
      
      guard let portionFloat = Float(portion) else {return}
      let portionInt = Int(portionFloat)
      
      // Так как пока я жопускаю возможность изменять параметр порций только в новом обеде
      
     mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData[rowProduct].portion = portionInt
      
      passViewModelInViewController()
      
    case .setPlaceIngections(let place):
      mainViewModel.dinnerCollectionViewModel[0].placeInjection = place
      passViewModelInViewController()
      
    case .setShugarBefore(let shugarBefore):
      
      mainViewModel.dinnerCollectionViewModel[0].shugarTopViewModel.shugarBeforeValue = shugarBefore
      
      passViewModelInViewController()
      
    case .setShigarBeforeInTime(let time):
      mainViewModel.dinnerCollectionViewModel[0].shugarTopViewModel.timeBefore = time
      
      passViewModelInViewController()
    default:break
    }

    
    
  }
  
  
  private func passViewModelInViewController() {
    
    viewController?.displayData(viewModel: .setViewModel(viewModel: mainViewModel))
  }
  
  
  
}


