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
    self.mainController = mainController
    self.menuController = menuController
    
    let menuDistance = (UIScreen.main.bounds.height / 2) + UIApplication.shared.statusBarFrame.height
    
    let mainDistance = menuDistance - Constants.customNavBarHeight - UIApplication.shared.statusBarFrame.height - Constants.HeaderInSection.heightForHeaderInSection
    
    self.showMenuAnimator = ShowMenuAnimator(mainController: mainController, menuController: menuController, menuDistanceTranslate: menuDistance, mainDistanceTranslate: mainDistance)
    
    super.init(nibName: nil, bundle: nil)
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
    
    mainController.didShowMenuProductsListViewControllerClouser = {[weak showMenuAnimator = showMenuAnimator] mainViewOffsetY in
      
      // Не знаю на сколько это законно вообще
      showMenuAnimator?.mainDistanceTranslate = mainViewOffsetY
      showMenuAnimator?.toogleMenu()
      
    }
    mainController.didPanGestureValueChange = {[weak showMenuAnimator = showMenuAnimator] gesture in
      showMenuAnimator?.handleSwipeMenu(gesture: gesture, containerView: self.view)
    }
    
  }
  
  // MENU
  
  
  // Короче если я могу просто уменьшить саму View то мне не надо ебатся и пилить ее вниз зачем то будет все проще!
  // Приду и нужно будет отладить этот момент!
  // потом еще не понятно как отрегулировать смещение если мы открываем в разных ячейках тоесть нужно поускать донизу до самой ячейки и смещать основное view  тоже!
  
  private func configureMenuController() {
    view.addSubview(menuController.view)
    addChild(menuController)
    
    
    self.menuController.view.center.y -= UIScreen.main.bounds.height
    setMenuClousers()
  }
  
  private func setMenuClousers() {
    
    menuController.didAddProductInMealClouser = {[weak mainController = mainController] productId in
      mainController?.addProductInMeal(productId: productId)
    }
  }
  
}
