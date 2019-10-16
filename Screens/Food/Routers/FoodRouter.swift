//
//  FoodRouter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol FoodRoutingLogic {
  
  
  func pushMealController(headerInSectionWorker: HeaderInSectionWorker)
  
}

class FoodRouter: NSObject, FoodRoutingLogic {

  weak var viewController: FoodViewController?
  

  // MARK: Routing
  
  func pushMealController(headerInSectionWorker: HeaderInSectionWorker) {
    
    let mealController = MealViewController(headerInSectionWorker: headerInSectionWorker)
    
    mealController.didUpdateHeaderWorkerInFoodViewController = viewController?.updateHeaderWorkerInSection
    
    let menuController = MenuInMealViewController()
    
//    let containerViewController = ContainerViewController(mealController: mealController)
    
    let newContainerController = ContainerController(mainController: mealController, menuController: menuController)
  
    
    viewController?.navigationController?.pushViewController(newContainerController, animated: true)
  }
  
}
