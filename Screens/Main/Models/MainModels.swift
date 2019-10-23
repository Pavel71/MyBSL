//
//  MainModels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit


enum Main {
   
  enum Model {
    
    struct Request {
      
      // Interactors
      
      enum RequestType {
        
        // Метод подгружает последние 10 обедов
        case getViewModel
        
        // Update ViewModel Without Realm
        case setPortionInProduct(portion: String, rowProduct: Int)
        case setInsulinInProduct(insulin: String, rowProduct:Int,isPreviosDInner: Bool)
        case setShugarBefore(shugarBefore: String)
        case setPlaceIngections(place: String)
        case setShigarBeforeInTime(time: String)
        case setCorrectionInsulinBySHugar(correctionValue: String)
        
        // Add Product
        case addProductInNewDinner(products:[ProductRealm])
        case deleteProductFromDinner(products: [ProductRealm])
      }
    }
    
    struct Response {
      
      // Presenter
      
      enum ResponseType {
        // Пока здесь сразу пойдет модель потом переделать это в реалм данные
        case prepareViewModel(viewModel: MainViewModel)
        
        
        // UPDateViewModel
        
        case setPortionInProduct(portion: String, rowProduct: Int)
        case setInsulinInProduct(insulin: String, rowProduct:Int,isPreviosDInner:Bool)
        case setShugarBefore(shugarBefore: String)
        case setPlaceIngections(place: String)
        case setShigarBeforeInTime(time: String)
        case setCorrectionInsulinByShugar(correction: String)
        
        // Add Product
        case addProductInDinner(products:[ProductRealm])
        //Delete Product
        case deleteProductFromDinner(products: [ProductRealm])
        
      }
    }
    
    // ViewController
    
    struct ViewModel {
      
      enum ViewModelData {
        
        case setViewModel(viewModel: MainViewModel)
      }
    }
  }
  
}


struct MainViewModel {
  
  // Header Cell View Model
  var headerViewModelCell: MainTableViewHeaderCellable
  
  // Middle Cell ViewModel
  var dinnerCollectionViewModel: [DinnerViewModel]
  // Footer Cell ViewModel
  var footerViewModel: MainFooterViewModel
  
}

// Footer
struct MainFooterViewModel: MainTableViewFooterCellable {
  var totalInsulinValue: Float

}

// Header

struct MainHeaderViewModel: MainTableViewHeaderCellable {
  
  var isMenuViewControoler: Bool
  
  var lastInjectionValue: String
  
  var lastTimeInjectionValue: String
  
  var lastShugarValueLabel: String
  
  var insulinSupplyInPanValue: String
  
  init(lastInjectionValue: String,lastTimeInjectionValue: String,lastShugarValueLabel: String,insulinSupplyInPanValue: String,isMenuViewControoler: Bool = false) {
    
    self.lastInjectionValue = lastInjectionValue
    self.lastTimeInjectionValue = lastTimeInjectionValue
    self.lastShugarValueLabel = lastShugarValueLabel
    self.insulinSupplyInPanValue = insulinSupplyInPanValue
    self.isMenuViewControoler = isMenuViewControoler
  }
  
  
}

//struct MainDinnerViewModel {
//
//
//}
