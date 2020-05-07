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
  
  

  
}




