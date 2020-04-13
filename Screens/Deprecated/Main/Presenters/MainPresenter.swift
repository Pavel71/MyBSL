//
//  MainPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
  func presentData(response: Main.Model.Response.ResponseType)
}

class MainPresenter: MainPresentationLogic {
  
  weak var viewController: MainDisplayLogic?
  var mlWorker = MLWorker(typeWeights: .correctCarboByInsulinWeights)

  var mainViewModel: MainViewModel!
  
  // Мне нужно сетить данные в новый обед! Либо надо отвязатся от индекса в массиве либо делать поиск по каким то другим параметрам

  
  func presentData(response: Main.Model.Response.ResponseType) {
    
    workWithMLRequests(response: response)
    prepareViewModel(response: response)
    updateMainViewModel(response: response)
    updatePreviosDinnerInViewModel(response: response)
    
  }
  
  
  // MARK: Requests Predict Insulin Work With MLWorker
  private func workWithMLRequests(response: Main.Model.Response.ResponseType) {
    
    switch response {
    case .predictInsulinForProducts:

      let insulins = getPredictInsulin()
      
      // Update MainViewModel
      for (index,insulin) in insulins.enumerated() {
        
        let insulin = (insulin * 100).rounded() / 100
        updateInsulinFields(rowProduct: index, insulin: insulin)
        
      }

      calculateResultViewModel()
      calculateTotalInsulin()
      passViewModelInViewController()
      
      
      
    case .trainMLmodel(let train,let target):
      trainMLmodel(train: train, target: target)
      
    default:break
    }
    
  }
  
  // MARK: Requests PrepareViewMdoel Form RealmData
  
  private func prepareViewModel(response: Main.Model.Response.ResponseType) {
    
    switch response {
       case .prepareViewModel(let realmData):

         prepareMainViewModel(realmData:realmData)
         passViewModelInViewController()

       default:break
       }
  }
  
  // MARK: Update PreviosDinnerInModel
  
  private func updatePreviosDinnerInViewModel(response: Main.Model.Response.ResponseType) {
    
    switch response {
    case .showMessageAboutBadCompansation:
      viewController?.displayData(viewModel: .showMessageAboutBadCompansation)
    default:break
    }
  }
  
  // MARK: Requests Update ViewModel
  private func updateMainViewModel(response: Main.Model.Response.ResponseType) {
    
    switch response {
      
      
    case .deleteProductFromDinner(let products):

      deleteProductFromDinner(products: products)
      passViewModelInViewController()
      
    case .addProductInDinner(let products):
      
      addProductsIndDinner(products: products)
      passViewModelInViewController()
      
    case .setActualInsulinInProduct(let insulin,let rowProduct):

      updateInsulinFields(rowProduct: rowProduct, insulin: insulin)

      calculateResultViewModel()
      calculateTotalInsulin()
      
      passViewModelInViewController()
      
    case .setPortionInProduct(let portion,let rowProduct):
      
      mainViewModel.setPortionInProducts(portion: portion, rowProduct: rowProduct)

      calculateResultViewModel()
      // Похорошему во всех этих методах нужно изменять данные 
      
      passViewModelInViewController()
      
    case .setPlaceIngections(let place):
      
      mainViewModel.setPlaceInjections(place: place)
      passViewModelInViewController()
      
    case .setShugarBeforeValueAndTime(let time,let shugar):
      
      workWithShugarBefore(time: time,shugar:shugar)
      passViewModelInViewController()
      
    case .setCorrectionInsulinByShugar(let correction):
      
      mainViewModel.setCorrectionInsulinByShugar(correct: correction)
      calculateTotalInsulin()
      passViewModelInViewController()
      
    default:break
    }

    
    
  }

  private func passViewModelInViewController() {
    // Нужно поставить здесь обновление резулт view
    viewController?.displayData(viewModel: .setViewModel(viewModel: mainViewModel))
  }
  
  func getNewDinnerViewModel() -> DinnerViewModel {
    return mainViewModel.getNewDinner()
    
  }

  
}

