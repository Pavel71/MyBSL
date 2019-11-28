//
//  InsulinInjectionsCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MealCollectionCellable {
  
  var mealProductVCViewModel : MealProductsVCViewModel {get set}
  var compansationFase       : CompansationPosition   {get set}
  
}


class MealCollectionCell: UICollectionViewCell {
  
  static let cellId = "InsulinInjectionsCollectionViewCell"
  
  let topButtonView = TopButtonView()
  let productTableViewController = MealProductsVC()
//  let resultView = ProductListResultView()
  
  
  var mealCompansation: CompansationPosition = .new
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    setUpViews()
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

// MARK: Set View Model

extension MealCollectionCell {
  
  func setViewModel(viewModel: MealCollectionCellable) {
    
    mealCompansation = viewModel.compansationFase
    productTableViewController.setViewModel(viewModel: viewModel.mealProductVCViewModel)
  }
  
}


// MARK: Set UP Views

extension MealCollectionCell {
  
  private func setUpViews() {
    
    let stackView = UIStackView(arrangedSubviews: [
    topButtonView,
    productTableViewController.view,
    ])
    topButtonView.constrainHeight(constant: 35)
    
    
    stackView.axis = .vertical
    stackView.spacing = 5
    
    addSubview(stackView)
    stackView.fillSuperview(padding: MainScreenConstants.CollectionView.contentInCellPadding)
  }
  
}
