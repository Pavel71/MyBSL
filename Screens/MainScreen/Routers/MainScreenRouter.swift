//
//  MainScreenRouter.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainScreenRoutingLogic {
  
  func goToNewCompansationObjectScreen()
}

class MainScreenRouter: NSObject, MainScreenRoutingLogic {

  weak var viewController: MainScreenViewController?
  
  // MARK: Routing
  
  func goToNewCompansationObjectScreen() {
    
    let newVC = NewCompansationObjectScreenViewController()
    
    viewController?.navigationController?.pushViewController(newVC, animated: true)
  }
  
}
