//
//  DinnerData.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation


class DinnerData {
  
  static func getData() -> [DinnerViewModel] {
    // Set DummyViewModel
    
    
    
    let product1 = ProductListViewModel(insulinValue: 0, carboIn100Grm: 5, name: "Макароны", portion: 200)
    let product2 = ProductListViewModel(insulinValue: nil, carboIn100Grm: 11, name: "Абрикосы", portion: 156)
    
    let shugarViewModel1 = ShugarTopViewModel(isPreviosDinner: false, shugarBeforeValue: "5.5", shugarAfterValue: "4", timeBefore: "11/09/19 12:30", timeAfter: "11/09/19 13:30")
    let shugarViewModel2 = ShugarTopViewModel(isPreviosDinner: true, shugarBeforeValue: "12.5", shugarAfterValue: "13", timeBefore: "11/09/19 12:30", timeAfter: "11/09/19 13:30")
    let shugarViewModel3 = ShugarTopViewModel(isPreviosDinner: true, shugarBeforeValue: "7.5", shugarAfterValue: "6", timeBefore: "11/09/19 12:30", timeAfter: "11/09/19 13:30")
    
    let result = ProductListResultsViewModel(sumCarboValue: "12", sumPortionValue: "25", sumInsulinValue: "33")
    
    let productListViewController1 = ProductListInDinnerViewModel(resultsViewModel: result, productsData: [], isPreviosDinner: false)
    
    let productListViewController2 = ProductListInDinnerViewModel(resultsViewModel: result, productsData: [product2,product1,product2], isPreviosDinner: true)
    
    let productListViewController3 = ProductListInDinnerViewModel(resultsViewModel: result, productsData: [product1,product2,product1], isPreviosDinner: true)
    
    
    let dinner1 = DinnerViewModel(shugarTopViewModel: shugarViewModel1, productListInDinnerViewModel: productListViewController1, placeInjection: "", train: nil)
    let dinner2 = DinnerViewModel(shugarTopViewModel: shugarViewModel2, productListInDinnerViewModel: productListViewController2, placeInjection: "", train: nil)
    let dinner3 = DinnerViewModel(shugarTopViewModel: shugarViewModel3, productListInDinnerViewModel: productListViewController3, placeInjection: "", train: nil)
    
    // Нужен какойто метод который будет создавать заглушку с пустым dinnerom и вставлять его в viewModel! Но это должна делать реалм схема!
    
    let dinnerViewModels = [
      dinner1
    ]
    return dinnerViewModels
  }
  
  // Задача функции возвращать пустую стандартную модель - заготовку для заполнения!
  static func getDummyDinner() -> DinnerViewModel {
    
    let shugarViewModel1 = ShugarTopViewModel(isPreviosDinner: false, shugarBeforeValue: "", shugarAfterValue: "", timeBefore: "", timeAfter: "")
    
    let result = ProductListResultsViewModel(sumCarboValue: "12", sumPortionValue: "25", sumInsulinValue: "33")
    
    let productListViewController1 = ProductListInDinnerViewModel(resultsViewModel: result, productsData: [], isPreviosDinner: false)
    
    let dinner1 = DinnerViewModel(shugarTopViewModel: shugarViewModel1, productListInDinnerViewModel: productListViewController1, placeInjection: "", train: nil)
    
    return dinner1
    
  }
  
  
  static func getMainViewModelDummy() -> MainViewModel {
    
    let headerViewModel = MainHeaderViewModel.init(lastInjectionValue: "1.5", lastTimeInjectionValue: "13:30", lastShugarValueLabel: "7.5", insulinSupplyInPanValue: "156")
    
    let dinnerViewModels = DinnerData.getDummyDinner()
    
    let mainViewModel = MainViewModel.init(headerViewModelCell: headerViewModel, dinnerCollectionViewModel: [dinnerViewModels])
    
    return mainViewModel
  }
  
}
