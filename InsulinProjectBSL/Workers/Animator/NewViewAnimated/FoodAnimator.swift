//
//  FoodAnimator.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


import UIKit


class AddNewElementViewAnimated {
  
  static func showOrDismissToTheUpRightCornerNewView(
    newElementView: UIView,
    blurView: UIVisualEffectView,
    customNavBar: UIView,
    tabbarController: UITabBarController,
    isShow: Bool,
    completion: ((Bool) -> Void)? = nil) {

    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
      
      
      tabbarController.tabBar.alpha = isShow ? 0: 1
      
      blurView.alpha = isShow ? 1 : 0
      newElementView.alpha = isShow ? 1 : 0
      
      // Translation
      customNavBar.transform = isShow ? CGAffineTransform(translationX:0, y: -100) : .identity
      
      newElementView.transform = isShow ? .identity : Constants.Animate.transformUpRightCorner
      
    }, completion: completion)
    
  }
  
  
  static func showOrDismissToTheUpLeftCornerNewView(newElementView: UIView, blurView: UIVisualEffectView,customNavBar: UIView, tabbarController: UITabBarController, isShow: Bool) {
      

      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
    
        
        tabbarController.tabBar.alpha = isShow ? 0: 1
        
        blurView.alpha = isShow ? 1 : 0
        newElementView.alpha = isShow ? 1 : 0
        
        // Translation
        customNavBar.transform = isShow ? CGAffineTransform(translationX:0, y: -100) : .identity
        newElementView.transform = isShow ? .identity : Constants.Animate.transformUpLeftCorner
        
      }, completion: nil)
      
    }
  
  static func showOrDismissUnderBottomInCenterNewView(
    newElementView: UIView,
    blurView: UIVisualEffectView,
    customNavBar: UIView?,
    tabbarController: UITabBarController?, isShow: Bool) {
    

    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
  
      
      tabbarController?.tabBar.alpha = isShow ? 0: 1
      
      blurView.alpha = isShow ? 1 : 0
      newElementView.alpha = isShow ? 1 : 0
      
      // Translation
      customNavBar?.transform = isShow ? CGAffineTransform(translationX:0, y: -100) : .identity
      
      newElementView.transform = isShow ? .identity : Constants.Animate.transformUnderBottomInCenter
      
    }, completion: nil)
    
  }
  
  
  
}

