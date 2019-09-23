//
//  FoodPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

protocol FoodPresentationLogic {
  func presentData(response: Food.Model.Response.ResponseType)
}

class FoodPresenter: FoodPresentationLogic {
  weak var viewController: FoodDisplayLogic?
  
  func presentData(response: Food.Model.Response.ResponseType) {
    
    switch response {
      
      case .prepareDataFromRealmToViewModel(let items, let isDefaultList):
        
        let foodViewModel = getViewModelBySection(items: items, isDefaultList: isDefaultList)
       viewController?.displayData(viewModel: .setViewModel(viewModel: foodViewModel))

      case .passRealmObserver(let productRealmObserverToken):
        
        viewController?.displayData(viewModel: .setProductRealmObserver(productRealmObserver: productRealmObserverToken))
      
      case .prepareDataToFillNewProductViewModel(let categoryList, let updateProduct):
        
        let newProductVIewModel = prepareDataToNewProductView(listCategory: categoryList, updateProduct:updateProduct)
        viewController?.displayData(viewModel: .setDataToNewProductView(viewModel: newProductVIewModel))
      
      case .succesAddNewProduct(let succes):
        viewController?.displayData(viewModel: .displayAlertSaveNewProduct(succes: succes))

      
    }
    
  }
  

  
  
  private func prepareDataToNewProductView(listCategory: [String], updateProduct: ProductRealm?) -> NewProductViewModel {

    
    let newProductViewModel: NewProductViewModel
    
    if let updateProduct = updateProduct {
 
      let carboString = "\(updateProduct.carbo)"
      let massaString = "\(updateProduct.portion)"
      
      newProductViewModel = NewProductViewModel(name: updateProduct.name, carbo: carboString, category: updateProduct.category, massa: massaString, isFavorits: updateProduct.isFavorits, listCategory: listCategory)
    } else {
      // Создаем новый продукт
      newProductViewModel = NewProductViewModel(name: nil, carbo: nil, category: nil, massa: nil, isFavorits: false, listCategory: listCategory)
    }
    
    return newProductViewModel
  }
  
  
  private func getViewModelBySection(items: Results<ProductRealm>, isDefaultList: Bool) -> [FoodViewModel] {
    
    var foodViewModel: [FoodViewModel]
    
    if isDefaultList {
      
      let defaultViewModel = prepareDataToDefaultList(productsRealmArray: Array(items))
      foodViewModel = [defaultViewModel]
      
    } else {
      foodViewModel =  prepareDataToSortListByCategory(items: items)
    }
    
    return foodViewModel
  }
  
  
  // Здесь мы создаем на каждую секцию по ViewModel
  
  private func prepareDataToSortListByCategory(items: Results<ProductRealm>) -> [FoodViewModel] {
    
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
  
  

  
  private func prepareDataToDefaultList(productsRealmArray: [ProductRealm]) -> FoodViewModel {
    
    let cells = productsRealmArray.map { product in
      return self.cellViewModel(product: product)
    }
    let foodViewModel = FoodViewModel.init(items: cells)
    
    return foodViewModel
    
  }
  
  private func cellViewModel(product: ProductRealm) -> FoodViewModel.Cell {
    
    let carboString = "\(product.carbo)"
    let massaString = "\(product.portion)"
    
    return FoodViewModel.Cell.init(id: product.id, name: product.name, category: product.category, isFavorit: product.isFavorits, carbo: carboString, portion: massaString)
  }
  
}
