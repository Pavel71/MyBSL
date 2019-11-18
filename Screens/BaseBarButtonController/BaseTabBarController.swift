//
//  BaseBarButtonController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    
    let mainContainerController = ContainerController(mainController: MainViewController(), menuController: MainMenuViewController())

    
    let mainViewController = createNavController(mainContainerController,name: "Main",imageName: "today")
    

    
    let productViewController = FoodViewController()
    
    let productController = createNavController(productViewController,name: "Products", imageName: "diet")

    
    let statsController = createNavController(MainScreenViewController(), name: "Stats", imageName: "clipboard" )
    let settingsController = createNavController(SettingsViewController(), name: "Settings", imageName: "settings")
    
    viewControllers = [
      mainViewController,
      productController,
      statsController,
      settingsController
    ]
    
  }

  
  
  func createNavController(_ viewController: UIViewController, name: String, imageName: String) -> UINavigationController {
    
    viewController.title = name
    viewController.view.backgroundColor = .white
    
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationItem.title = name
    navigationController.tabBarItem.title = name
    navigationController.tabBarItem.image = UIImage(named: imageName)
    
    return navigationController
  }
  
  
}
