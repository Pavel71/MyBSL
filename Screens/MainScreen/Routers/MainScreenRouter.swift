//
//  MainScreenRouter.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainScreenRoutingLogic {
  
  func goToNewCompansationObjectScreen(compansationObjectRealm: CompansationObjectRelam?)
}

class MainScreenRouter: NSObject, MainScreenRoutingLogic {

  weak var viewController: MainScreenViewController?
  
  // MARK: Routing
  
  func goToNewCompansationObjectScreen(compansationObjectRealm: CompansationObjectRelam?) {
    
    let newVC = NewCompansationObjectScreenViewController(compansationObjectRealm: compansationObjectRealm)
    
    let containerController = ContainerController(mainController: newVC, menuController: MainMenuViewController())
    
    // Pass ViewModel
    newVC.didPassViewModelToSaveInRealm = {[weak self] viewModel in
      self?.viewController?.passCompansationObjVMtoIntercator(compObjRealm: viewModel)
    }
    
    viewController?.navigationController?.pushViewController(containerController, animated: true)
  }
  
}
