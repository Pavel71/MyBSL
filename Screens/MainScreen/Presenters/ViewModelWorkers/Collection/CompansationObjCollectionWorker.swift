//
//  MealCollectionVMWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation



class CompansationObjCollectionWorker {
  
  
  // Meal View Model
  
  static func getCellViewModel(compObject: CompansationObjectRelam) -> CompansationObjactable {
    
    
    
    switch TypeCompansationObject(rawValue:compObject.typeObject)  {
    case .mealObject:
      return getMealCell(compObject:compObject)
    case .correctSugarByCarbo:
      return getCompansationObjectByCarboVM(compObject: compObject)
    case .correctSugarByInsulin:
      return getCompansationObjectVMByInsulin(compObject:compObject)
    case .none:
      return getMealCell(compObject:compObject)
    }
    
  }
  
  
  
}

// MARK: CompansationSugsrByCarbo Cell
extension CompansationObjCollectionWorker {
  
  static private func getCompansationObjectByCarboVM(compObject:CompansationObjectRelam ) -> ComapsnationByCarboVM {
    
    let topButtonVM = TopButtonViewModel(
      type: TypeCompansationObject(rawValue: compObject.typeObject)!
    )
    
    return ComapsnationByCarboVM(
      topButtonVM: topButtonVM,
      id: compObject.id,
      type: TypeCompansationObject(rawValue: compObject.typeObject)!)
  }
}



// MARK: CompansationSugarByInsulin Cell
extension CompansationObjCollectionWorker {
  
  static private func getCompansationObjectVMByInsulin(compObject: CompansationObjectRelam) -> CompansationByInsulinVM {
    
    let topButtonVM = TopButtonViewModel(
      type: TypeCompansationObject(rawValue: compObject.typeObject)!
    )
    
    return CompansationByInsulinVM(
      id: compObject.id,
      type: TypeCompansationObject(rawValue: compObject.typeObject)!,
      topButtonVM: topButtonVM)
    
  }
}


// MARK: MealCell

extension CompansationObjCollectionWorker {
  
  static private func getMealCell(compObject: CompansationObjectRelam) -> CompansationMealVM {
    
    let resultVM = ProductListResultsViewModel(
       sumCarboValue   : "12",
       sumPortionValue : "200",
       sumInsulinValue : "2.5")
       
       let mealProdVcViewModel = MealProductsVCViewModel(
         cells    : compObject.listProduct.map(getProductViewModel),
         resultVM : resultVM
       )
       
       // Нужно переименовывать объект который будем хранить в реалме не как диннер а как SugarDependencyObject
       let topButtonVM = TopButtonViewModel(
         type: TypeCompansationObject(rawValue: compObject.typeObject)!
       ) // Заглушка
       
       // Так как здесь у меня именно меал то можно проставить руками но это о разджел нужно переисать чтобы обрабатывалиьс все 3 объекта
       return CompansationMealVM(
         topButtonVM            : topButtonVM,
         type                   : TypeCompansationObject(rawValue: compObject.typeObject)!,
         id                     : compObject.id,
         mealProductVCViewModel : mealProdVcViewModel,
         compansationFase       : CompansationPosition(rawValue: compObject.compansationFase)!
       )
  }
  
  static private func getProductViewModel(product: ProductRealm) -> MealProductViewModel  {
    
    return MealProductViewModel(
      name           : product.name,
      carboInPortion : product.carboInPortion,
      portion        : product.portion,
      factInsulin    : product.actualInsulin)
  }
  
}
