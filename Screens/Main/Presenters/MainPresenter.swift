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
  
  var indexNewDinner: Int  {
    return mainViewModel.dinnerCollectionViewModel.count - 1
  }
  var mainViewModel: MainViewModel!
  
  // Мне нужно сетить данные в новый обед! Либо надо отвязатся от индекса в массиве либо делать поиск по каким то другим параметрам
  
  

  
  func presentData(response: Main.Model.Response.ResponseType) {
    
    
    switch response {
    case .prepareViewModel(let realmData):
      // Тут под вопросом может быть просто сразу отсюда брать но не важно
//      mainViewModel = data

      prepareMainViewModel(realmData:realmData)
      
      passViewModelInViewController()
      
    case .doAfterSaveDinnerInRealm:
      
      print("Do after Save")
      // Нам здесь нужно добавить в модельку думми обед и начать его заполнять
//      let dummyDinner = getDummyDinner()
//
//      mainViewModel.dinnerCollectionViewModel[0].isPreviosDinner = true
//      mainViewModel.dinnerCollectionViewModel.insert(dummyDinner, at: 0)
//
//      passViewModelInViewController()
    default:break
    }
    
    updateMainViewModel(response: response)
  }
  
  

  
  // Прикол в том что мы будем разрешать пользователю редактировать предыдущий обед!
  // Для этого нужно учесть еще несколько полей для обеда кстати!
  //  1. Фактическая дозировка инсулина
  //  2. Правельная дозировка инсулина
  
  private func updateMainViewModel(response: Main.Model.Response.ResponseType) {
    
    switch response {
      
      
    case .deleteProductFromDinner(let products):

      deleteProductFromDinner(products: products)
      passViewModelInViewController()
      
    case .addProductInDinner(let products):
      
      addProductsIndDinner(products: products)
      passViewModelInViewController()
      
    case .setInsulinInProduct(let insulin,let rowProduct,let isPreviosDinner):
      
      let dinnerNumber = isPreviosDinner ? indexNewDinner - 1:indexNewDinner
      
      mainViewModel.dinnerCollectionViewModel[dinnerNumber].productListInDinnerViewModel.productsData[rowProduct].insulinValue = insulin
      
      calculateResultViewModel()
      calculateTotalInsulin()
      passViewModelInViewController()
      
    case .setPortionInProduct(let portion,let rowProduct):
      
//      guard let portionFloat = Float(portion) else {return}
      
      mainViewModel.dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData[rowProduct].portion = portion
      
      calculateResultViewModel()
      // Похорошему во всех этих методах нужно изменять данные 
      
      passViewModelInViewController()
      
    case .setPlaceIngections(let place):
      mainViewModel.dinnerCollectionViewModel[indexNewDinner].placeInjection = place
      passViewModelInViewController()
      
    case .setShugarBeforeValueAndTime(let time,let shugar):
      // Set Shugar Before
      mainViewModel.dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.shugarBeforeValue = shugar
      
      // Set Time Shugar Set
      mainViewModel.dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.timeBefore = time
        
      // Set Should Correct Insulin By SHugar
      mainViewModel.dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.isNeedInsulinCorrectByShugar = ShugarCorrectorWorker.shared.getIsShowCorrectTextField(shugarValue: shugar)
      
      passViewModelInViewController()
      
    case .setCorrectionInsulinByShugar(let correction):
      
      mainViewModel.dinnerCollectionViewModel[indexNewDinner].shugarTopViewModel.correctInsulinByShugar = correction
      
      // Здесь мне нужно обновить резалт кстати
      
      // Пока я думаю что стоит вынести эту общую статитсику в footer Cell! возможно здесь стоит переправить этот раздел!
      
      // Нужно это значение пересчитывать постоянно
      calculateTotalInsulin()
      passViewModelInViewController()
    default:break
    }

    
    
  }
  
  
  private func passViewModelInViewController() {
    // Нужно поставить здесь обновление резулт view
    viewController?.displayData(viewModel: .setViewModel(viewModel: mainViewModel))
  }

  
}

// MARK: Get DummyDinner

extension MainPresenter {
  
  
  func getNewDinnerViewModel() -> DinnerViewModel {
    
    return mainViewModel.dinnerCollectionViewModel[indexNewDinner]
  }
  
  func getDummyDinner() -> DinnerViewModel {
    
  
    let shugarViewModel1 = ShugarTopViewModel(isPreviosDinner: false, shugarBeforeValue: 0.0, shugarAfterValue: 0.0, timeBefore: nil, timeAfter: nil)
    
    let result = ProductListResultsViewModel(sumCarboValue: "", sumPortionValue: "", sumInsulinValue: "")
    
    let productListViewController1 = ProductListInDinnerViewModel(resultsViewModel: result, productsData: [], isPreviosDinner: false)
    
    let dinner1 = DinnerViewModel(isPreviosDinner: false, shugarTopViewModel: shugarViewModel1, productListInDinnerViewModel: productListViewController1, placeInjection: "", train: nil, totalInsulin: 0.0)
    
    return dinner1
    
  }
  
