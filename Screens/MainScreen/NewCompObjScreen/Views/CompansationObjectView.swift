//
//  CompansationObjectView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit




class CompansationObjectView: UIView {
  
  // NAv Bar
  let navBar = CompObjScreenNavBar(frame: CompObjScreenNavBar.sizeBar)
  
  // tableView
  let tableView = UITableView(frame: .zero, style: .plain)
  //RobotView - Может он просто не нужен! ЧТобы когда я нажимаю сохранить мы сразу возвращалиьс к главному экрану! А не ждали когда закончится анимация робота!
  
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
    
    addSubview(navBar)
    navBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    
    addSubview(tableView)
    tableView.anchor(top: navBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 3, left: 0, bottom: 0, right: 0))
    
//    let stackView = UIStackView(arrangedSubviews: [
//          navBar,
//          UIView()
//    ])
//    stackView.axis    = .vertical
//    stackView.spacing = 5
//    stackView.distribution = .fill
//    
//    addSubview(stackView)
//    stackView.fillSuperview()
    
  }
}
