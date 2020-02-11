//
//  BaseContainerController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 10.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Протокол на который должны быть подписанны КОнтроллеры которые хотят работать с этим анмиаторм

protocol ShowMenuAnimatable: UIViewController {
  
  var tableView: UITableView {get}
  func setUppanGestureRecogniser()
  func removeGestureRecogniser()
}

class BaseContainerController: UIViewController {
  
  // Тут нужно подумать на сколько должна эта шторка выезжать!
  let menuScreenHeight: CGFloat = UIScreen.main.bounds.height / 2
  
  private lazy var animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
  }()
  
  private var currentState: State = .closed
  
}


// MARK: SetUP Views

//extension BaseContainerController {
//  
//
//  private func configureMainViewController() {
//    
//    controller = mainViewController
//    
//    view.addSubview(controller.view)
//    addChild(controller)
//    
//    setMenuControllerClousers()
//    
//    
//  }
//  
//  private func setMenuControllerClousers() {
//    // Нажимаем кнопочку добавить продукт
//    mainViewController.didShowMenuProductsListViewControllerClouser = {[weak self] in  self?.toogleMenu() }
//    mainViewController.didGestureRecognaserValueChange = {[weak self] gesture in
//      self?.handleSwipeMenu(gesture: gesture)
//    }
//    
//  }
//  
//  private func setUpMenuControllerView() {
//    
//    menuProductsListViewController = MenuDinnerViewController()
//    
//    menuProductsListViewController.view.center.y -= UIScreen.main.bounds.height
//    view.addSubview(menuProductsListViewController.view)
//    
//    addChild(menuProductsListViewController)
//    
//    setUpMenuControllerCLousers()
//    
//  }
//  
//  private func setUpMenuControllerCLousers() {
//    // Нажимаем кнопочку свернуть
//    menuProductsListViewController.didTapSwipeMenuBackButton = {[weak self] in
//      self?.toogleMenu()
//    }
//    
//    menuProductsListViewController.didAddProductInDinnerClouser = {[weak mainViewController = mainViewController] productsRealm in
//      mainViewController?.addProductInDinner(products: productsRealm)
//    }
//  }
//  
//  
//
//}


// MARK: Animated Menu

extension BaseContainerController {
  
  
  func toogleMenu() {
    
    switch currentState {
    case .closed:
      openMenu()
    case .open:
      closeMenu()
      
    }
  }
  
  
  // Pan Gesture Recogniser!
  
  @objc private func handleSwipeMenu(gesture: UIPanGestureRecognizer) {
    
    let translationY = -gesture.translation(in: view).y
    
    print(translationY)
    
    switch gesture.state {
      
    case .began:
      toogleMenu()
      animator.pauseAnimation()
      
    case .changed:
      
      let fraction = translationY / menuScreenHeight
      animator.fractionComplete = fraction
    case .ended:
      // Развернем анимацию если не преодолил барьер
      if translationY < 200 {
        animator.isReversed = !animator.isReversed
      }
      
      animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
      
    default: break
    }
    
  }
  
  
  
  func closeMenu() {
    
    
    animator.addAnimations {
      
      self.menuProductsListViewController.view.center.y -= self.menuScreenHeight + UIApplication.shared.statusBarFrame.height
      self.controller.view.frame.origin.y = 0
      
    }
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      switch position {
      case .end:
        
        self.mainViewController.removeGestureRecogniser() // Убрать гестер
        self.mainViewController.tableView.isScrollEnabled = true
        self.currentState = self.currentState.opposite
        
        self.view.endEditing(true)
      default: break
      }
      
    }
    animator.startAnimation()
  }
  
  
  func openMenu() {
    
    animator.addAnimations {
      // Опускаем VIew на половниу
      self.menuProductsListViewController.view.center.y += self.menuScreenHeight + UIApplication.shared.statusBarFrame.height
      
      
    }
    animator.addAnimations({
      self.controller.view.frame.origin.y = self.menuScreenHeight - Constants.Main.Cell.headerCellHeight - Constants.customNavBarHeight +  20
    }, delayFactor: 0.35)
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      self.mainViewController.tableView.isScrollEnabled = false
      self.mainViewController.setUppanGestureRecogniser()  // Повесим recogniser
      
      self.currentState = self.currentState.opposite
    }
    
    animator.startAnimation()
  }
}