// MARK: Update PreviosDinnerInViewModel

extension MainPresenter {
  
//  private func updatePreviosDinner(dinner: DinnerRealm) {
//    let prevDinViewModel = createDinnerViewModel(dinner: dinner)
//    mainViewModel.updatePreviosDinner(prevDinner: prevDinViewModel)
//  }
  
}

// MARK: Work With ML

extension MainPresenter {
  
  // Train
  private func trainMLmodel(train: [Float],target:[Float]) {
    mlWorker.trainModelAndSetWeights(trainData: train, target: target)
  }
  
  // Predict
  private func getPredictInsulin() -> [Float] {
    
    // Нужны отдельные метода на поулчение весов и на предсказание!
    
    // Data будет загруженна из реалма
    guard let testDinner = mainViewModel.dinnerCollectionViewModel.last else {return []}
    let testProduct = testDinner.productListInDinnerViewModel.productsData.map{Float($0.carboInPortion)}
    
    return mlWorker.getPredict(testData: testProduct)

  }
  
  
}



// MARK: Prepare MainViewModel From Realm Data

extension MainPresenter {

  
  func prepareMainViewModel(realmData: [DinnerRealm]) {
    
    // Если пустая то надо запустить пустую форму
    if realmData.isEmpty {
      mainViewModel = DummyData.dummyMainViewModel()
    }

    
    guard let lastDinner = realmData.last else {return}

    let topViewModel = prepareTopViewModel(lastDinner: lastDinner)
    let middleViewModel = prepareMiddleViewModel(dinners: realmData)

    mainViewModel = MainViewModel(headerViewModelCell: topViewModel, dinnerCollectionViewModel: middleViewModel)
    
    
    
  }
  
  // TopViewModel
  private func prepareTopViewModel(lastDinner: DinnerRealm) -> MainHeaderViewModel {
    HeaderCellWorker.shared.setLastInsulinIngections(insulin: lastDinner.totalInsulin)
    // Этот класс будет отвечать за всю логику по работе с запасом инсулина
    let supplyInsulin = HeaderCellWorker.shared.getSupplyValue()
    
    
    return MainHeaderViewModel(lastInjectionValue: lastDinner.totalInsulin, lastTimeInjectionValue: lastDinner.timeShugarBefore, lastShugarValue: lastDinner.shugarBefore, insulinSupplyInPanValue: supplyInsulin)
  }

  // MiddleViewModel
  
  private func prepareMiddleViewModel(dinners: [DinnerRealm]) -> [DinnerViewModel] {
    
    var dinnerViewModels = Array(dinners.map(createDinnerViewModel))
    // Добавляем нашу болванку в начало списка чтобы можно было заполнять
    dinnerViewModels.append(DummyData.getDummyDinner())
    return dinnerViewModels
    
  }
  
  // DinnerViewModel
  private func createDinnerViewModel(dinner: DinnerRealm) -> DinnerViewModel {

    let shugarViewModel = createShugarTopInCellViewModel(dinner: dinner)
    
    let productListViewModel = createProductListInDinnerViewModel(dinner: dinner)
    
    // Position Dinner
    
    let compansationFase = CompansationPosition(rawValue: dinner.compansationFase)!
    
    let dinnerPosition: DinnerPosition = dinner.isPreviosDinner ? .previosdinner : .newdinner
    let correctInsulinByShugarPosition: CorrectInsulinPosition = dinner.isNeedCorrectInsulinByShugar ? .needCorrect : .dontCorrect
    
    return DinnerViewModel(
      compansationFase:             compansationFase,
      dinnerPosition:               dinnerPosition,
      correctInsulinByShugarPosition: correctInsulinByShugarPosition,
      
      isPreviosDinner:              dinner.isPreviosDinner,
      shugarTopViewModel:           shugarViewModel,
      productListInDinnerViewModel: productListViewModel,
      placeInjection:               dinner.placeInjection,
      train:                        dinner.trainName,
      totalInsulin:                 dinner.totalInsulin
    )
    
  }
  
