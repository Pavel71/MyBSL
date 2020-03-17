//
//  NewCompansationObjectScreenInteractor.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol NewCompansationObjectScreenBusinessLogic {
  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType)
}

class NewCompansationObjectScreenInteractor: NewCompansationObjectScreenBusinessLogic {

  var presenter: NewCompansationObjectScreenPresentationLogic?
  
  

  
  func makeRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {

    
    catchViewModelRequest(request: request)
    workWithProductList(request: request)
  }
  
}

// MARK: Catch View Model Requests

extension NewCompansationObjectScreenInteractor {
  
  private func catchViewModelRequest(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    switch request {
      
    case .getBlankViewModel:
      presenter?.presentData(response: .getBlankViewModel)
      
    case .updateCompansationObject(let compObjRealm):
      
      // вот здесь мы обновляем его и тут можем сохранить в оперативочку
      
      
      presenter?.presentData(response: .convertCompObjRealmToVM(compObjRealm: compObjRealm))
      
    case .passCurrentSugar(let sugar):
      presenter?.presentData(response: .updateCurrentSugarInVM(sugar: sugar))
      
    case .passIsNeedProductList(let isNeed):
      presenter?.presentData(response: .updateAddMealStateInVM(isNeed: isNeed))
      
    case .updatePlaceInjection(let place):
      presenter?.presentData(response: .updatePlaceInjection(place: place))
      
    case .saveCompansationObjectInRealm(let viewModel):
      
      
      // я должен все таки передавать модель и если будет id то обновлять объект если нет то создавать новый и записывать! и делать это все в недрах dayRealm Manager! можно даже создать подменеджера!
      
      // Вообщем если здесь обнаруживается что у нас Есть updateID то мы можем направить данные по другому каналу! и не создавать реалм объект а передать модель и дальше ее обновить по все параметрам
      
      // или кидаем compansationObject но делаем у нег не dynamic свойство и передав его ищем по этому свойству объект если он есть то нам нужно обновить все его поля с этого объекта! Если не находим то просто добавляем объект как новый!
      
      
      
      let realmCompansationObject = convertViewModelToRealmObject(viewModel: viewModel)
      
      presenter?.presentData(response: .passCompansationObjRealmToVC(compObjRealm: realmCompansationObject))
      
      // После того как сохранили нужно убрать из оперативки объект compansationObj
      
      
    default:break
    }
    
  }
  
  
  // MARK: Work With Product List
  
  private func workWithProductList(request: NewCompansationObjectScreen.Model.Request.RequestType) {
    
    switch request {
       
       
     case .addProductsInProductList(let products):
       
       presenter?.presentData(response: .addProductsInProductListVM(products: products))
       
     case .deleteProductsFromProductList(let products):
       presenter?.presentData(response: .deleteProductsInProductListVM(products: products))
      
      
    case .updatePortionInProduct(let portion, let index):
      
      presenter?.presentData(response: .updatePortionInProduct(portion: portion, index: index))
    case .updateInsulinByPerson(let insulin, let index):
      presenter?.presentData(response: .updateInsulinByPerson(insulin: insulin, index: index))
       
     default:break
     }
    
  }

  
}


// MARK: Convert To RealmCompansationObj

extension NewCompansationObjectScreenInteractor {
  
  
  private func convertViewModelToRealmObject(viewModel: NewCompObjViewModel) -> CompansationObjectRelam {
    
    
    
    let sugarBefore  = Double(viewModel.sugarCellVM.currentSugar!).roundToDecimal(2)
    let typeObject   = viewModel.resultFooterVM.typeCompansationObject
//    let totalInsulin = Double(viewModel.resultFooterVM.totalInsulin).roundToDecimal(2)
    let insulinCarbo = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumInsulinFloat).roundToDecimal(2)
    let insulinCorrect = Double(viewModel.sugarCellVM.correctionSugarKoeff ?? 0).roundToDecimal(2)
    let totalCarbo   = Double(viewModel.addMealCellVM.dinnerProductListVM.resultsViewModel.sumCarboFloat).roundToDecimal(2)
    let placeInjections = viewModel.injectionCellVM.titlePlace
  
      let compansationObjectRealm = CompansationObjectRelam(
        typeObject               : typeObject,
        sugarBefore              : sugarBefore,
        insulinOnTotalCarbo      : insulinCarbo,
        insulinInCorrectionSugar : insulinCorrect,
        totalCarbo               : totalCarbo,
        placeInjections          : placeInjections)
        
        
      

     // тут мне теперь нужна трансформация realmProduct
     let productsVM = viewModel.addMealCellVM.dinnerProductListVM.productsData
     
     compansationObjectRealm.listProduct.append(objectsIn: productsVM.map(converToProductRealm))
    
    // Ставим свойство этот объект обновляет последний или нет!
    compansationObjectRealm.isUpdated    = viewModel.isUpdated
    compansationObjectRealm.updateThisID = viewModel.updatedId
     
     return compansationObjectRealm
 
    
  }
  
  
  
  
  
  private func converToProductRealm(viewModel: ProductListViewModel) -> ProductRealm {
     
     
     
     return ProductRealm(
       name          : viewModel.name,
       category      : viewModel.category,
       carboIn100Grm : viewModel.carboIn100Grm,
       isFavorits    : viewModel.isFavorit,
       portion       : viewModel.portion ,
       actualInsulin : viewModel.insulinValue!.roundToDecimal(2))
   }
  
}







