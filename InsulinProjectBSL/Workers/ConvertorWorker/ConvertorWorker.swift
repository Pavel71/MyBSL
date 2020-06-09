//
//  ConvertorWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 31.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


// Class COnvert viewModle - Realm - NetwrokModel
// And Reverse COvert too

final class ConvertorWorker {
  
}



// MARK: Realm - Realm
extension ConvertorWorker {
  
  
  
  func convertCompObjRealmToSugarRealm(compObj: CompansationObjectRelam) -> SugarRealm {
    
    let sugar = compObj.sugarBefore
    
    let dataCase = getChartDataCase(compObj: compObj)
    
    return SugarRealm(
      time                 : compObj.timeCreate,
      sugar                : sugar.roundToDecimal(2),
      dataCase             : dataCase ,
      compansationObjectId : compObj.id)
  }
  
  func getChartDataCase(compObj: CompansationObjectRelam) -> ChartDataCase {
    
    // Будет возвращать что у нас обед всегда когда есть обед
    guard compObj.listProduct.isEmpty else {return .mealData}
    
    switch compObj.correctSugarPosition() {
      
    case .correctDown:
      return .correctInsulinData
    case .correctUp:
      return .correctCarboData
      
    default:
      return .sugarData
    }
    
  }
  
  
}

// MARK:Realm - NetwrokModel

extension ConvertorWorker {
  
  
  // MARK: Day
  
  func convertDayRealmToDayNetworkLayer(
    dayRealm         : DayRealm,
    listSugarRealm   : [SugarRealm],
    listCompObjRealm : [CompansationObjectRelam]) -> DayNetworkModel {
    
    let sugarsNetwork  = listSugarRealm.map(convertToSugarNetworkModel(sugarRealm:))
    let compObjNetwork = listCompObjRealm.map(convertCompObjRealmToCompObjNetworkModel(compObj:))
    
    return DayNetworkModel(
      id              : dayRealm.id,
      date            : dayRealm.date.timeIntervalSince1970,
      listSugarID     : Array(dayRealm.listSugarID),
      listCompObjID   : Array(dayRealm.listCompObjID),
      listSugarObj    : sugarsNetwork,
      listCompObj     : compObjNetwork)

  }
  
  
  // MARK: CompObj
  
  func convertCompObjRealmToCompObjNetworkModel(compObj: CompansationObjectRelam) -> CompObjNetworkModel {
    
    let listProd : [ProductNetworkModel] = compObj.listProduct.map(convertProductsRealmToProductNetworkModel)
    
    return CompObjNetworkModel(
      id                           : compObj.id,
      typeObject                   : compObj.typeObject,
      sugarBefore                  : compObj.sugarBefore,
      sugarAfter                   : compObj.sugarAfter,
      userSetInsulinToCorrectSugar : compObj.userSetInsulinToCorrectSugar,
      sugarDiffToOptimaForMl       : compObj.sugarDiffToOptimaForMl,
      insulinToCorrectSugarML      : compObj.insulinToCorrectSugarML,
      timeCreate                   : compObj.timeCreate.timeIntervalSince1970,
      compansationFase             : compObj.compansationFase,
      insulinOnTotalCarbo          : compObj.insulinOnTotalCarbo,
      totalCarbo                   : compObj.totalCarbo,
      placeInjections              : compObj.placeInjections,
      listProduct                  : listProd)
    
    
  }
  // MARK: Sugar
  func convertToSugarNetworkModel(sugarRealm: SugarRealm) -> SugarNetworkModel {
    
    return SugarNetworkModel(
      id                   : sugarRealm.id,
      sugar                : sugarRealm.sugar,
      time                 : sugarRealm.time.timeIntervalSince1970,
      dataCase             : sugarRealm.dataCase,
      compansationObjectId : sugarRealm.compansationObjectId ?? "")
  }
  
  // MARK: Product
  func convertProductsRealmToProductNetworkModel(product: ProductRealm) -> ProductNetworkModel {
    return ProductNetworkModel(
      id                    : product.id,
      name                  : product.name,
      category              : product.category,
      carboIn100grm         : product.carboIn100grm,
      portion               : product.portion,
      percantageCarboInMeal : product.percantageCarboInMeal,
      userSetInsulinOnCarbo : product.userSetInsulinOnCarbo,
      insulinOnCarboToML    : product.insulinOnCarboToML,
      isFavorits            : product.isFavorits)
  }
  
