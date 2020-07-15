//
//  StatsInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol StatsBusinessLogic {
  func makeRequest(request: Stats.Model.Request.RequestType)
}

class StatsInteractor: StatsBusinessLogic {

  var presenter: StatsPresentationLogic?
  var realmManager : RealmManager!
  
  
  init() {
    realmManager = ServiceLocator.shared.getService()
  }
  
  func makeRequest(request: Stats.Model.Request.RequestType) {

    modelRequests(request: request)
  }
  
}


// MARK: Get Data To Stats Model
extension StatsInteractor {
  
  private func modelRequests(request: Stats.Model.Request.RequestType) {
    
    switch request {
    case .getStatsModel:
      print("get stats Model")
      
      let crudeStatsData = realmManager.fetchStatsData()
      // Нужно запросить все данные из реалма чтобы сформировать сатистику!
      presenter?.presentData(response: .passStatsModelToVC(crudeStatsData:crudeStatsData))
      // 1. Запрошу данные по кол-ву хорошо скомпенсированных и плохо скомпенсированных
    default:break
    }
  }
}
