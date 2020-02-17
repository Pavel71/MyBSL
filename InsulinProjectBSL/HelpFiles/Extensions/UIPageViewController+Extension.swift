//
//  UIPageViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 13.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit










extension UIPageViewController {

    func enableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }

    func disableSwipeGesture() {
      
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
  
  
   func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
           if let currentViewController = viewControllers?[0] {
               if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                   setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
               }
           }
       }
}