  private func dummyMainViewModel() {
     
     let topViewModel = MainHeaderViewModel(lastInjectionValue: 0, lastTimeInjectionValue: nil, lastShugarValue: 0, insulinSupplyInPanValue: 0)
     let middleViewModel = [getDummyDinner()]
     
     // Просто тут не понятно будет ли менятся это значение для каждого обеда! или просто будет высчитыватся для новых обедов
     
//     let footerViewModel = MainFooterViewModel(totalInsulinValue: 0)
     
     mainViewModel = MainViewModel(headerViewModelCell: topViewModel, dinnerCollectionViewModel: middleViewModel)
     
   }
  
}

// MARK: Prepare MainViewModel From Realm Data

extension MainPresenter {

  
  func prepareMainViewModel(realmData: [DinnerRealm]) {
    
    // Если пустая то надо запустить пустую форму
    if realmData.isEmpty {
      dummyMainViewModel()
    }
    
    // Во ттакой план на эту функцию!
    // Так как я буду Сортирвоать по дате то мне нужно брать самый свежий
    
    guard let lastDinner = realmData.first else {return}
    
    
    let topViewModel = prepareTopViewModel(lastDinner: lastDinner)
    let middleViewModel = prepareMiddleViewModel(dinners: realmData)
    
    
    // Просто тут не понятно будет ли менятся это значение для каждого обеда! или просто будет высчитыватся для новых обедов
    
//    let footerViewModel = MainFooterViewModel(totalInsulinValue: 0)
  
    
    mainViewModel = MainViewModel(headerViewModelCell: topViewModel, dinnerCollectionViewModel: middleViewModel)
    
    
    
  }
  
  // TopViewModel
  private func prepareTopViewModel(lastDinner: DinnerRealm) -> MainHeaderViewModel {

    // Этот класс будет отвечать за всю логику по работе с запасом инсулина
    let supplyInsulin = HeaderCellWorker.shared.getSupplyValue()
    
    return MainHeaderViewModel(lastInjectionValue: lastDinner.totalInsulin, lastTimeInjectionValue: lastDinner.timeShugarBefore, lastShugarValue: lastDinner.shugarBefore, insulinSupplyInPanValue: supplyInsulin)
  }

  // MiddleViewModel
  
  private func prepareMiddleViewModel(dinners: [DinnerRealm]) -> [DinnerViewModel] {
    
    var dinnerViewModels = Array(dinners.map(createDinnerViewModel))
    // Добавляем нашу болванку в начало списка чтобы можно было заполнять
    dinnerViewModels.append(getDummyDinner())
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
    
    return ProductListInDinnerViewModel(resultsViewModel: resultsViewModel, productsData: productsData, isPreviosDinner: dinner.isPreviosDinner)
  }
  
  private func createProductListViewModel(product:ProductRealm) -> ProductListViewModel {
    
    return ProductListViewModel(insulinValue: product.insulin, isFavorit: product.isFavorits, carboIn100Grm: product.carbo, category: product.category, name: product.name, portion: product.portion)
  }
  
}

// Add Product in Dinner or Delete Product

extension MainPresenter {
  
  // Add Product
  private func addProductsIndDinner(products: [ProductRealm]) {
    
    let firstDinnerProducts = getNewDinnerViewModel().productListInDinnerViewModel.productsData
    
    let currentArray = ProductListWorker.addProducts(products: products, newDinnerProducts: firstDinnerProducts)
    
    mainViewModel.dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData = currentArray
    
    calculateResultViewModel()
    calculateTotalInsulin()
    
  }
  
  // Delete Product
  private func deleteProductFromDinner(products: [ProductRealm]) {
    
    let firstDinnerModel = getNewDinnerViewModel().productListInDinnerViewModel.productsData
    
    let currentArray = ProductListWorker.deleteProducts(products: products, newDinnerProducts: firstDinnerModel)
    mainViewModel.dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.productsData = currentArray
    
    calculateResultViewModel()
    calculateTotalInsulin()
  }
  
}


// MARK: Worker With ProductList In Dinner

// When add New Product or delete we should calculate Again

extension MainPresenter {
  
  private func calculateResultViewModel() {
    
    let productsData = getNewDinnerViewModel().productListInDinnerViewModel.productsData
    
    let resultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: productsData)
    
    // Set
    mainViewModel.dinnerCollectionViewModel[indexNewDinner].productListInDinnerViewModel.resultsViewModel = resultViewModel
    
  }
  
  
  // May i'll create footer Worker Class
  private func calculateTotalInsulin() {
    
    
    
    let sumInsulinByProduct = getNewDinnerViewModel().productListInDinnerViewModel.resultsViewModel.sumInsulinValue
    let correctionInsulin = getNewDinnerViewModel().shugarTopViewModel.correctInsulinByShugar
    let totalInsulin = correctionInsulin + (sumInsulinByProduct as NSString).floatValue
    
    // не знаю насколько это актуально сохранять в двух местах ведь тотал инсулин идет для Диннера!
    // Set
    mainViewModel.dinnerCollectionViewModel[indexNewDinner].totalInsulin = totalInsulin
//    mainViewModel.footerViewModel.totalInsulinValue = totalInsulin
    
    
  }
  
  
  
}



// MARK: Worker With Shugar Set View

extension MainPresenter {
  
  
}
