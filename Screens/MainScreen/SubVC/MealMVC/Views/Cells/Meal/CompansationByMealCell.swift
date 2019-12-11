//
//  InsulinInjectionsCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol CompansationByMealCellable {
  
  var id                     : String                      {get}
  var topButtonVM            : TopButtonViewModalable      {get}
  var mealProductVCViewModel : MealProductsVCViewModel     {get set}
  var compansationFase       : CompansationPosition        {get set}
  // Это нужно запехнуть в продукт лист и убрать снизу из ячейки!
//  var productResultViewModel : ProductListResultsViewModel {get set}
}


class CompansationByMealCell: UICollectionViewCell {
  
  static let cellId = "InsulinInjectionsCollectionViewCell"
  
  let topButtonView = TopButtonView()
  let productTableViewController = MealProductsVC()
  let resultView = MealProductsFooterView(frame: .init(x: 0, y: 0, width: 0, height: Constants.ProductList.TableFooterView.footerHeight))
  
  
  var mealCompansation: CompansationPosition = .new
  var mealId: String!
  
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

extension CompansationByMealCell {
  
  func setViewModel(viewModel: CompansationByMealCellable) {
    
    topButtonView.setViewModel(viewModel: viewModel.topButtonVM)
    
    mealId           = viewModel.id
    mealCompansation = viewModel.compansationFase
    
    // ResultsViewModel
//    resultView.setViewModel(viewModel: viewModel.productResultViewModel)
    
    // Products ViewModel
    productTableViewController.setViewModel(viewModel: viewModel.mealProductVCViewModel)
  }
  
}


// MARK: Set UP Views

extension CompansationByMealCell {
  
  private func setUpViews() {
    
    // topButtonView,
    let stackView = UIStackView(arrangedSubviews: [
    topButtonView,
    productTableViewController.view
//    resultView
    ])
    topButtonView.constrainHeight(constant: 25)
//    resultView.constrainHeight(constant: 40)
    
    stackView.axis = .vertical
    stackView.spacing = 5
    
    addSubview(stackView)
    stackView.fillSuperview(padding: MainScreenConstants.CollectionView.contentInCellPadding)
  }
  
}
