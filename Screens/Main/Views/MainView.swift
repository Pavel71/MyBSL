//
//  MainView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MainView: UIView {
  
  
  var customNavBar: MainCustomNavBar!
  var tableView = UITableView(frame: .zero, style: .plain)
  
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  
  let choosePlaceInjectionsView = ChoosePlaceInjectionView(frame: .init(x: 0, y: 0, width: 250, height: 350))
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    setUpMainCustomNavBar()
    setUpTableView()
    setUpBlurView()
    setUpChoosePlaceInjectionsView()
    
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: SetUp Some CustomView

extension MainView {
  
  // CustomNavBar
  private func setUpMainCustomNavBar() {
    customNavBar = MainCustomNavBar(frame: MainCustomNavBar.sizeBar)
    
    addSubview(customNavBar)
    customNavBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
  }
  
  private func setUpTableView() {
    
    let topPadding = Constants.TableView.tableViewTopPadding
    
    addSubview(tableView)
    tableView.anchor(top: customNavBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: topPadding, left: 0, bottom: 0, right: 0))
    
    
    
    tableView.tableHeaderView = UIView()
    tableView.tableFooterView = UIView()
    
  }
  
  private func setUpBlurView() {
    addSubview(blurView)
    blurView.fillSuperview()
  }
  private func setUpChoosePlaceInjectionsView() {
    
    choosePlaceInjectionsView.center = self.center
    addSubview(choosePlaceInjectionsView)
    
  }
  
}
