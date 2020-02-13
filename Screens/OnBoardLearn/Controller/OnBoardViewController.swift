//
//  OnBoardViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Нужно добавить pageController!


protocol PagesViewControllerable: UIViewController {
  
  var nextButtonIsValid: Bool {get set}
  var didIsNextButtonValid: ((Bool) -> Void)? {get set}
}




class OnBoardViewController: UIPageViewController {
  
  
  // По хорошему у этого контроллера должна быть своя модель через которую у нас работают другие модели
  var learnByCorrectionVM = LearnByCorrectionVM()
  var learnByFoodVM       = LearnByFoodVM()
  
fileprivate lazy var pages: [UIViewController] = {
    return [
      HelloVC(),
      LearnByCorrectionVC(
        didIsNextButtonValid: didIsNextButtonValid!,
        viewModel: learnByCorrectionVM),
      LearnByFoodVC(
        didIsNextButtonValid: didIsNextButtonValid!,
        viewModel: learnByFoodVM)
    ]
  }()
  
  
  var numberPage: Int = 0 {
    didSet {
      pageController.currentPage = numberPage
    }
  }
  
  
  
  
  var pageController       : UIPageControl!
  var nextButton           : UIBarButtonItem!
  
  
  var isNextButtonValid    : Bool = true {
    didSet{nextButton.isEnabled = isNextButtonValid}
  }
  var didIsNextButtonValid : ((Bool) -> Void)?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
   
    setValidateClouser()
    self.dataSource = self
    self.delegate   = self
    
    self.disableSwipeGesture()
    
    decoratePageControl()
    if let firstVC = pages.first
    {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    
    configureNavBar()
  }
  
  private func setValidateClouser() {
    // Поставил Clouser
       didIsNextButtonValid = {[weak self] isValid in
         self?.isNextButtonValid = isValid
       }
  }
  
  private func configureNavBar() {
    nextButton = UIBarButtonItem(title: "Дальше", style: .done, target: self, action: #selector(nextScreen))
    navigationItem.rightBarButtonItem = nextButton
    
  }
  
  @objc private func nextScreen() {
    
    
    if numberPage == pages.count - 1 {
      print("Конц онбордингу")
      
      // Теперь нам нужно пробежатся по всем моделькам и собрать с них данные ! Дальше нужно будет дисмиснуть экран и появится основной экарн!
      
    } else {
      numberPage += 1
      
      let vc = pages[numberPage] as! PagesViewControllerable
      nextButton.isEnabled = vc.nextButtonIsValid
      
      self.goToNextPage()
    }

    
  }
  
  
  fileprivate func decoratePageControl() {
    
//    pageController = UIPageControl.appearance(whenContainedInInstancesOf: [OnBoardViewController.self])
    pageController = UIPageControl(frame: .init(x: 0, y: 0, width: 150, height: 50))
    pageController.numberOfPages = pages.count
    pageController.currentPage   = numberPage
    pageController.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    pageController.pageIndicatorTintColor        = .gray
    
    self.view.addSubview(pageController)
    pageController.centerInSuperview()
    
    // Когда я его разверну на новом window тогда и настрою отрисовку!
    
//    let tabbarHeight = self.tabBarController?.tabBar.frame.height
//
//    pageController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarHeight!).isActive = true
    
    
    }
  
  
}



// MARK: PageViewControoler DataSource

extension OnBoardViewController: UIPageViewControllerDataSource {
  

  
  
   func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         
    guard let viewControllerIndex = pages.firstIndex(of: viewController ) else { return nil }
         
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