  // Shugar Top VieModle
  private func createShugarTopInCellViewModel(dinner: DinnerRealm) -> ShugarTopViewModel {

    
    return ShugarTopViewModel(
      
      
      shugarBeforeValue: dinner.shugarBefore,
      shugarAfterValue: dinner.shugarAfter,
      timeBefore: dinner.timeShugarBefore,
      timeAfter: dinner.timeShugarAfter,
      correctInsulinByShugar: dinner.correctionInsulin
      
    )
  }
  
  
  // Product lIst ViewModel
  private func createProductListInDinnerViewModel(dinner: DinnerRealm) -> ProductListInDinnerViewModel {
    
    let productsData = Array(dinner.listProduct.map(createProductListViewModel))
    
    let resultsViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
    
//    let isNeedCorrectionInsulinIfActualInsulinWrong = dinner.compansationFase == 1
 
    return ProductListInDinnerViewModel(
      resultsViewModel:     resultsViewModel,
      productsData:         productsData
//      isPreviosDinner:      dinner.isPreviosDinner,
//      isNeedCorrectInsulin: isNeedCorrectionInsulinIfActualInsulinWrong
    )
  }
  
  private func createProductListViewModel(product:ProductRealm) -> ProductListViewModel {
    
    return ProductListViewModel(
      insulinValue:   product.userSetInsulinOnCarbo,
      isFavorit:      product.isFavorits,
      carboIn100Grm:  product.carboIn100grm,
      category:       product.category,
      name:           product.name,
      portion:        product.portion,
      totalCarboInMeal: 0
    )
  }
  
}

// Add Product in Dinner or Delete Product ViewModel

extension MainPresenter {
  
  // Add Product
  private func addProductsIndDinner(products: [ProductRealm]) {
    
    let firstDinnerProducts = mainViewModel.getProductsFromNewDinner()
    
    let currentArray = ProductListWorker.addProducts(products: products, newDinnerProducts: firstDinnerProducts)
    mainViewModel.setProductsInNewDinner(products: currentArray)

    calculateResultViewModel()
    calculateTotalInsulin()
    
  }
  
  // Delete Product
  private func deleteProductFromDinner(products: [ProductRealm]) {
    
    let firstDinnerModel = mainViewModel.getProductsFromNewDinner()
    
    let currentArray = ProductListWorker.deleteProducts(products: products, newDinnerProducts: firstDinnerModel)
    
    mainViewModel.setProductsInNewDinner(products: currentArray)

    calculateResultViewModel()
    calculateTotalInsulin()
  }
  
  // Update InsulinFields
  
  private func updateInsulinFields(rowProduct:Int,insulin: Float) {
    
    // Set Insuil In ViewModel
    mainViewModel.setActualInsulinInProducts(actualInsulin: insulin, rowProduct: rowProduct)

  }
  
}


// MARK: Calculate Results ProductList In Dinner

// When add New Product or delete we should calculate Again

extension MainPresenter {
  
  private func calculateResultViewModel() {
    
    let productsData = getNewDinnerViewModel().productListInDinnerViewModel.productsData
    
    let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
    
    // Set
    mainViewModel.setResultsViewModel(results: resultViewModel)

  }
  
  
  // May i'll create footer Worker Class
  private func calculateTotalInsulin() {

    let sumInsulinByProduct = getNewDinnerViewModel().productListInDinnerViewModel.resultsViewModel.sumInsulinValue
    let correctionInsulin = getNewDinnerViewModel().shugarTopViewModel.correctInsulinByShugar
    let totalInsulin = correctionInsulin + (sumInsulinByProduct as NSString).floatValue

    mainViewModel.setTotalInsulin(totalInsulin: totalInsulin)

    
  }
  
  
  
}



// MARK: Worker With Shugar Set View

extension MainPresenter {
  
  // Work With Shugar Before
  
  private func workWithShugarBefore(time: Date,shugar:Float) {
    mainViewModel.setShugarBeforeTimeIsNeedCorrect(shugarBefore: shugar, time: time)
    
  }

}
