//
//  SlideMenuAnimated.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 19/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class SlideMenuAnimated {
  
  
  static let animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
  }()
  
  static func closeMenu(view: UIView) {
    
    animator.addAnimations {
      view.frame.origin.x = 0
    }
    
    // Это кгода Continue Animation
    animator.addCompletion { position in
   
    }
    animator.startAnimation()
  }
  
//  static func closeMenu(gesture: UIPanGestureRecognizer, view: UIView) {
//
//
//    switch gesture.state {
//
//      case .began:
//        print("Начало")
//        animator.pauseAnimation()
//      case .changed:
//        print("изменяется")
//        let translationX = -gesture.translation(in: view).x
//        animator.fractionComplete = translationX
//
//      case .ended:
//        print("Конец")
//        animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//      default: break
//    }
//  }
  
}
