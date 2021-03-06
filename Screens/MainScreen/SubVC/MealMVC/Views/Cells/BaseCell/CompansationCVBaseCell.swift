//
//  CompansationCVBaseCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


import UIKit


protocol CompansationCVBaseCellable {
  var id          : String                  {get}
  var topButtonVM : TopButtonViewModalable  {get}
}


class CompansationCVBaseCell: UICollectionViewCell {
  
  let topButtonView = TopButtonView()
  var objectId: String!
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
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
//extension CompansationCVBaseCell {
//  
//  func setViewModel(viewModel:CompansationCVBaseCellable ) {
//    objectId      = viewModel.id
//    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
//  }
//  
//}
