//
//  ContainerDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 29/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ContainerDinnerViewController: UIViewController {
  
  var controller: UIViewController!
  
  var mainViewController: MainViewController
  var menuProductsListViewController: MenuDinnerViewController!
  
  
  private lazy var animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
  }()
  
  // Тут нужно подумать на сколько должна эта шторка выезжать!
  let menuScreenHeight:CGFloat = 300
  
  private var currentState: State = .closed
  
  init(mainController: MainViewController) {
    self.mainViewController = mainController
    super.init(nibName: nil, bundle: nil)
  }
  
  
  deinit {
    print("Deinit Container Controller")
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureMainViewController()
  }
  
  func configureMainViewController() {
 
    
    mainViewController.didShowMenuProductsListViewControllerClouser = {[weak self] in  self?.configureProductListViewController() }
    
    controller = mainViewController
    
    view.addSubview(controller.view)
    addChild(controller)
    
  }
  
  
  func configureProductListViewController() {
    
    if menuProductsListViewController == nil {
      
      menuProductsListViewController = MenuDinnerViewController()
      view.insertSubview(menuProductsListViewController.view, at: 0)
      addChild(menuProductsListViewController)
    }
    
    
    switch currentState {
      
    case .open:
      print("Open")
      // Анимация
      closeMenu()
      
    case .closed:
      print("Closed")
//      prepareMenuViewController()
      // Анимация
      openMenu()
      
    }
    
    
  }
  
//  private func prepareMenuViewController() {
//
//    menuProductsListViewController.setDefaultChooseProduct()
//
//    menuProductsListViewController.didAddProductInMealClouser = {[weak mealViewController = mealViewController] productId in
//      mealViewController?.addProductInMeal(productId: productId)
//    }
//
//  }
  
  
  
  
  // Set Up Gesture Recogniser
  
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
  
//  private func setUppanGestureRecogniser() {
//    slideMenuPanGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeMenu))
//    mealViewController.view.addGestureRecognizer(slideMenuPanGestureRecogniser)
//  }
//  private func removeGestureRecogniser() {
//    mealViewController.view.removeGestureRecognizer(slideMenuPanGestureRecogniser)
//  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
}


// MARK: Animated Show Menu View COntroller

extension ContainerDinnerViewController {


  func toogleMenu() {

    switch currentState {
    case .closed:
      openMenu()
    case .open:
      closeMenu()

    }
  }


  // Pan Gesture Recogniser!

//  @objc private func handleSwipeMenu(gesture: UIPanGestureRecognizer) {
//
//    let translationX = -gesture.translation(in: view).x
//
//    switch gesture.state {
//
//    case .began:
//      toogleMenu()
//      animator.pauseAnimation()
//    case .changed:
//
//      let translationX = -gesture.translation(in: view).x  // смещаем влевол
//      let fraction = translationX / menuScreenWidth
//      animator.fractionComplete = fraction
//
//      //        if animator.isReversed { fraction *= -1 }
//
//    case .ended:
//      // Развернем анимацию если не преодолил барьер
//      if translationX < 50 {
//        animator.isReversed = !animator.isReversed
//      }
//
//      animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//
//    default: break
//    }
//
//  }

  // Такие анимациилучше писать раскрыто пусть буде т больше кода зато читаеме

  func closeMenu() {

    animator.addAnimations {
      self.controller.view.frame.origin.y = 0
    }

    // Это кгода Continue Animation
    animator.addCompletion { position in
      // История анимации заканчивается здесь! Все изменения после того когда анимация додйет до финиша в этом блоке!
      switch position {
      case .end:
        
        // Этот блок исполнится когда анимация закончится
        
//        self.removeGestureRecogniser() // Убрать гестер
//        self.mealViewController.tableView.isUserInteractionEnabled = true
//        self.mealViewController.mealView.customNavBar.searchBar.isUserInteractionEnabled = true
//
        self.currentState = self.currentState.opposite
//        self.mealViewController.menuState = self.currentState
        self.view.endEditing(true)
      default: break
      }

    }
    animator.startAnimation()
  }


  func openMenu() {

    animator.addAnimations {
      self.controller.view.frame.origin.y = self.menuScreenHeight
    }

    // Это кгода Continue Animation
    animator.addCompletion { position in
//      self.setUppanGestureRecogniser()  // Повесим recogniser
//      self.mealViewController.tableView.isUserInteractionEnabled = false // Отключаем основную табле вью Чтобы не нажимались ячейки тд
//      self.mealViewController.mealView.customNavBar.searchBar.isUserInteractionEnabled = false

      self.currentState = self.currentState.opposite
//      self.mealViewController.menuState = self.currentState
    }

    animator.startAnimation()
  }
}
