//
//  MainScreenModels.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

// MARK: Main Screen Road Map

enum MainScreen {
   
  enum Model {
    
    struct Request {
      enum RequestType {
        case getViewModel
        
        // Set Data to Realm
        case setSugarVM(sugarViewModel: SugarViewModel)
        case setCompansationObjRealm(compObjRealm: CompansationObjectRelam)
        
        case deleteCompansationObj(compObjId: String)
        case getCompansationObj(compObjId: String)
      }
    }
    
    struct Response {
      enum ResponseType {
        case prepareViewModel(realmData:DayRealm)
        case passCompansationObj(compObj: CompansationObjectRelam)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case setViewModel(viewModel: MainScreenViewModel)
        case throwCompansationObjectToUpdate(compObj: CompansationObjectRelam)
      }
    }
  }
  
}

// MARK: Main Screen ViewModel

struct MainScreenViewModel: MainScreenViewModelable {

  // Для коллекции должны идти данные содержащие не только обеды!
  var collectionVCVM  : CollectionVCVM
  var chartVCVM       : ChartVCViewModel
  var insulinSupplyVM : InsulinSupplyViewModel

}

// MARK: Insulin Supply VM

struct InsulinSupplyViewModel:InsulinSupplyViewModable {
  var insulinSupply: Float
  
}

protocol CompansationObjactable {
  var id           : String                 {get set}
  var type         : TypeCompansationObject {get set}
  
}

struct CollectionVCVM {
  
  var cells : [CompansationObjactable]
  
}


enum TypeCompansationObject: Int {
  case mealObject            // Мы кушаем обед
  case correctSugarByInsulin // Мы компенсируем выскоий сахар инсулином
  case correctSugarByCarbo   // Мы компенсируем низкий сахар углеводами
  
}







// У нас будет 3 ячейки

// 1. Ячейка с обедом! Она готова
    // Она должна содержать в себе
    // Сахар до еды
    // Сахар после - ЭХто берется когда мы получаем новый компенсационный объект
    // ID обеда
    //
