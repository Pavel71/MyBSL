//
//  FoodTableViewPresenterWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift

class FoodTableViewPresenterWorker {
  
  
  
  static func getViewModelBySection(items: Results<ProductRealm>, isDefaultList: Bool) -> [FoodViewModel] {
    
    var foodViewModel: [FoodViewModel]
    
    print("Пошла работа по обработке данных в ViewModel")
    if isDefaultList {
      
      let defaultViewModel = prepareDataToDefaultList(productsRealmArray: Array(items))
      foodViewModel = [defaultViewModel]
      
    } else {
      foodViewModel =  prepareDataToListByCategory(items: items)
    }
    
    return foodViewModel
  }
  
  
  // Здесь мы создаем на каждую секцию по ViewModel
  
  // List By Section
  private static func prepareDataToListByCategory(items: Results<ProductRealm>) -> [FoodViewModel] {
    
    var productsSort = [FoodViewModel]()
    
    let groupedProducts = Dictionary(grouping: items) { (product) -> String in
      return product.category
    }
    
    let sortedKeys = groupedProducts.keys.sorted()
    
    sortedKeys.forEach { (key) in
      guard let values = groupedProducts[key] else {return}
      
      var foodViewModel = prepareDataToDefaultList(productsRealmArray: values)
      foodViewModel.sectionCategory = key
      productsSort.append(foodViewModel)
    }
    return productsSort
  }
  
  
  
  // Default List
  private static func prepareDataToDefaultList(productsRealmArray: [ProductRealm]) -> FoodViewModel {
    
    let cells = productsRealmArray.map(cellViewModel)
    
    let foodViewModel = FoodViewModel.init(items: cells)
    
    return foodViewModel
    
  }
  
  // Cell View Model
  private static func cellViewModel(product: ProductRealm) -> FoodViewModel.Cell {
    
    let carboString = "\(product.carboIn100grm)"
    let massaString = "\(product.portion)"
    
    return FoodViewModel.Cell.init(
      id: product.id,
      name: product.name,
      category: product.category,
      isFavorit: product.isFavorits,
      carbo: carboString,
      portion: massaString)
  }
  
}
