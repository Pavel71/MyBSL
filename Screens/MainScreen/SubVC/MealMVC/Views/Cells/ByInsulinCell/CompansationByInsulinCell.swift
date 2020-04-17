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
  
  
  var imageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "down-arrow"))
    iv.contentMode = .scaleAspectFit
    iv.tintColor = UIColor(white: 0.9, alpha: 0.6)
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpViews()
    
    
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
      imageView
    ])
    topButtonView.constrainHeight(constant: 30)
    stackView.axis         = .vertical
    stackView.distribution = .fill
    stackView.spacing      = 5
    
    addSubview(stackView)
    stackView.fillSuperview(padding: MainScreenConstants.CollectionView.contentInCellPadding)
//    stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 10, left: 10, bottom: 0, right: 10))
  }
  
}

// MARK: Set UP ViewModel
extension CompansationByInsulinCell {
  
  
  func setViewModel(viewModel: CompansationByInsuliCellable) {
    
    objectId     = viewModel.id
    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
    
  }
}
