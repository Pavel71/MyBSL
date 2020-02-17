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
  
  
  var onBoardVM = OnBoardVM()
  
  fileprivate lazy var pages: [UIViewController] = {
    return [
      HelloVC(),
      LearnByCorrectionVC(
        didIsNextButtonValid: didIsNextButtonValid!,
        viewModel: onBoardVM.learnByCorrectionVM),
      LearnByFoodVC(
        didIsNextButtonValid: didIsNextButtonValid!,
        viewModel: onBoardVM.learnByFoodVM)
    ]
  }()
  
  
  var numberPage: Int = 0 {
    didSet {
      pageController.currentPage = numberPage
    }
  }
  
  
  
  
  var pageController       : UIPageControl!
  var nextButton     : UIBarButtonItem!
  
//  var nextButton : UIButton = {
//    let b = UIButton(type: .system)
//    b.setTitle("Дальше", for: .normal)
//    b.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
//    return b
//  }()
  
  
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
    setUpViews()
    
    
    
    
    if let firstVC = pages.first
    {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
    navigationController?.navigationItem.title = "Обучение"
    self.title = "Обучение"

  }
  
  @objc private func nextScreen() {
    
    
    if numberPage == pages.count - 1 {
      
      
      // Теперь нам нужно пробежатся по всем моделькам и собрать с них данные ! Дальше нужно будет дисмиснуть экран и появится основной экарн!
      onBoardVM.learnML()
      
      let appStateService: AppState = AppState.shared
      appStateService.toogleChartWindow()
      
      
    } else {
      numberPage += 1
      
      let vc = pages[numberPage] as! PagesViewControllerable
      nextButton.isEnabled = vc.nextButtonIsValid
      
      self.goToNextPage()
    }
    
    
  }
  
  

  
  
}

// MARK: SetUPViews

extension OnBoardViewController {
  
  func setUpViews() {
    view.backgroundColor = .white
//    configureNextButton()
    decoratePageControl()
  }
  

  
  fileprivate func decoratePageControl() {
    
    pageController = UIPageControl(frame: .init(x: 0, y: 0, width: 150, height: 50))
    pageController.numberOfPages = pages.count
    pageController.currentPage   = numberPage
    pageController.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    pageController.pageIndicatorTintColor        = .gray
    
    self.view.addSubview(pageController)
    pageController.centerXInSuperview()
    pageController.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true

    
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
