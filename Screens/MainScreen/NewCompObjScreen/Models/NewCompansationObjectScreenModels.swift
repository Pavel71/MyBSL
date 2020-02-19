//
//  NewCompansationObjectScreenModels.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

enum NewCompansationObjectScreen {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getBlankViewModel
        case passCurrentSugar(sugar: String)
        case passIsNeedProductList(isNeed: Bool)
        
        case addProductsInProductList(products: [ProductRealm])
        case deleteProductsFromProductList(products: [ProductRealm])
        
        
        case updatePortionInProduct(portion: Int,index: Int)
        case updateInsulinByPerson(insulin: Float,index: Int)
        case updatePlaceInjection(place: String)
      }
    }
    struct Response {
      enum ResponseType {
        
        case getBlankViewModel
        case updateCurrentSugarInVM(sugar: String)
        case updateAddMealStateInVM(isNeed: Bool)
        
        case addProductsInProductListVM(products: [ProductRealm])
        case deleteProductsInProductListVM(products: [ProductRealm])
        
        
        case updatePortionInProduct(portion: Int,index: Int)
        case updateInsulinByPerson(insulin: Float,index: Int)
        
        case updatePlaceInjection(place: String)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case setViewModel(viewModel: NewCompObjViewModel)
        
      }
    }
  }
  
}


// MARK: ViewController View Model

struct NewCompObjViewModel {
  
  var sugarCellVM     : SugarCellModel
  
  var addMealCellVM   : AddMealCellModel
  
  var injectionCellVM : InjectionPlaceModel
}


// MARK: Sugar Cell VM

struct SugarCellModel: SugarCellable {
  
  var correctionImage      : UIImage?

  var cellState            : SugarCellState
  
  var compansationString   : String?

  var currentSugar         : Float?
  
  var correctionSugarKoeff : Float?
  
  init(
    correctionImage      : UIImage? = nil,
    currentSugar         : Float? = nil,
    correctionSugarKoeff : Float? = nil,
    compansationString   : String? = nil,
    cellState            : SugarCellState = .currentLayer
  ) {
    
    self.cellState            = cellState
    self.currentSugar         = currentSugar
    self.correctionSugarKoeff = correctionSugarKoeff
    self.compansationString   = compansationString
    self.correctionImage      = correctionImage
  }
  
  
}

// MARK: Add Meal Cell VM

struct AddMealCellModel: AddMealCellable {
//  var productListVM: NewProductListViewModel
  
  
  var cellState: AddMealCellState
  
//  var productListVM: NewProductListViewModel
  var dinnerProductListVM: ProductListInDinnerViewModel
  
}

// MARK: InjectionPlace Cell VM

struct InjectionPlaceModel:InjectionPlaceCellable {
  var cellState: InjectionPlaceCellState
  
  var titlePlace: String
  
}

// MARK: Result Cell VM



