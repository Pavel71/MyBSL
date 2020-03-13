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
        case updateCompansationObject(compObjRealm: CompansationObjectRelam)
        
        case passCurrentSugar(sugar: String)
        case passIsNeedProductList(isNeed: Bool)
        
        case addProductsInProductList(products: [ProductRealm])
        case deleteProductsFromProductList(products: [ProductRealm])
        
        
        case updatePortionInProduct(portion: Int,index: Int)
        case updateInsulinByPerson(insulin: Float,index: Int)
        case updatePlaceInjection(place: String)
        
        case saveCompansationObjectInRealm(viewModel: NewCompObjViewModel)
      }
    }
    struct Response {
      enum ResponseType {
        
        case getBlankViewModel
        case convertCompObjRealmToVM(compObjRealm:CompansationObjectRelam)
        
        case updateCurrentSugarInVM(sugar: String)
        case updateAddMealStateInVM(isNeed: Bool)
        
        case addProductsInProductListVM(products: [ProductRealm])
        case deleteProductsInProductListVM(products: [ProductRealm])
        
        
        case updatePortionInProduct(portion: Int,index: Int)
        case updateInsulinByPerson(insulin: Float,index: Int)
        
        case updatePlaceInjection(place: String)
        case passCompansationObjRealmToVC(compObjRealm: CompansationObjectRelam)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case setViewModel(viewModel: NewCompObjViewModel)
        case passCompansationObjRealmtToMainViewController(compObjRealm: CompansationObjectRelam)
      }
    }
  }
  
}


// MARK: ViewController View Model

struct NewCompObjViewModel {
  
  var sugarCellVM     : SugarCellModel
  
  var addMealCellVM   : AddMealCellModel
  
  var injectionCellVM : InjectionPlaceModel
  
  var resultFooterVM  : ResultFooterModel
  
  var isValidData     : Bool 
}


// MARK: Sugar Cell VM

struct SugarCellModel: SugarCellable {
  
  var correctionImage      : UIImage?

  var cellState            : SugarCellState
  
  var compansationString   : String?

  var currentSugar         : Float?
  var sugarState           : CorrectInsulinPosition
  
  var correctionSugarKoeff : Float?
  
  init(
    correctionImage      : UIImage? = nil,
    currentSugar         : Float? = nil,
    sugarState           : CorrectInsulinPosition = .dontCorrect,
    correctionSugarKoeff : Float? = nil,
    compansationString   : String? = nil,
    cellState            : SugarCellState = .currentLayer
  ) {
    
    self.cellState            = cellState
    self.currentSugar         = currentSugar
    self.correctionSugarKoeff = correctionSugarKoeff
    self.compansationString   = compansationString
    self.correctionImage      = correctionImage
    self.sugarState           = sugarState
  }
  
  
}

// MARK: Add Meal Cell VM

struct AddMealCellModel: AddMealCellable {
//  var productListVM: NewProductListViewModel
  
  var isSwitcherIsEnabled = false
  var cellState: AddMealCellState
  
//  var productListVM: NewProductListViewModel
  var dinnerProductListVM: ProductListInDinnerViewModel
  
}

// MARK: InjectionPlace Cell VM

struct InjectionPlaceModel:InjectionPlaceCellable {
  var cellState: InjectionPlaceCellState
  
  var titlePlace: String
  
}

// MARK: Result  VM

struct ResultFooterModel: ResultFooterViewable {
  
  var message: String
  
  var value: String
  
  var viewState: ResultFooterViewState
  
  
  var totalInsulin: Float {
    (value as NSString).floatValue
  }
  
  var typeCompansationObject: TypeCompansationObject
    
}

enum ResultFooterViewState {
  case hidden,showed
}