  // MARK: Meal
  func convertMealRealmToMealNetworkModel(mealRealm: MealRealm) -> MealNetworkModel {
    
    let listProduct:[ProductNetworkModel] = mealRealm.listProduct.map(convertProductsRealmToProductNetworkModel)
    
    return MealNetworkModel(
      id           : mealRealm.id,
      isExpandMeal : mealRealm.isExpandMeal,
      name         : mealRealm.name,
      typeMeal     : mealRealm.typeMeal,
      listProduct  : listProduct)
  }
  
  
}


// MARK: Netwrok - Realm
extension ConvertorWorker {
  
  
  // MARK:  Days
  
  func convertDayNetworkModelsToRealm(dayNetworkModel: DayNetworkModel) -> (DayRealm,[CompansationObjectRelam],[SugarRealm]) {
    
    let day = DayRealm(id : dayNetworkModel.id, date: Date(timeIntervalSince1970: dayNetworkModel.date))
    
    day.listSugarID.append(objectsIn: dayNetworkModel.listSugarID)
    day.listCompObjID.append(objectsIn: dayNetworkModel.listCompObjID)
    
    let compobjRealm = dayNetworkModel.listCompObj.map(convertCompObjsNetworkModelToRealm(compObjModel:))
    let sugarRealm = dayNetworkModel.listSugarObj.map(convertSugarsNetwrokModelToRealm(sugarNetworkModel:))
    
    return (day,compobjRealm,sugarRealm)
  }
  
  
  // MARK: CompObjs
  
  func convertCompObjsNetworkModelToRealm(compObjModel: CompObjNetworkModel) -> CompansationObjectRelam {
    
    let compObj = CompansationObjectRelam(
      id                       : compObjModel.id,
      timeCreate               : Date(timeIntervalSince1970:compObjModel.timeCreate),
      typeObject               : TypeCompansationObject(rawValue: compObjModel.typeObject)!,
      sugarBefore              : compObjModel.sugarBefore,
      insulinOnTotalCarbo      : compObjModel.insulinOnTotalCarbo,
      insulinInCorrectionSugar : compObjModel.userSetInsulinToCorrectSugar,
      totalCarbo               : compObjModel.totalCarbo,
      placeInjections          : compObjModel.placeInjections)
    
    
    compObj.insulinToCorrectSugarML      = compObjModel.insulinToCorrectSugarML
    compObj.sugarAfter                   = compObjModel.sugarAfter
    compObj.compansationFase             = compObjModel.compansationFase
    
    let productList = compObjModel.listProduct.map(convertProductNEtwrokModelToProductRealm)
    compObj.listProduct.append(objectsIn: productList)
    
    return compObj
  }
  
  // MARK: Sugars
  
  func convertSugarsNetwrokModelToRealm(sugarNetworkModel: SugarNetworkModel) -> SugarRealm {
    
    let sugar = SugarRealm(
      id                   : sugarNetworkModel.id,
      time                 : Date(timeIntervalSince1970: sugarNetworkModel.time),
      sugar                : sugarNetworkModel.sugar,
      dataCase             : ChartDataCase(rawValue: sugarNetworkModel.dataCase)!,
      compansationObjectId : sugarNetworkModel.compansationObjectId)
    
    return sugar
    
  }
  
  
  // MARK: Meals
  
  func convertMealNetwrokToMealRealm(mealNetworkModel: MealNetworkModel) -> MealRealm {
    let meal = MealRealm(
      id           : mealNetworkModel.id,
      name         : mealNetworkModel.name,
      typeMeal     : mealNetworkModel.typeMeal,
      isExpandMeal : mealNetworkModel.isExpandMeal)
    
    let listProduct = mealNetworkModel.listProduct.map(convertProductNEtwrokModelToProductRealm)
    
    meal.listProduct.append(objectsIn: listProduct)
    return meal
  }
  
  // MARK: Products
  
  func convertProductNEtwrokModelToProductRealm(productNetworkModel: ProductNetworkModel) -> ProductRealm {
    
    let product = ProductRealm(
      id            : productNetworkModel.id,
      name          : productNetworkModel.name,
      category      : productNetworkModel.category,
      carboIn100Grm : productNetworkModel.carboIn100grm,
      isFavorits    : productNetworkModel.isFavorits,
      portion       : productNetworkModel.portion,
      actualInsulin : productNetworkModel.userSetInsulinOnCarbo)
    
    product.percantageCarboInMeal = productNetworkModel.percantageCarboInMeal
    product.insulinOnCarboToML    = productNetworkModel.insulinOnCarboToML
    
    return product
  }
  
}


