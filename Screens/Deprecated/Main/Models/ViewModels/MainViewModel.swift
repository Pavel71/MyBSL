//
//  MainViewModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 08.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


struct MainViewModel {
  
  
  // MARK: Properties
  
  // Header Cell View Model
  var headerViewModelCell: MainTableViewHeaderCellable
  
  // Middle Cell ViewModel
  var dinnerCollectionViewModel: [DinnerViewModel]

  // Computed Properties
  
  var indexNewDinner: Int  {
     return dinnerCollectionViewModel.count - 1
   }
  var indexPreviosDinner: Int {
    return indexNewDinner - 1
  }
  
  
 

}



// MARK: Get Function

extension MainViewModel {
  
  func getNewDinner() -> DinnerViewModel {
    return dinnerCollectionViewModel[indexNewDinner]
  }
  
  func getProductsFromNewDinner() -> [ProductListViewModel] {
    return dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData
  }
  
  // Previos Dinner
  func getActualInsulinArrayFromPreviosDinner() -> [Float] {
    
     return dinnerCollectionViewModel[indexPreviosDinner].productListInDinnerViewModel.productsData.map{$0.insulinValue!}
  }
  
}

// Похорошему все эти сеты нужно прописывать и для диннера тоже

// MARK: Set Function Current Dinner

extension MainViewModel {
  

   // Set Actual Insulin
   mutating func setActualInsulinInProducts(actualInsulin: Float,rowProduct:Int) {
     dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData[rowProduct].insulinValue = actualInsulin
   }
  
  mutating func setGoodCompansationInsulinInProducts(goodComapnsationInsulin: Float,rowProduct:Int) {
    dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData[rowProduct].correctInsulinValue = goodComapnsationInsulin
  }
   // Set Portion
   mutating func setPortionInProducts(portion: Int,rowProduct: Int) {
     dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData[rowProduct].portion = portion
   }
   // Set Place Injections
   mutating func setPlaceInjections(place: String) {
     dinnerCollectionViewModel[indexNewDinner].placeInjection = place
   }
  // Set correction Insulin
   mutating func setCorrectionInsulinByShugar(correct: Float) {
     dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.correctInsulinByShugar = correct
   }
  
  // Set Products
  
  mutating func setProductsInNewDinner(products:[ProductListViewModel]) {
    dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData = products
  }
  
  // Set ResultViewModel
  mutating func setResultsViewModel(results:  ProductListResultsViewModel) {
    dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.resultsViewModel = results
  }
  
  // Set Total Insulin
  mutating func setTotalInsulin(totalInsulin: Float) {
    dinnerCollectionViewModel[indexNewDinner].totalInsulin = totalInsulin
  }
  
  // Set ShugsarBefore And Time And IsNeedCorrect
  
  mutating func setShugarBeforeTimeIsNeedCorrect(shugarBefore: Float,time: Date) {
    
    // Set Shugar Before
    dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.shugarBeforeValue = shugarBefore
    
    // Set Time Shugar Set
    dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.timeBefore = time
      
    // Set Should Correct Insulin By SHugar
//    dinnerCollectionViewModel[indexNewDinner].correctInsulinByShugarPosition = ShugarCorrectorWorker.shared.getCorrectInsulinBySugarPosition(sugar: Float(shugarBefore))
//    dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.isNeedInsulinCorrectByShugar = ShugarCorrectorWorker.shared.isPreviosDinnerFalledCompansation(shugarValue: shugarBefore)
  }
}

// MARK: Set In PreviosDinner

extension MainViewModel {
  
  // Set Shugar After
//   mutating func setShugarAfterMeal(shugarNow: Float) {
//     dinnerCollectionViewModel[indexPreviosDinner].shugarTopViewModel.shugarAfterValue = shugarNow
//   }
  
  mutating func updatePreviosDinner(prevDinner: DinnerViewModel) {
    dinnerCollectionViewModel[indexPreviosDinner] = prevDinner
  }
  
}

