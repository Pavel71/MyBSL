//
//  CorrectSugarByCarboCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



protocol CompansationByCarboCellable: CompansationCVBaseCellable {
  
  var id          : String                  {get}
  var topButtonVM : TopButtonViewModalable  {get}
}


class CompansationByCarboCell: CompansationCVBaseCell {
  
  static let cellId = "CorrectSugarByCarboCell"
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpViews()
  }
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Up Views

extension CompansationByCarboCell {
  
  func setUpViews() {
    
    let stackView = UIStackView(arrangedSubviews: [
      topButtonView,
      UIView()
    ])
    
    addSubview(stackView)
    stackView.fillSuperview(padding: MainScreenConstants.CollectionView.contentInCellPadding)
  }
  
}


// MARK: Set View Model

extension CompansationByCarboCell {
  
  func setViewModel(viewModel: CompansationByCarboCellable) {
    
    objectId = viewModel.id
    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
  }
}


