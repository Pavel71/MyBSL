//
//  AppState.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



// Класс который отвечает за отображение OnBoarding - Когда эта задача будет выполнена мы просто сними Onboarding с UIWindow и все!

final class AppState {
  
  
  static var shared = AppState()
  
  var mainWindow          : UIWindow?
  var onBoardingWindow    : UIWindow?
  var loginRegisterWindow : UIWindow?
  
  private init () {}
  
  // Может быть когда мы фигачим переход на MainWIndow и создавать наш TabBar Controller инчае какаято жопа получается! Сто 500 запростов происходит! Бесит!
  
  
  
  func toogleMinorWindow(minorWindow: UIWindow?) {
    
    if let window2 = minorWindow {

          if window2.isKeyWindow {


            UIView.animate(withDuration: 1.0, animations: {
              window2.alpha = 0
              self.mainWindow?.makeKeyAndVisible()

            }) { (_) in
              window2.isHidden = true
            }

            } else {
            
            UIView.animate(withDuration: 1.0, animations: {
              
              window2.alpha = 1
              window2.makeKeyAndVisible()
              window2.isHidden = false

            })

            }

    }
  }
  
  func setMainTabBarController() {
    mainWindow?.rootViewController = BaseTabBarController()
  }
  func removeMainWindowController() {
    
    UIView.transition(with: (mainWindow?.rootViewController?.view)!, duration: 0.3, options: .curveEaseOut, animations: {
      let dummyVC = UIViewController()
      dummyVC.view.backgroundColor = .white
      self.mainWindow?.rootViewController = dummyVC
    }, completion: nil)
    
  }
  

  
}

// MARK: Push Main Screen Methods

extension AppState {
  
  func pushUpdateMainScreenViewControllerMethod() {
    
    guard
      let mainScreenController = getMainScreenController()
      else {return}
    mainScreenController.activateApplication()
  }
  

  
  
  
  private func getMainScreenController() -> MainScreenViewController? {
    guard
    let tabBarController = self.mainWindow?.rootViewController as? BaseTabBarController
      else {return nil}
    
    let mainScreenController: MainScreenViewController = tabBarController.viewControllers?.filter{$0.children[0] is MainScreenViewController}[0].children[0] as! MainScreenViewController
    
    return mainScreenController
  }
}




