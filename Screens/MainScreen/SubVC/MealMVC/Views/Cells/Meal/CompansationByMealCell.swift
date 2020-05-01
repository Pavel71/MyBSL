//
//  InsulinInjectionsCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol CompansationByMealCellable: CompansationCVBaseCellable {
  
  var id                     : String                      {get}
  var topButtonVM            : TopButtonViewModalable      {get}
  var mealProductVCViewModel : MealProductsVCViewModel     {get set}
  var compansationFase       : CompansationPosition        {get set}

}


class CompansationByMealCell: CompansationCVBaseCell {
  
  static let cellId = "InsulinInjectionsCollectionViewCell"
  
  let productTableViewController = MealProductsVC()
  
  let resultView = MealProductsFooterView(frame: .init(x: 0, y: 0, width: 0, height: Constants.ProductList.TableFooterView.footerHeight))
  
  
  var mealCompansation: CompansationPosition = .progress

  
  override init(frame: CGRect) {
    super.init(frame: frame)

    
    setUpViews()
  }
  

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set View Model

extension CompansationByMealCell {
  
  func setViewModel(viewModel: CompansationByMealCellable) {
    
    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
    
    objectId         = viewModel.id
    mealCompansation = viewModel.compansationFase

    productTableViewController.setViewModel(viewModel: viewModel.mealProductVCViewModel)
  }
  
}


// MARK: Set UP Views

extension CompansationByMealCell {
  
  private func setUpViews() {
    
//    addSubview(topButtonView)
//    topButtonView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 5, left: 5, bottom: 0, right: 5))
//    topButtonView.constrainHeight(constant: 30)
//
//
//    addSubview(productTableViewController.view)
//    productTableViewController.view.anchor(top: topButtonView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding:MainScreenConstants.CollectionView.contentInCellPadding)
    
    
//    // topButtonView,
    let stackView = UIStackView(arrangedSubviews: [
    topButtonView,
    productTableViewController.view

    ])
    topButtonView.constrainHeight(constant: 30)

    stackView.axis = .vertical
    stackView.spacing = 5

    addSubview(stackView)
    stackView.fillSuperview(padding: MainScreenConstants.CollectionView.contentInCellPadding)
  }
  
}