// MARK: ViewModel - Realm
extension ConvertorWorker {
  
  // Возможно нужно это безобразие переписать
  typealias TransportTuple = (sugarBefore: Double, typeObjectEnum: TypeCompansationObject, insulinCarbo: Double, insulinCorrect: Double, totalCarbo: Double, placeInjections: String, productsRealm: [ProductRealm])
  
  
  
  // MARK: Sugar
  func convertToSugarRealm(sugarVM: SugarViewModel) -> SugarRealm {
    
    
    return SugarRealm(
      time: sugarVM.time,
      sugar: sugarVM.sugar,
      dataCase: sugarVM.dataCase,
      compansationObjectId: sugarVM.compansationObjectId)
  }
  
  
  // MARK: CompObj
  func convertViewModelToCompObjRealm(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {
    
    
    let transportTuple = getTransportTuple(viewModel: viewModel)
    
    
    let compansationObjectRealm = CompansationObjectRelam(
      typeObject                  : transportTuple.typeObjectEnum,
      sugarBefore                 : transportTuple.sugarBefore,
      insulinOnTotalCarbo         : transportTuple.insulinCarbo,
      insulinInCorrectionSugar    : transportTuple.insulinCorrect,
      totalCarbo                  : transportTuple.totalCarbo,
      placeInjections             : transportTuple.placeInjections)
    
    
    compansationObjectRealm.listProduct.append(objectsIn: transportTuple.productsRealm)
    
    
    
    return compansationObjectRealm
    
  }
  
  // MARK: Get Transport Tuple
  func getTransportTuple(viewModel: NewCompObjViewModel) -> TransportTuple {
    
    let sugarBefore  = Double(viewModel.sugarCellVM.currentSugar!).roundToDecimal(2)
    let typeObject   = viewModel.resultFooterVM.typeCompansationObject
    let insulinCarbo = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumInsulinFloat).roundToDecimal(2)
    let insulinCorrect = abs(Double(viewModel.sugarCellVM.correctionSugarKoeff ?? 0).roundToDecimal(2))
    
    let totalCarbo   = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumCarboFloat).roundToDecimal(2)
    
    let placeInjections = viewModel.injectionCellVM.titlePlace
    
    let productsVM = viewModel.addMealCellVM.dinnerProductListVM.productsData
    
    let productsRealm = productsVM.map(converToProductRealm)
    
    // Set Total Carbo in Products
    productsRealm.forEach { (product) in
      product.setPercentageCarboInMeal = totalCarbo
    }
    
    
    let transportTuple:TransportTuple = (
      sugarBefore     : sugarBefore,
      typeObjectEnum  : typeObject,
      insulinCarbo    : insulinCarbo,
      insulinCorrect  : insulinCorrect,
      totalCarbo      : totalCarbo,
      placeInjections : placeInjections,
      productsRealm   : productsRealm)
    return transportTuple
  }
  
  // MARK: ProductViewModelList
  func converToProductRealm(viewModel: ProductListViewModel) -> ProductRealm {
    
    
    // просто сюда нужно передать общее кол-во углеводов в обеде! и все будет нормально
    return ProductRealm(
      name                  : viewModel.name,
      category              : viewModel.category,
      carboIn100Grm         : viewModel.carboIn100Grm,
      isFavorits            : viewModel.isFavorit,
      portion               : viewModel.portion ,
      actualInsulin         : viewModel.insulinValue!.roundToDecimal(2))
  }
  
  // MARK: FoodCellViewModel
  func convertFoodCellVMtoProductRealm(viewModel: FoodCellViewModel) -> ProductRealm {
    
    let name       = viewModel.name
    let category   = viewModel.category
    let carbo      = Int(viewModel.carbo)!
    let isFavorits = viewModel.isFavorit
    let portion      = Int(viewModel.portion)!
    
    return ProductRealm.init(
      name            : name,
      category        : category,
      carboIn100Grm   : carbo,
      isFavorits      : isFavorits,
      portion         : portion
    )
  }
  
  // MARK: Meal
  
  func createMealRealm(viewModel: MealViewModel) -> MealRealm {
    
    let newMeal = MealRealm(
      
      name         : viewModel.name,
      typeMeal     : viewModel.typeMeal,
      isExpandMeal : viewModel.isExpanded)
    return newMeal
  }
  
}


// MARK: Realm - ViewModel
// Looks In the mainScreen Presenter folders


