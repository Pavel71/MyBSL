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
        case setActualInsulinInProduct(insulin: Float, rowProduct:Int)
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
        
        // MLModel Request
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
        case setActualInsulinInProduct(insulin: Float, rowProduct:Int)
        
//        case setShugarBefore(shugarBefore: Float)
//        case setShigarBeforeInTime(time: Date?)
        
        case setShugarBeforeValueAndTime(time: Date,shugar: Float)
        case setPlaceIngections(place: String)
        case setCorrectionInsulinByShugar(correction: Float)
        
        // UpdatePreviosDinnerInModel
        case updatePreviosDinner(prevDinner:DinnerRealm)
        
        // Add Product
        case addProductInDinner(products:[ProductRealm])
        //Delete Product
        case deleteProductFromDinner(products: [ProductRealm])
        
        // After Save ViewModel In Realm
//        case doAfterSaveDinnerInRealm(realmData: [DinnerRealm])
        
        // ML Worker
        case predictInsulinForProducts
        case trainMLmodel(train: [Float],target:[Float])
        
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











