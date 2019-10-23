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
    case .prepareViewModel(let realmData):
      // Тут под вопросом может быть просто сразу отсюда брать но не важно
//      mainViewModel = data
      
      
      prepareMainViewModel(realmData:realmData)
      
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
      
      let currentArray = ProductListWorker.deleteProducts(products: products, newDinnerProducts: firstDinnerModel)
        mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData = currentArray
      
      calculateResultViewModel()
      calculateTotalInsulin()
      passViewModelInViewController()
      
    case .addProductInDinner(let products):
      
      
      let firstDinnerProducts = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData
      
      let currentArray = ProductListWorker.addProducts(products: products, newDinnerProducts: firstDinnerProducts)
      
      mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData = currentArray
      
      calculateResultViewModel()
      calculateTotalInsulin()
      passViewModelInViewController()
      
    case .setInsulinInProduct(let insulin,let rowProduct,let isPreviosDinner):
      
      let dinnerNumber = isPreviosDinner ? 1:0
      guard let floatInsulin = Float(insulin) else {return}
      mainViewModel.dinnerCollectionViewModel[dinnerNumber].productListInDinnerViewModel.productsData[rowProduct].insulinValue = floatInsulin
      
      calculateResultViewModel()
      calculateTotalInsulin()
      passViewModelInViewController()
      
    case .setPortionInProduct(let portion,let rowProduct):
      
      guard let portionFloat = Float(portion) else {return}
      let portionInt = Int(portionFloat)
      
      // Так как пока я жопускаю возможность изменять параметр порций только в новом обеде
      
     mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData[rowProduct].portion = portionInt
      
      calculateResultViewModel()
      // Похорошему во всех этих методах нужно изменять данные 
      
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
      
    case .setCorrectionInsulinByShugar(let correction):
      mainViewModel.dinnerCollectionViewModel[0].shugarTopViewModel.correctInsulinByShugar = (correction as NSString).floatValue
      
      // Здесь мне нужно обновить резалт кстати
      
      // Пока я думаю что стоит вынести эту общую статитсику в footer Cell! возможно здесь стоит переправить этот раздел!
      
      // Нужно это значение пересчитывать постоянно
      calculateTotalInsulin()
      passViewModelInViewController()
    default:break
    }

    
    
  }
  
  
  private func passViewModelInViewController() {
    // Нужно поставить здесь обновление резулт view
    
    viewController?.displayData(viewModel: .setViewModel(viewModel: mainViewModel))
  }

  
}

// MARK: Prepare MainViewModel From Realm Data
extension MainPresenter {
  
  func prepareMainViewModel(realmData: [DinnerRealm]) {
    
    // Во ттакой план на эту функцию!
    
    // let topViewModel
    // let middleViewModel
    // let FootrrViewmodel
    
    // let MainView Model = mainViewmodle
    
    
  }
  
}

// MARK: Worker With ProductList In Dinner

// When add New Product or delete we should calculate Again

extension MainPresenter {
  
  private func calculateResultViewModel() {
    
    let productsData = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData
    
    let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
    mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.resultsViewModel = resultViewModel
    
  }
  
  
  // May i'll create footer Worker Class
  private func calculateTotalInsulin() {
    
    let sumInsulinByProduct = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.resultsViewModel.sumInsulinValue
    let correctionInsulin = mainViewModel.dinnerCollectionViewModel[0].shugarTopViewModel.correctInsulinByShugar
    let totalInsulin = correctionInsulin + (sumInsulinByProduct as NSString).floatValue
    mainViewModel.footerViewModel.totalInsulinValue = totalInsulin
    
    
  }
  
  
  
}



// MARK: Worker With Shugar Set View

extension MainPresenter {
  
  
}
