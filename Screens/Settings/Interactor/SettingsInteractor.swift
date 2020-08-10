//
//  SettingsInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import Firebase

protocol SettingsBusinessLogic {
  func makeRequest(request: Settings.Model.Request.RequestType)
}

class SettingsInteractor: SettingsBusinessLogic {

  var presenter: SettingsPresentationLogic?
  
  var userDefaultsWorker : UserDefaultsWorker!
  var sugarMetricWorker  : SugarMetricConverter!
  var realmManager       : RealmManager!
  var updateService      : UpdateService!
  
  init() {
    userDefaultsWorker = ServiceLocator.shared.getService()
    sugarMetricWorker  = ServiceLocator.shared.getService()
    realmManager       = ServiceLocator.shared.getService()
    updateService      = ServiceLocator.shared.getService()
  }
  
  
  func makeRequest(request: Settings.Model.Request.RequestType) {
    
    fireBaseRequsest(request  : request)
    
    viewModelRequests(request : request)

  }
  
  private func viewModelRequests(request: Settings.Model.Request.RequestType) {
    
    switch request {
    case .getViewModel:
      print("Получить данные из Хранилища")
      
      // Тут самое сложное как хранить эти данные! Наверно в userDefaults будет нормально!
      let metric = userDefaultsWorker.getMetric()
      presenter?.presentData(response: .configureViewModel(metric:metric))
      
    case .changeSugarMetric(let metric):
      // Сохранить метрику с UserDefaults и FireStore
      updateMetric(metric: metric)
      presenter?.presentData(response: .configureViewModel(metric: metric))
    default:break
    }
  }
  
  private func fireBaseRequsest(request: Settings.Model.Request.RequestType) {
    switch request {
      
    case .logOut: logOut()

    default:break
    }
  }
  
}
  // MARK: Log Out
extension SettingsInteractor {
  
  private func logOut() {
    do {
        try Auth.auth().signOut()
        clearAllData()
        presenter?.presentData(response: .logOut(result: .success(true)))
      } catch(let error) {
        presenter?.presentData(response: .logOut(result: .failure(.signOutError)))
        print(error)
      }
    
    
  }
  
  private func clearAllData() {
    
    userDefaultsWorker.clearAllData()
    realmManager.deleteAllDataFromRealm()
    
  }
}

// MARK: Update Metric
extension SettingsInteractor {
  
  private func updateMetric(metric: SugarMetric) {
    updateMetricInUserDefaults(metric : metric)
    updateMetricInFireSotre(metric    : metric)
  }
  
  private func updateMetricInUserDefaults(metric: SugarMetric) {
    sugarMetricWorker.setMetric(metric: metric)
  }
  
  private func updateMetricInFireSotre(metric: SugarMetric) {
    updateService.updateSugarMetricInFireBase(isMmol: metric == .mmoll)
  }
}
