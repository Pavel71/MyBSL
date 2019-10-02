//
//  ChoosePlaceInjectionsViewAnimated.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ChoosePlaceInjectionsAnimated {
  
  
  
  static func showView(blurView: UIView, choosePlaceInjectionView: UIView, isShow: Bool) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
      blurView.alpha = isShow ? 1 : 0
      choosePlaceInjectionView.alpha = isShow ? 1 : 0
    }, completion: nil)
  }
}
