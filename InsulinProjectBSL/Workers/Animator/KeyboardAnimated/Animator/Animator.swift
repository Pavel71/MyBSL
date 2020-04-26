//
//  Animator.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class Animator {
  
  
  static func springTranslated(view: UIView, duration: TimeInterval = 0.75, cgaTransform: CGAffineTransform, complition: ((Bool) -> Void)? = nil) {
    
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      
      view.transform = cgaTransform
    }, completion: complition)
    
  }
  
  static func springAlpha(view: UIView, alphaBefore: CGFloat, alphaAfter: CGFloat,duration: TimeInterval = 0.5 , delay:TimeInterval = 0, spring: CGFloat = 1, velocity: CGFloat = 1,options: UIView.AnimationOptions = .curveEaseOut ,complition: ((Bool) -> Void)? = nil) {
    

    view.alpha = alphaBefore
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: spring, initialSpringVelocity: velocity, options: options, animations: {
      view.alpha = alphaAfter
    }, completion: complition)
    
   
  }
  
  
}
