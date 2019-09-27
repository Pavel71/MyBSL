//
//  MainTableViewMiddleCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainTableViewMiddleCellable {
  
  var dinnerCollectionViewData: [DinnerViewModel] {get}
}


class MainTableViewMiddleCell: UITableViewCell {
  
  static let cellId = "MainTableViewMiddleCellId"
  
  let dinnerCollectionViewController = DinnerCollectionViewController()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    addSubview(dinnerCollectionViewController.view)
    dinnerCollectionViewController.view.fillSuperview()
  }
  
  func setViewModel(viewModel: [DinnerViewModel]) {
    
    dinnerCollectionViewController.setViewModel(viewModel: viewModel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
