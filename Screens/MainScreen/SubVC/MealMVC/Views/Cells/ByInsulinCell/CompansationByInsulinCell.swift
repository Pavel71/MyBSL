//
//  CorrectionInsulinCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 09.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Ячейка отвечает за отображение данных о том что была коррекция Сахара Инсулином!
//Поидеи мне нужно просто показать полосечку с типичным ТОP Button! где будет только картинка с инсулином


protocol CompansationByInsuliCellable: CompansationCVBaseCellable {
  
  var id          : String                  {get}
  var topButtonVM : TopButtonViewModalable  {get}
  
}


class CompansationByInsulinCell: CompansationCVBaseCell {
  
  
  static let cellId = "CorrectionInsulinCell"
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpViews()
    // Чтобы здесь разместить? в Целом кроме TopButtonView мне тут ничего не надобно
    
  }
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up Views

extension CompansationByInsulinCell {
  
  func setUpViews() {
    let stackView = UIStackView(arrangedSubviews: [
      topButtonView,
      UIView()
    ])
    
    addSubview(stackView)
    stackView.fillSuperview(padding: MainScreenConstants.CollectionView.contentInCellPadding)
  }
  
}

// MARK: Set UP ViewModel
extension CompansationByInsulinCell {
  
  
  func setViewModel(viewModel: CompansationByInsuliCellable) {
    
    objectId = viewModel.id
    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
    
    
  }
}
