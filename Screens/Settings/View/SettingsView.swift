//
//  SettingsView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



final class SettingsView: UIView {
  
  
  let customNavBar = SettingCustomNavBar(frame: SettingCustomNavBar.sizeBar)
  
  let tableView    = UITableView(frame: .zero, style: .grouped)
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    
    setUpViews()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}


// MARK: Set up Views
extension SettingsView {
  
  func setUpViews() {
    
    let contentView = UIView()
    contentView.backgroundColor = .yellow
    
    let stackView = UIStackView(arrangedSubviews:[
    
      customNavBar,
      tableView
    ])
    
    stackView.axis         = .vertical
    stackView.spacing      = 5
    stackView.distribution = .fill
    
    addSubview(stackView)
    stackView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor)
    
  }
  
}
