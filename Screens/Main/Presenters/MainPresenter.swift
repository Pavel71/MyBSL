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
  var mlWorker = MLWorker()
  

  
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
    case .updatePreviosDinner(let prevDinner):
      let prevDinViewModel = createDinnerViewModel(dinner: prevDinner)
      mainViewModel.updatePreviosDinner(prevDinner: prevDinViewModel)
      // обновляем но запрос дальше не кидаем!
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
    
    return mlWorker.getPredictInsulinTest(testData: testProduct)

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
    

    
    return DinnerViewModel(isPreviosDinner: dinner.isPreviosDinner, shugarTopViewModel: shugarViewModel, productListInDinnerViewModel: productListViewModel, placeInjection: dinner.placeInjection, train: dinner.trainName, totalInsulin: dinner.totalInsulin)
    
  }
  
  // Shugar Top VieModle
  private func createShugarTopInCellViewModel(dinner: DinnerRealm) -> ShugarTopViewModel {

    
    return ShugarTopViewModel(
      isPreviosDinner: dinner.isPreviosDinner,
      shugarBeforeValue: dinner.shugarBefore,
      shugarAfterValue: dinner.shugarAfter,
      timeBefore: dinner.timeShugarBefore,
      timeAfter: dinner.timeShugarAfter,
      correctInsulinByShugar: dinner.correctionInsulin,
      isNeedInsulinCorrectByShugar: dinner.isNeedCorrectInsulinByShugar
    )
  }
  
  
  // Product lIst ViewModel
  private func createProductListInDinnerViewModel(dinner: DinnerRealm) -> ProductListInDinnerViewModel {
    
    let productsData = Array(dinner.listProduct.map(createProductListViewModel))
    
    let resultsViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
    
    return ProductListInDinnerViewModel(
      resultsViewModel: resultsViewModel,
      productsData: productsData,
      isPreviosDinner: dinner.isPreviosDinner
    )
  }
  
  private func createProductListViewModel(product:ProductRealm) -> ProductListViewModel {
    
    return ProductListViewModel(
      insulinValue: product.actualInsulin,
      isFavorit: product.isFavorits,
      carboIn100Grm: product.carboIn100grm,
      category: product.category,
      name: product.name,
      portion: product.portion
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

//    if mainViewModel.indexNewDinner > 0 {
//
//      workWithPreviosDinner(shugarNow: shugar)
//
//    }
    
  }
  
//  // MARK: Work With Previos Dinner When Set Shugar
//  private func workWithPreviosDinner(shugarNow: Float) {
//
//    // Set Shugar in Previos Dinner
//    mainViewModel.setShugarAfterMeal(shugarNow: shugarNow)
//
//    let isGoodCompansation = ShugarCorrectorWorker.shared.isPreviosDinnerSuccessCompansation(shugarValue: shugarNow)
//
//    if isGoodCompansation {
//      // Компенсация прошла успешно - теперь нужно переложить инсулин
//
//      // Это мы обновляем только нашу ViewModel! А нам нужно сохранить эти изменениея в реалме в предыдущем обеде! проставить для него все флаги с этим связанные! и тогда не надо будет мучатся с моделькой
//
//      let actualInsulin = mainViewModel.getActualInsulinArray()
//
//      actualInsulin.enumerated().forEach({ (index,insulin) in
//        mainViewModel.setGoodCompansationInsulinInProducts(goodComapnsationInsulin: insulin, rowProduct: index)
//      })
//
//      // Эти поля также должны быть в реалме
//
//      // Для этого мне нужно новое поле в диннере successCompansationInsulin: Float
//      // isSuccesCompansation: Bool
//
//    } else {
//
//    }
//
//    // 1. Засетить сахар после еды
//    // 2. Определить предыдущий обед коменсированн или нет
//    // 3. Если нет то предложить алертом внести корректировку в предыдущий обед
//    //    Первесети флаг successCompansation = false
//    //    Показать корректирующие поля
//    //    Подсветить шприц красным цветом
//    //     Показать есче 1 шприц который будет отвечать за правельный инсулин
//
//    //    Если все норм
//    //    Переложить инсулин из актуал в goodCompansation
//    //    Подсвеитть шприц зеленым цветом
//
//  }
  
  
}
