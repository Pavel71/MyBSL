//
//  MainInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainBusinessLogic {
  func makeRequest(request: Main.Model.Request.RequestType)
}

class MainInteractor: MainBusinessLogic {
  
  var presenter: MainPresentationLogic?
  var service: MainService?
  
  var dinnerRealmManager = DinnerRealmManager()
  
  func makeRequest(request: Main.Model.Request.RequestType) {
    if service == nil {
      service = MainService()
    }
    
    workWithML(request: request)
    workWithRealm(request: request)
    workWithCurrentDinnerViewModel(request: request)
    
    
  }
  
  // MARK: ML Requests Predict Inuslin
  
  private func workWithML(request: Main.Model.Request.RequestType) {
    // Пока просто прокидываю в презентер
    switch request {
      case .predictInsulinForProducts:
        
        // Идет Запрос на предсказание инсулина
        presenter?.presentData(response: .predictInsulinForProducts)
      
      default:break
    }
  }
  
  // MARK: Work With Realm
  
  private func workWithRealm(request: Main.Model.Request.RequestType) {
    
    switch request {
      
    case .getViewModel:
      //      let data = DinnerData.getMainViewModelDummy()
      
      let realmData = dinnerRealmManager.fetchAllData()
      
      // Пока вместо Реалма статичные данны
      presenter?.presentData(response: .prepareViewModel(realmData: realmData))
      
      
    case .saveViewModel(let viewModel):
      
      // Вот на этом этапе нам нужно засетить сахар после еды в предыдущий обед
      
      // теперь нужно распаристь модельку в Объект DinnerRealm
      let newDinnerViewModel = viewModel.dinnerCollectionViewModel.last!
      
      let dinnerRealm = createDinnerRealmObject(viewModel: newDinnerViewModel)
      
      // в Этом методе можно обновить и поле предыдущего обеда
      dinnerRealmManager.saveDinner(dinner: dinnerRealm)
      
      let realmData = dinnerRealmManager.fetchAllData()
      
      
      // Нужно запустить на бэкграундном потоке эту задачу!
      
      // Таким образом при каждом сохранение обеда будут обновлятся веса!
      trainMlModelAsyncBackground()
      
      presenter?.presentData(response: .prepareViewModel(realmData: realmData))
      
//      presenter?.presentData(response: .doAfterSaveDinnerInRealm(realmData: realmData))
      
      
      
    default: break
    }
    
    
  }
  
 
  
  // MARK: Work with ViewModel
  
  private func workWithCurrentDinnerViewModel(request: Main.Model.Request.RequestType) {
    
    switch request {
      
    case .setActualInsulinInProduct(let insulin, let rowProduct):
      
      presenter?.presentData(response: .setActualInsulinInProduct(insulin: insulin, rowProduct: rowProduct))
      
    case .setPortionInProduct(let portion, let row):
      
      presenter?.presentData(response: .setPortionInProduct(portion: portion, rowProduct: row))
      
    case .setPlaceIngections(let place):
      presenter?.presentData(response: .setPlaceIngections(place: place))
      
    case .setShugarBeforeValueAndTime(let time,let shugar):
      
//      updateShugarAfterInPreviosDinnerInRealmAndInViewModel(shugar: shugar)

      presenter?.presentData(response: .setShugarBeforeValueAndTime(time: time, shugar: shugar))

      
    case .setCorrectionInsulinBySHugar(let correctionValue):
      presenter?.presentData(response: .setCorrectionInsulinByShugar(correction: correctionValue))
    // add
    case .addProductInNewDinner(let products):
      presenter?.presentData(response: .addProductInDinner(products: products))
      
    case .deleteProductFromDinner(let products):
      presenter?.presentData(response: .deleteProductFromDinner(products: products))
      
    default:break
    }
    
  }
  
 
  
  
  
}

// MARK: ML Work

extension MainInteractor {
  
  private func trainMlModelAsyncBackground() {
     
     DispatchQueue.global().async {
      

      if self.dinnerRealmManager.getCountTrainObjects() > 5 {
        
        let train = self.dinnerRealmManager.getSimpleTrainData()
        let target = self.dinnerRealmManager.getTargretData()
        self.presenter?.presentData(response: .trainMLmodel(train: train, target: target))
      }
                    
       
     }
    
     
   }
}


// MARK: Work with Previos Dinner Update Data In Realm

extension MainInteractor {
  
  // как можно проще поступить достать этот обед из реалма изменить его и сохранить
  
