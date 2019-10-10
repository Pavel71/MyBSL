//
//  ContainerViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 11/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

//enum State {
//  case closed
//  case open
//
//  var opposite: State {
//    switch self {
//    case .open: return .closed
//    case .closed: return .open
//    }
//  }
//}

class ContainerViewController: UIViewController {
  
  var controller: UIViewController!
  
  var mealViewController: MealViewController
  var menuProductsListViewController: MenuProductsListViewController!
  
  
  private lazy var animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
  }()
  
  let menuScreenWidth = MenuProductsListViewController.screenWidth
  
  private var currentState: State = .closed
  
  init(mealController: MealViewController) {
    self.mealViewController = mealController
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    print("Deinit Container Controller")
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureMealViewController()
  }
  
  func configureMealViewController() {
    // при нажатие на кнопку добавить просить добавить product controller
//    mealViewController.didShowMenuProductsListViewControllerClouser = {[weak self] in  self?.configureProductListViewController() }
    
    controller = mealViewController
    
    view.addSubview(controller.view)
    addChild(controller)
    
  }
  
  var passProductID: ((String) -> Void)?
  
  func configureProductListViewController() {
    
    if menuProductsListViewController == nil {
      menuProductsListViewController = MenuProductsListViewController()
      view.insertSubview(menuProductsListViewController.view, at: 0)
      addChild(menuProductsListViewController)
    }
    
    
    switch currentState {
      
      case .open:
        // Анимация
        closeMenu()
      
      case .closed:
        
       prepareMenuViewController()
        // Анимация
        openMenu()

    }


  }
  
  private func prepareMenuViewController() {
    
    menuProductsListViewController.setDefaultChooseProduct()
    
    menuProductsListViewController.didAddProductInMealClouser = {[weak mealViewController = mealViewController] productId in
      mealViewController?.addProductInMeal(productId: productId)
    }
    
  }
  

  
  
  // Set Up Gesture Recogniser
  
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
  
  private func setUppanGestureRecogniser() {
    slideMenuPanGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeMenu))
    mealViewController.view.addGestureRecognizer(slideMenuPanGestureRecogniser)
  }
  private func removeGestureRecogniser() {
    mealViewController.view.removeGestureRecognizer(slideMenuPanGestureRecogniser)
  }

  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

  
}





// MARK: Animated Show Menu View COntroller

extension ContainerViewController {
  
  
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
    
    let translationX = -gesture.translation(in: view).x
  
    switch gesture.state {
      
      case .began:
            toogleMenu()
            animator.pauseAnimation()
      case .changed:

        let translationX = -gesture.translation(in: view).x  // смещаем влевол
        let fraction = translationX / menuScreenWidth
        animator.fractionComplete = fraction
        
//        if animator.isReversed { fraction *= -1 }
      
      case .ended:
        // Развернем анимацию если не преодолил барьер
        if translationX < 50 {
         animator.isReversed = !animator.isReversed
        }
        
        animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
      
    default: break
    }
    
  }
  
  // Такие анимациилучше писать раскрыто пусть буде т больше кода зато читаеме
  
  func closeMenu() {
    
    animator.addAnimations {
      self.controller.view.frame.origin.x = 0
    }
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      // История анимации заканчивается здесь! Все изменения после того когда анимация додйет до финиша в этом блоке!
      switch position {
      case .end:
        self.removeGestureRecogniser() // Убрать гестер
        self.mealViewController.tableView.isUserInteractionEnabled = true
        self.mealViewController.mealView.customNavBar.searchBar.isUserInteractionEnabled = true
        
        self.currentState = self.currentState.opposite
        self.mealViewController.menuState = self.currentState
        self.view.endEditing(true)
      default: break
      }
      
    }
    animator.startAnimation()
  }
  
  
  func openMenu() {
    
    animator.addAnimations {
      self.controller.view.frame.origin.x = self.menuScreenWidth
    }
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      self.setUppanGestureRecogniser()  // Повесим recogniser
      self.mealViewController.tableView.isUserInteractionEnabled = false // Отключаем основную табле вью Чтобы не нажимались ячейки тд
      self.mealViewController.mealView.customNavBar.searchBar.isUserInteractionEnabled = false
      
      self.currentState = self.currentState.opposite
      self.mealViewController.menuState = self.currentState
    }
    
    animator.startAnimation()
  }
}



