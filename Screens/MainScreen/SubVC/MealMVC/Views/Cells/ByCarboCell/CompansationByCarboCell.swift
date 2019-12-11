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


// Эта ячейка особо не отличается от meal если мы будет давать выбирать продукт питания на компенсацию!
// Пока не знаю стоит ли на этот счет замарачиватся и просто отобразить что было потребленно 5-7 углеводов в качестве компенсации.

class CompansationByCarboCell: CompansationCVBaseCell {
  
  static let cellId = "CorrectSugarByCarboCell"

  var imageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "up-arrow-sugar"))
    // iv.frame = .init(x: 0, y: 0, width: 100, height: 100)
    iv.contentMode = .scaleAspectFit
   // iv.backgroundColor = UIColor(white: 0.7, alpha: 0.6)
    return iv
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
//    backgroundColor               = .white
//    topButtonView.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    setUpViews()
  }
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Up Views

extension CompansationByCarboCell {
  
  func setUpViews() {
    
    let spacerView = UIView()
    spacerView.backgroundColor = .white
 
    
    let stackView = UIStackView(arrangedSubviews: [
      topButtonView,
      imageView
    ])
    topButtonView.constrainHeight(constant: 20)
   
    
    stackView.axis         = .vertical
    stackView.distribution = .fill
    stackView.spacing      = 10
    
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