  func updateShugarAfterInPreviosDinnerInRealmAndInViewModel(shugar: Float) {
    
    // По идеии это все не нужно! После нажатия сохранить! Я начинаю работать с предыдущим обедом, что то перенести туда из текущего обеда
    
    dinnerRealmManager.updateShugarAfterInPreviosDinner(shugar: shugar)
    let previosDinner = dinnerRealmManager.getPreviosDinner()
    
    presenter?.presentData(response: .updatePreviosDinnerInViewModel(prevDinner: previosDinner))

  }
  
  
  // Метод отвечает за всю работу с предыдущим обедом в зависимости от входящего сахара!
  
  private func workWithPreviosDinner(shugarNow: Float) {
    
    // Set Shugar in Previos Dinner
//    mainViewModel.setShugarAfterMeal(shugarNow: shugarNow)

//    let isGoodCompansation = ShugarCorrectorWorker.shared.isPreviosDinnerSuccessCompansation(shugarValue: shugarNow)
    
    if true {
      // Компенсация прошла успешно - теперь нужно переложить инсулин
      
      // Это мы обновляем только нашу ViewModel! А нам нужно сохранить эти изменениея в реалме в предыдущем обеде! проставить для него все флаги с этим связанные! и тогда не надо будет мучатся с моделькой
      
//      let actualInsulin = mainViewModel.getActualInsulinArray()
//
//      actualInsulin.enumerated().forEach({ (index,insulin) in
//        mainViewModel.setGoodCompansationInsulinInProducts(goodComapnsationInsulin: insulin, rowProduct: index)
//      })
//
      // Эти поля также должны быть в реалме
      
      // Для этого мне нужно новое поле в диннере successCompansationInsulin: Float
      // isSuccesCompansation: Bool
      
    } else {
      
    }
    
    // 1. Засетить сахар после еды
    // 2. Определить предыдущий обед коменсированн или нет
    // 3. Если нет то предложить алертом внести корректировку в предыдущий обед
    //    Первесети флаг successCompansation = false
    //    Показать корректирующие поля
    //    Подсветить шприц красным цветом
    //     Показать есче 1 шприц который будет отвечать за правельный инсулин
    
    //    Если все норм
    //    Переложить инсулин из актуал в goodCompansation
    //    Подсвеитть шприц зеленым цветом
    
  }
  
}


// MARK: Create RealmModel and Save Data in Realm

extension MainInteractor {

    private func createDinnerRealmObject(viewModel: DinnerViewModel) -> DinnerRealm {
      
      let placeInjections = viewModel.placeInjection
      let shugarBefore = viewModel.shugarTopViewModel.shugarBeforeValue
      let shugarAfter = viewModel.shugarTopViewModel.shugarAfterValue
      let correctionInsulin = viewModel.shugarTopViewModel.correctInsulinByShugar
      let timeShugarBefore = viewModel.shugarTopViewModel.timeBefore
      let timeShugarAfter = viewModel.shugarTopViewModel.timeAfter
      let totalInsulin = viewModel.totalInsulin
      let isNeedCorrectDinnerInsulinByShugasr = viewModel.shugarTopViewModel.isNeedInsulinCorrectByShugar
      
//      let isGoodCompansation
      
      
      // Products
      let products = viewModel.productListInDinnerViewModel.productsData
      let realmProducts = createProductForRealm(products: products)
      
      
      let dinnerRealm = DinnerRealm(
        shugarBefore: shugarBefore,
        shugarAfter: shugarAfter,
        timeShugarBefore: timeShugarBefore,
        timeShugarAfter: timeShugarAfter,
        placeInjection: placeInjections,
        trainName: viewModel.train ?? "",
        correctionInsulin: correctionInsulin,
        totalInsulin: totalInsulin,
        isNeedCorrectInsulinByShugar: isNeedCorrectDinnerInsulinByShugasr
      )
      
      dinnerRealm.listProduct.append(objectsIn: realmProducts)
      
      
      return dinnerRealm
    }
    
    private func createProductForRealm(products: [ProductListViewModel]) -> [ProductRealm] {
      
      let realmProducts = products.map(convertProductListViewModeltToProductRealm)
      return realmProducts
      
    }
    

    private func convertProductListViewModeltToProductRealm(prodViewModel: ProductListViewModel) -> ProductRealm {
      
      return ProductRealm(
        name: prodViewModel.name,
        category: prodViewModel.category,
        carboIn100Grm: prodViewModel.carboIn100Grm,
        isFavorits: prodViewModel.isFavorit,
        portion: prodViewModel.portion,
        actualInsulin: prodViewModel.insulinValue ?? 0
      )
    }
  
}
