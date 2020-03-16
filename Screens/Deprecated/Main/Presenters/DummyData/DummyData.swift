//
//  DummyData.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 08.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

// Класс Отвечает за генераются пустых данных готовых к заполнению
class DummyData {
  
  static func getDummyDinner() -> DinnerViewModel {
     
    let dinnerPosition: DinnerPosition = .newdinner
   
    let shugarViewModel1 = ShugarTopViewModel(shugarBeforeValue: 0.0, shugarAfterValue: 0.0, timeBefore: nil, timeAfter: nil)
     
     let result = ProductListResultsViewModel(sumCarboValue: "", sumPortionValue: "", sumInsulinValue: "")
     
     let productListViewController1 = ProductListInDinnerViewModel(
      resultsViewModel: result,
      productsData: [])
     
     let dinner1 = DinnerViewModel(
      compansationFase: .new,
      dinnerPosition: .newdinner,
      correctInsulinByShugarPosition: .dontCorrect,
      isPreviosDinner: false,
      shugarTopViewModel: shugarViewModel1,
      productListInDinnerViewModel: productListViewController1,
      placeInjection: "",
      train: nil,
      totalInsulin: 0.0)
     
     return dinner1
     
   }
   
  static func dummyMainViewModel() -> MainViewModel {
      
      let topViewModel = MainHeaderViewModel(lastInjectionValue: 0, lastTimeInjectionValue: nil, lastShugarValue: 0, insulinSupplyInPanValue: 0)
     
    let middleViewModel = [getDummyDinner()]

      return MainViewModel(headerViewModelCell: topViewModel, dinnerCollectionViewModel: middleViewModel)
      
    }
  
}
