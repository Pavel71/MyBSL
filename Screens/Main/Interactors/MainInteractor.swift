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
  
  var dinnerRealmManager = DinnerRealmManager()
  
  func makeRequest(request: Main.Model.Request.RequestType) {
    if service == nil {
      service = MainService()
    }
    
    
    workWithRealm(request: request)
    workWithViewModel(request: request)
    
  }
  
  // MARK: Work With Realm
  
  private func workWithRealm(request: Main.Model.Request.RequestType) {
    
    switch request {
      
    case .getViewModel:
      //      let data = DinnerData.getMainViewModelDummy()
      
      let realmData = dinnerRealmManager.fetchAllData()
      
      print(realmData)
      
      // Пока вместо Реалма статичные данны
      presenter?.presentData(response: .prepareViewModel(realmData: realmData))
      
      
    case .saveViewModel(let viewModel):
      print("Dinner to Save Realm",viewModel)
      // теперь нужно распаристь модельку в Объект DinnerRealm
      let newDinnerViewModel = viewModel.dinnerCollectionViewModel[0]
      
      let dinnerRealm = createDinnerRealmObject(viewModel: newDinnerViewModel)
      dinnerRealmManager.saveDinner(dinner: dinnerRealm)
      
      let realmData = dinnerRealmManager.fetchAllData()
      presenter?.presentData(response: .prepareViewModel(realmData: realmData))
      
//      presenter?.presentData(response: .doAfterSaveDinnerInRealm)
      
      
      
    default: break
    }
  }
  
  // MARK: Work with ViewModel
  
  private func workWithViewModel(request: Main.Model.Request.RequestType) {
    
    switch request {
    case .setInsulinInProduct(let insulin, let rowProduct,let isPreviosDinner):
      presenter?.presentData(response: .setInsulinInProduct(insulin: insulin, rowProduct: rowProduct,isPreviosDInner: isPreviosDinner))
      
    case .setPortionInProduct(let portion, let row):
      presenter?.presentData(response: .setPortionInProduct(portion: portion, rowProduct: row))
      
    case .setPlaceIngections(let place):
      presenter?.presentData(response: .setPlaceIngections(place: place))
      
    case .setShugarBeforeValueAndTime(let time,let shugar):
      presenter?.presentData(response: .setShugarBeforeValueAndTime(time: time, shugar: shugar))

      
    case .setCorrectionInsulinBySHugar(let correctionValue):
      presenter?.presentData(response: .setCorrectionInsulinByShugar(correction: correctionValue))
    // add
    case .addProductInNewDinner(let products):
      presenter?.presentData(response: .addProductInDinner(products: products))
      
    case .deleteProductFromDinner(let products):
      presenter?.presentData(response: .deleteProductFromDinner(products: products))
      
    default:break
    }
    
  }
  
  // MARK: Save Data in Realm
  
  private func createDinnerRealmObject(viewModel: DinnerViewModel) -> DinnerRealm {
    
    
    
    let placeInjections = viewModel.placeInjection
    let shugarBefore = viewModel.shugarTopViewModel.shugarBeforeValue
    let shugarAfter = viewModel.shugarTopViewModel.shugarAfterValue
    let correctionInsulin = viewModel.shugarTopViewModel.correctInsulinByShugar
    let timeShugarBefore = viewModel.shugarTopViewModel.timeBefore
    let timeShugarAfter = viewModel.shugarTopViewModel.timeAfter
    let totalInsulin = viewModel.totalInsulin
    
    let products = viewModel.productListInDinnerViewModel.productsData
    
    let realmProducts = createProductForRealm(products: products)
    
    let dinnerRealm = DinnerRealm(shugarBefore: shugarBefore, shugarAfter: shugarAfter, timeShugarBefore: timeShugarBefore, timeShugarAfter: timeShugarAfter, placeInjection: placeInjections, trainName: viewModel.train ?? "", correctionInsulin: correctionInsulin, totalInsulin: totalInsulin)
    
    dinnerRealm.listProduct.append(objectsIn: realmProducts)
    
    
    return dinnerRealm
  }
  
  private func createProductForRealm(products: [ProductListViewModel]) -> [ProductRealm] {
    
    let realmProducts = products.map(convertProductListViewModeltToProductRealm)
    return realmProducts
    
  }
  
  
  
  
  private func convertProductListViewModeltToProductRealm(prodViewModel: ProductListViewModel) -> ProductRealm {
    
    return ProductRealm(name: prodViewModel.name, category: prodViewModel.category, carbo: prodViewModel.carboInPortion, isFavorits: prodViewModel.isFavorit, portion: prodViewModel.portion, insulin: prodViewModel.insulinValue ?? 0)
  }
  
  
  
}
