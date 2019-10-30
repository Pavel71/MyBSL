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
        case setPortionInProduct(portion: Int, rowProduct: Int)
        case setInsulinInProduct(insulin: Float, rowProduct:Int,isPreviosDInner: Bool)
//        case setShugarBefore(shugarBefore: Float)
//        case setShigarBeforeInTime(time: Date)
        
        case setShugarBeforeValueAndTime(time: Date,shugar: Float)
        
        case setPlaceIngections(place: String)
        
        case setCorrectionInsulinBySHugar(correctionValue: Float)
        
        // Add Product
        case addProductInNewDinner(products:[ProductRealm])
        case deleteProductFromDinner(products: [ProductRealm])
        
        // Save View Model In Real // По факту нам нужен только Dinner
        case saveViewModel(viewModel: MainViewModel)
        // Predict Insulin
        case predictInsulinForProducts
      }
    }
    
    struct Response {
      
      // Presenter
      
      enum ResponseType {
        // Пока здесь сразу пойдет модель потом переделать это в реалм данные
        case prepareViewModel(realmData: [DinnerRealm])
        
        
        // UPDateViewModel
        
        case setPortionInProduct(portion: Int, rowProduct: Int)
        case setInsulinInProduct(insulin: Float, rowProduct:Int,isPreviosDInner:Bool)
        
//        case setShugarBefore(shugarBefore: Float)
//        case setShigarBeforeInTime(time: Date?)
        
        case setShugarBeforeValueAndTime(time: Date,shugar: Float)
        
        case setPlaceIngections(place: String)
        
        case setCorrectionInsulinByShugar(correction: Float)
        
        // Add Product
        case addProductInDinner(products:[ProductRealm])
        //Delete Product
        case deleteProductFromDinner(products: [ProductRealm])
        
        // After Save ViewModel In Realm
//        case doAfterSaveDinnerInRealm(realmData: [DinnerRealm])
        
        // PredictInsulinForProducts
        case predictInsulinForProducts
        
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
//  var footerViewModel: MainFooterViewModel
  
}

// Footer
//struct MainFooterViewModel: MainTableViewFooterCellable {
//  var totalInsulinValue: Float
//
//}

// Header

struct MainHeaderViewModel: MainTableViewHeaderCellable {
  
//  var isMenuViewControoler: Bool
  
  var lastInjectionValue: Float
  
  var lastTimeInjectionValue: Date?
  
  var lastShugarValue: Float
  
  var insulinSupplyInPanValue: Float
  
  init(lastInjectionValue: Float,lastTimeInjectionValue: Date?,lastShugarValue: Float,insulinSupplyInPanValue: Float) {
    
    self.lastInjectionValue = lastInjectionValue
    self.lastTimeInjectionValue = lastTimeInjectionValue
    self.lastShugarValue = lastShugarValue
    self.insulinSupplyInPanValue = insulinSupplyInPanValue
//    self.isMenuViewControoler = isMenuViewControoler
  }
  
  
}

//struct MainDinnerViewModel {
//
//
//}
