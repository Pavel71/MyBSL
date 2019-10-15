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
  
  var tableView: UITableView! {get set}
  var menuState: State {get set}
  
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer! {get set}
  func setUppanGestureRecogniser()
  func removeGestureRecogniser()
  
}

class ShowMenuAnimator {
  
  
  var mainController: ShowMenuAnimatable
  var menuController: UIViewController

  
  var mainDistanceTranslate: CGFloat!
  var menuDistanceTranslate: CGFloat!
  
  init(mainController:ShowMenuAnimatable,menuController:UIViewController) {
    self.mainController = mainController
    self.menuController = menuController
    
    menuDistanceTranslate = Constants.screenHeight / 2 + UIApplication.shared.statusBarFrame.height
  }
  
  deinit {
    print("Deinit show Menu ANimator")
  }
  

  private  lazy var animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
  }()
  
  private  var currentState: State = .closed
  
  
  // Установим расстояние для изменениея положения главного экрана
  
  func setMainDistanceValue(distance:CGFloat) {
    mainDistanceTranslate = distance
  }
  
}


// MARK: Animated Menu

extension ShowMenuAnimator {
  
  
  func toogleMenu() {
    
    switch currentState {
    case .closed:
      openMenu()
    case .open:
      closeMenu()
      
    }
  }
  
  
  // Pan Gesture Recogniser!
  
  func handleSwipeMenu(gesture: UIPanGestureRecognizer,containerView: UIView) {
    
    let translationY = -gesture.translation(in: containerView).y
    
    switch gesture.state {
      
    case .began:
      toogleMenu()
      animator.pauseAnimation()
      
    case .changed:
      
      let fraction = translationY / menuDistanceTranslate
      animator.fractionComplete = fraction
    case .ended:
      // Развернем анимацию если не преодолил барьер
      if translationY < Constants.screenHeight / 4 {
        animator.isReversed = !animator.isReversed
      }
      
      animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
      
    default: break
    }
    
  }
  
  
  
  func closeMenu() {
    
    
    animator.addAnimations {
      
      self.menuController.view.center.y -= self.menuDistanceTranslate
      self.mainController.view.frame.origin.y = 0
      
    }
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      switch position {
      case .end:

        self.menuController.view.endEditing(true)
        self.mainController.removeGestureRecogniser() // Убрать гестер
        self.mainController.tableView.isScrollEnabled = true
        self.mainController.tableView.allowsSelection = true
        
        self.currentState = self.currentState.opposite
        self.mainController.menuState = self.currentState
        
      default: break
      }
      
    }
    animator.startAnimation()
  }
  
  
  func openMenu() {
    
    animator.addAnimations {
      // Опускаем VIew на половниу
      self.menuController.view.center.y += self.menuDistanceTranslate
      
      
    }
    
    animator.addAnimations({
      
      self.mainController.view.frame.origin.y = self.mainDistanceTranslate
      self.mainController.view.endEditing(true)
      
    }, delayFactor: 0.35)
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      

      self.mainController.tableView.isScrollEnabled = false
      self.mainController.tableView.allowsSelection = false
      self.mainController.setUppanGestureRecogniser()  // Повесим recogniser
      
      
      self.currentState = self.currentState.opposite
      self.mainController.menuState = self.currentState
//      self.currentState = self.currentState.opposite
    }
    
    animator.startAnimation()
  }
}
