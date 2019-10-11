//
//  MenuDinnerView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MenuView: UIView {
  
  
  
  // MARK: Views
  
//  let swipeView = SwipeView()
  let tableView = UITableView(frame: .zero, style: .plain)
  
  let searchBar: UISearchBar = {
    let sB = UISearchBar()
    sB.searchBarStyle  = .minimal
    sB.placeholder = "Поиск..."
    sB.setPlaceholderTextColorTo(color: .white)
    sB.tintColor = .white
    
    sB.sizeToFit()
    sB.isTranslucent = false

    return sB
  }()
  
  var tableHeaderView: FoodTableViewHeader!
  
  // MARK: Properties
  
  
  
  
  init(segmentItems: [String]) {
    super.init(frame: .zero)
    
    backgroundColor = .darkGray
    
    tableHeaderView = FoodTableViewHeader(frame:FoodTableViewHeader.headerSize,setSegments: segmentItems)
    
    setUpSearchBar()
    setUpTableView()
//    setUpSwipeView()

  }
  
//  override func draw(_ rect: CGRect) {
//    super.draw(rect)
//
//
//    layer.borderColor = UIColor.black.cgColor
//    layer.borderWidth = 1
//  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: .init(width: 10, height: 10)).cgPath
    
    
    layer.mask = shapeLayer
  }
  
  
  private func setUpTableView() {
    
    
    tableView.backgroundColor = .clear
    
    addSubview(tableView)
    tableView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 3, left: 0, bottom: 0, right: 0))
    
    
    
    tableView.tableHeaderView = tableHeaderView
  }
  
  
//  private func setUpSwipeView() {
//    addSubview(swipeView)
//    swipeView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .zero,size: .init(width: 0, height: Constants.MenudDinner.swipeViewHeight))
//  }
  
  private func setUpSearchBar() {
    addSubview(searchBar)
    searchBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .zero,size: .init(width: 0, height: 60))
//    searchBar.delegate = self
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
}


