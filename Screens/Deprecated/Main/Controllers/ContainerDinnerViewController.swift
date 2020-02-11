//
//  ContainerDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 29/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ContainerDinnerViewController: UIViewController {
  
  var controller: UIViewController!
  
  var mainViewController: MainViewController
  var menuProductsListViewController: MainMenuViewController!
  
  
  private lazy var animator: UIViewPropertyAnimator = {
    return UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
  }()
  
  // Тут нужно подумать на сколько должна эта шторка выезжать!
  let menuScreenHeight: CGFloat = UIScreen.main.bounds.height / 2
  
  private var currentState: State = .closed
  
  init(mainController: MainViewController) {
    self.mainViewController = mainController
    super.init(nibName: nil, bundle: nil)
  }
  
  
  deinit {
    print("Deinit Container Controller")
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureMainViewController()
    setUpMenuControllerView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("View Will Appear Container")
    // Убераем контроллер за границу
    
    
  }
  

  
  

  
//  private func prepareMenuViewController() {
//
//    menuProductsListViewController.setDefaultChooseProduct()
//
//    menuProductsListViewController.didAddProductInMealClouser = {[weak mealViewController = mealViewController] productId in
//      mealViewController?.addProductInMeal(productId: productId)
//    }
//
//  }
  
  
  
  
  // Set Up Gesture Recogniser
  
//  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
//
//  private func setUppanGestureRecogniser() {
//    slideMenuPanGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeMenu))
//    mainViewController.view.addGestureRecognizer(slideMenuPanGestureRecogniser)
//  }
//
//  private func removeGestureRecogniser() {
//    mainViewController.view.removeGestureRecognizer(slideMenuPanGestureRecogniser)
//  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
}

// MARK: SetUP Views

extension ContainerDinnerViewController {
  
  private func configureMainViewController() {

    controller = mainViewController
    
    view.addSubview(controller.view)
    addChild(controller)
    
    setMenuControllerClousers()
    
    
  }
  
  private func setMenuControllerClousers() {
    // Нажимаем кнопочку добавить продукт
//    mainViewController.didShowMenuProductsListViewControllerClouser = {[weak self] in  self?.toogleMenu() }
//    mainViewController.didPanGestureValueChange = {[weak self] gesture in
//      self?.handleSwipeMenu(gesture: gesture)
//    }
  

  }
  
  private func setUpMenuControllerView() {

    menuProductsListViewController = MainMenuViewController()
    
    menuProductsListViewController.view.center.y -= UIScreen.main.bounds.height
    view.addSubview(menuProductsListViewController.view)
    
    addChild(menuProductsListViewController)
    
    setUpMenuControllerCLousers()
    
  }
  
  private func setUpMenuControllerCLousers() {
    // Нажимаем кнопочку свернуть
    menuProductsListViewController.didTapSwipeMenuBackButton = {[weak self] in
      self?.toogleMenu()
    }
    
    menuProductsListViewController.didAddProductClouser = {[weak mainViewController = mainViewController] productsRealm in
      mainViewController?.addProducts(products: productsRealm)
    }
  }
  
}

// MARK: Some Methods Clousers

extension ContainerDinnerViewController {
  
  

}




// MARK: Animated Show Menu View COntroller

extension ContainerDinnerViewController {


  func toogleMenu() {

    switch currentState {
    case .closed:
      openMenu()
    case .open:
      closeMenu()

    }
  }


  // Pan Gesture Recogniser!

  @objc private func handleSwipeMenu(gesture: UIPanGestureRecognizer) {

    let translationY = -gesture.translation(in: view).y
    
    print(translationY)

    switch gesture.state {

    case .began:
      toogleMenu()
      animator.pauseAnimation()
      
    case .changed:

      let fraction = translationY / menuScreenHeight
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
      
      self.menuProductsListViewController.view.center.y -= self.menuScreenHeight + UIApplication.shared.statusBarFrame.height + Constants.Main.DinnerCollectionView.shugarViewInCellHeight + Constants.Main.DinnerCollectionView.topMarginBetweenView * 2
      self.controller.view.frame.origin.y = 0
      
    }

    // Это кгода Continue Animation
    animator.addCompletion { position in

      switch position {
      case .end:
        
        self.mainViewController.removeGestureRecogniser() // Убрать гестер
        self.mainViewController.tableView.isScrollEnabled = true
        self.currentState = self.currentState.opposite

        self.view.endEditing(true)
      default: break
      }

    }
    animator.startAnimation()
  }


  func openMenu() {
    
    // Нужно решить проблему с правельным рассчетом дистанции!

    animator.addAnimations {
      // Опускаем VIew на половниу
      self.menuProductsListViewController.view.center.y += self.menuScreenHeight + UIApplication.shared.statusBarFrame.height + Constants.Main.DinnerCollectionView.shugarViewInCellHeight + Constants.Main.DinnerCollectionView.topMarginBetweenView * 2
      
      
    }
    animator.addAnimations({
      self.controller.view.frame.origin.y = self.menuScreenHeight - Constants.Main.Cell.headerCellHeight - Constants.customNavBarHeight +  20
    }, delayFactor: 0.35)

    // Это кгода Continue Animation
    animator.addCompletion { position in
      
      self.mainViewController.tableView.isScrollEnabled = false
      self.mainViewController.setUppanGestureRecogniser()  // Повесим recogniser

      self.currentState = self.currentState.opposite
    }

    animator.startAnimation()
  }
}
