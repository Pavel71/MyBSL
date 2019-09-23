//
//  MealView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 29/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealView: UIView {
  
  // Итак будет Nav Bar для начала и TableView
  let customNavBar = CustomNavBar(frame: CustomNavBar.sizeBar,withBackButton: true)
//  var newMealView: BlurBackgroundWrapperView!
  let tableView = UITableView(frame: .zero, style: .plain)
  
  let newMealView = NewMealView(frame: NewMealView.size)
  let pickerView = UIPickerView()
  
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    
    setUpCustomNavBar()
    setUpTableView()
    setUpBlurView()
    setUpNewMealView()
    setUpPickerView()
  }
  
  private func setUpCustomNavBar() {

    addSubview(customNavBar)
    customNavBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    
  }
  
  private func setUpTableView() {
    addSubview(tableView)
    tableView.anchor(top: customNavBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: Constants.tableViewTopPadding, left: 0, bottom: 0, right: 0))
    
  }
  
 
  private func setUpBlurView() {
    addSubview(blurView)
    blurView.fillSuperview()
    
    blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapBlurView)))
  }
  
  var didTapBlurViewClouser: EmptyClouser?
  @objc private func handleTapBlurView() {
    didTapBlurViewClouser!()
  }

  private func setUpNewMealView() {
    
    addSubview(newMealView)
    newMealView.centerInSuperview(size: .init(width: newMealView.frame.width, height: newMealView.frame.height))
    
    // Убираем вправый угол!
    newMealView.hideViewOnTheRightCorner()
    
  }
  
  private func setUpPickerView() {
    
    addSubview(pickerView)
    pickerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .zero,size: .init(width: 0, height: 140))
    pickerView.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
