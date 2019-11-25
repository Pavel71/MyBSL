//
//  StatsMiddleCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MiddleCell: UITableViewCell {
  
  static let cellId = "MiddleCell"
  
  let collectionViewController = MealCollectionVC()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .yellow
    
    addSubview(collectionViewController.view)
    collectionViewController.view.fillSuperview()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
