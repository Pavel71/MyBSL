//
//  CustomAddNewElement.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 10/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit




protocol NewElelmentView: UIView {
  
  var blurView: UIVisualEffectView {get}
  var addNewElementView: CustomAddNewView {get}
  //  func setDefaultView()
}

class BlurBackgroundWrapperView: UIView, NewElelmentView {
  
  var addNewElementView: CustomAddNewView
  
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  
  
  
  init(frame: CGRect,addNewElelmentView: CustomAddNewView) {
    self.addNewElementView = addNewElelmentView
    super.init(frame: frame)
    
    setUpBlurEffect()
    setUpAddnewElementView()
  }
  

  
  // Blur View
  private func setUpBlurEffect() {

    addSubview(blurView)
    blurView.fillSuperview()
    
    blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelTapBlurView)))
  }
  
  // AddNewElelemtnView
  
  private func setUpAddnewElementView() {
    
    addSubview(addNewElementView)
    addNewElementView.centerInSuperview(size: .init(width: addNewElementView.frame.width, height: addNewElementView.frame.height))
    
//    addNewElementView.hideViewOnTheRightCorner()
  }
  
  var didTapOnBlurClouser: EmptyClouser?
  @objc private func handelTapBlurView() {
    print("Tap blurView")

    didTapOnBlurClouser!()
  }
 
 
  
//  MARK: HIDE Some View
  
  func hideViewOnTheRightCorner() {
    
//    guard  let view = self.superview else {return}
    
    self.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: -UIScreen.main.bounds.height).concatenating(CGAffineTransform(scaleX: 0.2, y: 0.2))

    
    self.alpha = 0
  }
  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
