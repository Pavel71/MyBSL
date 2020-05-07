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
  
  
  func makeRequest(request: Settings.Model.Request.RequestType) {
    
    fireBaseRequsest(request: request)
    
    

  }
  
  private func fireBaseRequsest(request: Settings.Model.Request.RequestType) {
    switch request {
      
    case .logOut:
      
      do {
        try Auth.auth().signOut()
        presenter?.presentData(response: .logOut(result: .success(true)))
      } catch(let error) {
        presenter?.presentData(response: .logOut(result: .failure(.signOutError)))
        print(error)
      }
      
      
    default:break
    }
  }
  
}
