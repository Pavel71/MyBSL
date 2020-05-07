//
//  OnBoardViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import JGProgressHUD


// Нужно добавить pageController!


protocol PagesViewControllerable: UIViewController {
  
  var nextButtonIsValid: Bool {get set}
  var didIsNextButtonValid: ((Bool) -> Void)? {get set}
}




class OnBoardViewController: UIPageViewController {
  
  
  var savingHUD: JGProgressHUD = {
     let hud = JGProgressHUD(style: .dark)
     hud.textLabel.text = "Сохраняю данные"
     return hud
   }()
  
  
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
  
  
  
  
  var pageController : UIPageControl!
  var nextButton     : UIBarButtonItem!
  
  var buttonsTappedCount: Int = 0
  
  
  
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
    self.removeGestureRecognizers()
    

    
    
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
  
  // MARK: Save Button
  
  @objc private func nextScreen() {
    
    buttonsTappedCount += 1
    
    
    
    if numberPage == pages.count - 1 {
      
      
      // Теперь нам нужно пробежатся по всем моделькам и собрать с них данные ! Дальше нужно будет дисмиснуть экран и появится основной экарн!
      onBoardVM.learnML()
      
      // Здесь нужно запустить процесс сохранения данных юзера в FireBase
      
      
      savingHUD.show(in: pages.last!.view)
      
      let locator = ServiceLocator.shared
      
      let addService:AddService! = locator.getService()
      let userDefaultsWorker: UserDefaultsWorker! = locator.getService()
      
      let userDefDataDict = userDefaultsWorker.getAllDataFromUserDefaults()
      
      addService.addUserDefaultsDataToFirebase(
      userDefaltsData: userDefDataDict) { (result) in
        
        switch result {
        case .failure(let error):
          
          self.showErrorMessage(text: error.localizedDescription)
          
        case .success(_):
          self.savingHUD.dismiss()
          // СОхранение данных прошло успешно
          
          let appStateService: AppState = AppState.shared
          appStateService.toogleMinorWindow(minorWindow: appStateService.onBoardingWindow)
        }
        
        
      }
      
      
      
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
    decoratePageControl()
  }
  

  
  fileprivate func decoratePageControl() {
    
    pageController = UIPageControl(frame: .init(x: 0, y: 0, width: 150, height: 50))
    pageController.numberOfPages = pages.count
    pageController.currentPage   = numberPage
    pageController.currentPageIndicatorTintColor = .white
    pageController.pageIndicatorTintColor = .gray

    
    self.view.addSubview(pageController)
    pageController.centerXInSuperview()
    pageController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    

    
  }
}



// MARK: PageViewControoler DataSource

extension OnBoardViewController: UIPageViewControllerDataSource {
  
  
  
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

//    guard let viewControllerIndex = pages.firstIndex(of: viewController ) else { return nil }
//
//    let previousIndex = viewControllerIndex - 1
//
//    guard previousIndex >= 0          else { return nil }
//
//    //         guard pages.count > previousIndex else { return nil        }
//
//    return pages[previousIndex]
    
    return nil
    
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
  {
    guard buttonsTappedCount > 0 else {return nil}
    buttonsTappedCount = 0
    
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
