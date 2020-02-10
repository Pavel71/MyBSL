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
      }
    }
    struct Response {
      enum ResponseType {
        case getBlankViewModel
        case updateCurrentSugarInVM(sugar: String)
        case updateAddMealStateInVM(isNeed: Bool)
        
        case addProductsInProductListVM(products: [ProductRealm])
        case deleteProductsInProductListVM(products: [ProductRealm])
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
  
  var sugarCellVM   : SugarCellModel
  
  // meal Cell VM
  var addMealCellVM : AddMealCellModel
}


// MARK: Sugar Cell VM

struct SugarCellModel: SugarCellable {
  
  var correctionImage      : UIImage?

  var cellState            : SugarCellState
  
  var compansationString   : String?

  var currentSugar         : Double?
  
  var correctionSugarKoeff : Double?
  
  init(
    correctionImage      : UIImage? = nil,
    currentSugar         : Double? = nil,
    correctionSugarKoeff : Double? = nil,
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
