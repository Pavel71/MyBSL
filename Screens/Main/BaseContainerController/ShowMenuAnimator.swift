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

class ShowMenuAnimator {
  
  var mainController: ShowMenuAnimatable
  var mainDistanceTranslate: CGFloat
  
  var menuController: UIViewController
  var menuDistanceTranslate: CGFloat
  
  init(mainController:ShowMenuAnimatable,menuController:ShowMenuAnimatable,menuDistanceTranslate:CGFloat,mainDistanceTranslate: CGFloat ) {
    self.mainController = mainController
    self.menuController = menuController
    self.menuDistanceTranslate = menuDistanceTranslate
    self.mainDistanceTranslate = mainDistanceTranslate
  }
  
  // Тут нужно подумать на сколько должна эта шторка выезжать!
  let menuScreenHeight: CGFloat = UIScreen.main.bounds.height / 2
  
  private  lazy var animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
  }()
  
  private  var currentState: State = .closed
  
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
    
    print(translationY)
    
    switch gesture.state {
      
    case .began:
      toogleMenu()
      animator.pauseAnimation()
      
    case .changed:
      
      let fraction = translationY / menuDistanceTranslate
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
      
      self.menuController.view.center.y -= self.menuDistanceTranslate
      self.mainController.view.frame.origin.y = 0
      
    }
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      switch position {
      case .end:
        
        self.mainController.removeGestureRecogniser() // Убрать гестер
        self.mainController.tableView.isScrollEnabled = true
        self.currentState = self.currentState.opposite
        
//        containerView.endEditing(true)
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
    }, delayFactor: 0.35)
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      self.mainController.tableView.isScrollEnabled = false
      self.mainController.setUppanGestureRecogniser()  // Повесим recogniser
      
      self.currentState = self.currentState.opposite
    }
    
    animator.startAnimation()
  }
}
