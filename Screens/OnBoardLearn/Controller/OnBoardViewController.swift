//
//  OnBoardViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Нужно добавить pageController!


class OnBoardViewController: UIPageViewController {
  
  
fileprivate lazy var pages: [UIViewController] = {
    return [
      HelloVC(),
      LearnByCorrectionVC(),
      LearnByFoodVC()
    ]
  }()
  
  

  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.dataSource = self
    self.delegate   = self
    
    
    decoratePageControl()
    if let firstVC = pages.first
    {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
  }
  
  
  fileprivate func decoratePageControl() {
    let pc = UIPageControl.appearance(whenContainedInInstancesOf: [OnBoardViewController.self])
    pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    pc.pageIndicatorTintColor = .gray
    }
  
  
}

extension OnBoardViewController: UIPageViewControllerDataSource {
  

  
  
   func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         
    guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
         
         let previousIndex = viewControllerIndex - 1
         
         guard previousIndex >= 0          else { return nil }
         
//         guard pages.count > previousIndex else { return nil        }
         
         return pages[previousIndex]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
     {
      guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
         
         let nextIndex = viewControllerIndex + 1
         
         guard nextIndex < pages.count else { return nil }
         
//         guard pages.count > nextIndex else { return nil         }
         
         return pages[nextIndex]
     }
  
  
}

extension OnBoardViewController: UIPageViewControllerDelegate {
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int{
    return pages.count
  }

  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int{
  return 0
  }
  
}
