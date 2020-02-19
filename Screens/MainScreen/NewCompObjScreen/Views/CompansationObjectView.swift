//
//  CompansationObjectView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit




class CompansationObjectView: UIView {
  
  // MARK: Properties
  
  // NAv Bar
  let navBar = CompObjScreenNavBar(frame: CompObjScreenNavBar.sizeBar)
  
  // tableView
  let tableView = UITableView(frame: .zero, style: .plain)
  // Blur
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  // ChoosePlaceInjection Views
  let choosePlaceInjectionsView = ChoosePlaceInjectionView(frame: .init(x: 0, y: 0, width: 250, height: 350))

  
  // MARK: init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}


// MARK: Set Up Views

extension CompansationObjectView {
  
  private func setUpViews() {
    
    setUpNavBar()
    
    setUpTableView()
    
    setUpBlurView()
    setUpChoosePlaceInjectionsView()
  }
  
  private func setUpNavBar() {
    addSubview(navBar)
    navBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
  }
  
  private func setUpTableView() {
    addSubview(tableView)
    tableView.anchor(top: navBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 3, left: 0, bottom: 0, right: 0))
  }
  
  private func setUpBlurView() {
    addSubview(blurView)
    blurView.fillSuperview()
  }
  private func setUpChoosePlaceInjectionsView() {
    
    choosePlaceInjectionsView.center = self.center
    addSubview(choosePlaceInjectionsView)
//    choosePlaceInjectionsView.centerInSuperview()
    
  }
}
