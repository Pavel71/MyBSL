//
//  SettingsPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol SettingsPresentationLogic {
  func presentData(response: Settings.Model.Response.ResponseType)
}

class SettingsPresenter: SettingsPresentationLogic {
  weak var viewController: SettingsDisplayLogic?
  
  func presentData(response: Settings.Model.Response.ResponseType) {
    
    switch response {
    case .logOut(let result):
      viewController?.displayData(viewModel: .logOut(result: result))
      
    case .configureViewModel(let metric):
      
      let vm = createViewModel(metric: metric)
      
      viewController?.displayData(viewModel: .displayViewModel(viewModel: vm))
      
    
      
    
    }
  
  }
  
  
  
  
}
// MARK: Configure ViewModel
extension SettingsPresenter {
  
  
  
  private func createViewModel(metric: SugarMetric) -> SettingsViewModel {
    let sugsrMetricVM = SugarMeuserViewModel(metrics: metric)
    return SettingsViewModel(sugarMetricsViewModel: sugsrMetricVM)
  }
}
