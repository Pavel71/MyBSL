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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    setUpMainCustomNavBar()
    setUpTableView()
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
  
}
