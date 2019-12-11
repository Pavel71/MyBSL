//
//  MealCVBaseCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MealCVBaseCellable {
  var id          : String                  {get}
  var topButtonVM : TopButtonViewModalable  {get}
}


class MealCVBaseCell: UICollectionViewCell {
  
  let topButtonView = TopButtonView()
  var objectId: String!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
  }
  
  override func draw(_ rect: CGRect) {
     super.draw(rect)
     
     clipsToBounds = true
     layer.cornerRadius = 10
   }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set ViewModels
extension MealCVBaseCell {
  
  func setViewModel(viewModel:MealCVBaseCellable ) {
    objectId      = viewModel.id
    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
  }
  
}
