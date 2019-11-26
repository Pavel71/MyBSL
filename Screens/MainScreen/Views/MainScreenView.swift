//
//  MainScreenView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Class Отвечает за версту View

protocol MainScreenViewModelable {
  
  var chartViewModel: ChartViewModel {get set}
//  var mealCollectionViewModel: String {get set}
  
}

class MainScreenView: UIView {
  
  // TopBar
  let navBar = MainCustomNavBar(frame: MainCustomNavBar.sizeBar)
  let chartView = ChartView()
  let mealCollectionView = MealCollectionView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
 
    setUpViews()
  }
  
  
  private func setViewModel(viewModel: MainScreenViewModelable) {
    
    chartView.chartVC.setViewModel(viewModel: viewModel.chartViewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set Up Views

extension MainScreenView {
  
  private func setUpViews() {
    
    
    let contentStackView = UIStackView(arrangedSubviews: [
    chartView,
    mealCollectionView
    ])
    contentStackView.axis = .vertical
    contentStackView.distribution = .fillEqually
    
     let stackView = UIStackView(arrangedSubviews: [
     navBar,
     contentStackView
     ])
//    navBar.constrainWidth(constant: <#T##CGFloat#>)
    

//     topView.constrainHeight(constant: MainScreenConstants.TopView.height)
     
     stackView.axis = .vertical
     stackView.spacing = 5

  
     addSubview(stackView)
     stackView.fillSuperview()
  }
  
}
