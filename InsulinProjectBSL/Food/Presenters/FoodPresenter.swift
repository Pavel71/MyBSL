//
//  FoodPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

protocol FoodPresentationLogic {
  func presentData(response: Food.Model.Response.ResponseType)
}

class FoodPresenter: FoodPresentationLogic {
  
  weak var viewController: FoodDisplayLogic?
  
  func presentData(response: Food.Model.Response.ResponseType) {
    
    
    workWithNewFoodViewModel(response: response)
    workWithTableViewViewModel(response: response)
    switch response {

      case .succesAddNewProduct(let succes):
        viewController?.displayData(viewModel: .displayAlertSaveNewProduct(succes: succes))
    
    default:break
      
    }
    
  }
  
  // New Food View View Model
  private func workWithNewFoodViewModel(response:Food.Model.Response.ResponseType) {
    
    switch response {
      case .prepareDataToFillNewProductViewModel(let categoryList, let updateProduct):
        
        let newProductViewModel = NewFoodViewPresenterWorker.prepareDataToNewProductView(listCategory: categoryList, updateProduct: updateProduct)
        
        viewController?.displayData(viewModel: .setDataToNewProductView(viewModel: newProductViewModel))
    default:break
    }
  }
  
  // TableView View Model
  private func workWithTableViewViewModel(response:Food.Model.Response.ResponseType) {
    
    switch response {
      // TableView Model
      case .prepareDataFromRealmToViewModel(let items, let isDefaultList):
        
        let foodViewModel = FoodTableViewPresenterWorker.getViewModelBySection(items: items, isDefaultList: isDefaultList)
        viewController?.displayData(viewModel: .setViewModel(viewModel: foodViewModel))
      
      // Realm Observer Token
      case .passRealmObserver(let productRealmObserverToken):
        
        viewController?.displayData(viewModel: .setProductRealmObserver(productRealmObserver: productRealmObserverToken))
      
    default: break
    }
  }
  
  
  
}
