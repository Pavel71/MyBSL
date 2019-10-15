//
//  NewMealContainer.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 10.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MainControllerInContainerProtocol: UIViewController, ShowMenuAnimatable {
  
  var didShowMenuProductsListViewControllerClouser: ((CGFloat) -> Void)? {get set}
  var didPanGestureValueChange: ((UIPanGestureRecognizer) -> Void)? {get set}
  
  func addProducts(products: [ProductRealm])
  
}

protocol MenuControllerInContainerProtocol: UIViewController {
  
  var didAddProductClouser: ((String) -> Void)? {get set}
  func setDefaultChooseProduct()
}

protocol ContainerProtocol {
  
  var showMenuAnimator: ShowMenuAnimator {get set}
  var mainController: MainControllerInContainerProtocol {get set}
  var menuController: MenuControllerInContainerProtocol {get set}
  
}


class ContainerController: UIViewController,ContainerProtocol {

  var showMenuAnimator: ShowMenuAnimator
  
  var mainController: MainControllerInContainerProtocol
  var menuController: MenuControllerInContainerProtocol
  
  init(mainController: MainControllerInContainerProtocol, menuController: MenuControllerInContainerProtocol) {
    
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

extension ContainerController {
  
  
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
    
    
    self.menuController.view.center.y -= Constants.screenHeight
    setMenuClousers()
  }
  
  private func setMenuClousers() {
    
    menuController.didAddProductClouser = {[weak mainController] productId in
      mainController?.addProductInMeal(productId: productId)
    }

  }
  
}
