//
//  ConfirmProductListResultViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// по сути это класс ViewModel на наш resultViewModel

class ProductListResultWorker {
  
  
//  var resultViewModel = ProductListResultsViewModel(sumCarboValue: "", sumPortionValue: "", sumInsulinValue: "")
  
  
  
  private var sumCarbo: Int = 0
  private var sumPortion: Int = 0
  private var sumInsulin: Float = 0 
  
  
  // Эти значения я пока не пойму ныжны они мне для изменений или нет
  private var correctionInsulun: Float = 0 {
    
    didSet {
      sumInsulin += correctionInsulun - oldValue
    }
  }
  
  static let shared: ProductListResultWorker = {
    let viewModel = ProductListResultWorker()
    return viewModel
  }()
  
  private func getResultViewModel() -> ProductListResultsViewModel {
    

    let resultViewModel = ProductListResultsViewModel(sumCarboValue: "\(sumCarbo)", sumPortionValue: "\(sumPortion)", sumInsulinValue: "\(sumInsulin)")
    return resultViewModel

  }
  
  func getRusultViewModelByProducts(data: [ProductListViewModel]) -> ProductListResultsViewModel {
    calculateProductListResultViewModel(data:data)
    return getResultViewModel()
  }
  
  func getRusultViewModelByCorrectionInsulin(correction: Float) -> ProductListResultsViewModel {
    correctionInsulun = correction
    return getResultViewModel()
  }

  
  
  private func calculateProductListResultViewModel(data: [ProductListViewModel]) {
    
    // Carbo
    let arrayCarbo = data.map { (productViewModel) -> Int  in
      return productViewModel.carboInPortion
    }
    sumCarbo = arrayCarbo.reduce(0,+)
    
    
    // Portion
    let arrayPortion = data.map { (productViewModel) -> Int  in
      return productViewModel.portion
      
    }
    sumPortion = arrayPortion.reduce(0,+)
    
    // Insulin
    let arrayInsulin = data.map { (productViewModel) -> Float  in
      
      return productViewModel.insulinValue ?? 0
    }
    
    sumInsulin = arrayInsulin.reduce(0,+)
    
  }
  
  
  

  
  
}
