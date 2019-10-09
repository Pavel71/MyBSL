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
    
    let productListViewController1 = ProductListInDinnerViewModel(productsData: [product1,product2], dinnerItemResultsViewModel: result, isPreviosDinner: false)
    
    let productListViewController2 = ProductListInDinnerViewModel(productsData: [product2,product1,product2], dinnerItemResultsViewModel: result, isPreviosDinner: true)
    
    let productListViewController3 = ProductListInDinnerViewModel(productsData: [product1,product2,product1], dinnerItemResultsViewModel: result, isPreviosDinner: true)
    
    
    let dinner1 = DinnerViewModel(shugarTopViewModel: shugarViewModel1, productListInDinnerViewModel: productListViewController1)
    let dinner2 = DinnerViewModel(shugarTopViewModel: shugarViewModel2, productListInDinnerViewModel: productListViewController2)
    let dinner3 = DinnerViewModel(shugarTopViewModel: shugarViewModel3, productListInDinnerViewModel: productListViewController3)
    
    
    
    let dinnerViewModels = [
      dinner1
    ]
    return dinnerViewModels
  }
}
