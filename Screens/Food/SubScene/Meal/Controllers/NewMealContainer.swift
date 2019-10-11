//
//  NewMealContainer.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 10.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class NewMealContainer: UIViewController {
  
  
  var showMenuAnimator: ShowMenuAnimator
  
  var mainController: MealViewController
  var menuController: MenuProductsListViewController
  
  init(mainController: MealViewController, menuController: MenuProductsListViewController) {
    
    print("Init New COntainer")
    
    self.mainController = mainController
    self.menuController = menuController
    
    
    
    
    self.showMenuAnimator = ShowMenuAnimator(mainController: mainController, menuController: menuController)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    print("Deinit New Container")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureMainController()
    configureMenuController()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Configure Controllers

extension NewMealContainer {
  
  
  // MAIN
  
  private func configureMainController() {
    
    view.addSubview(mainController.view)
    addChild(mainController)
    
    setMainControllerClousers()
  }
  
  private func setMainControllerClousers() {
    
    mainController.didShowMenuProductsListViewControllerClouser = {[weak showMenuAnimator,weak menuController] mainContentOffsetY in

      // Установлю выбор на default
      menuController?.setDefaultChooseProduct()
      // Не знаю на сколько это законно вообще
//      showMenuAnimator?.mainDistanceTranslate = mainViewOffsetY
      showMenuAnimator?.setMainDistanceValue(distance: mainContentOffsetY)

      showMenuAnimator?.toogleMenu()

    }
    
    mainController.didPanGestureValueChange = {[weak showMenuAnimator, weak self] gesture in
      showMenuAnimator?.handleSwipeMenu(gesture: gesture, containerView: self!.view)
    }
    
  }
  
  // MENU
  
 
  
  private func configureMenuController() {
    
    view.addSubview(menuController.view)
    addChild(menuController)
    
    
    self.menuController.view.center.y -= UIScreen.main.bounds.height
    setMenuClousers()
  }
  
  private func setMenuClousers() {
    
    menuController.didAddProductInMealClouser = {[weak mainController] productId in
      mainController?.addProductInMeal(productId: productId)
    }
    
//    menuController.didTapSwipeBackMenuButton = {[weak showMenuAnimator]  in
//      showMenuAnimator?.toogleMenu()
//    }
  }
  
}
