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
  
  var chartVCVM       : ChartVCViewModel       {get set}
  var collectionVCVM  : CollectionVCVM         {get set}
  var insulinSupplyVM : InsulinSupplyViewModel {get set}
  var dayDate         : String                 {get set}
  
}

class MainScreenView: UIView {
  
  // TopBar
  let navBar             = MainCustomNavBar(frame: MainCustomNavBar.sizeBar)
  let insulinSupplyView  = InsulinSupplyView()
  let chartView          = ChartView()
  let mealCollectionView = MealCollectionView()
  let newSugarView       = NewSugarDataView(frame: NewSugarDataView.sizeView)
  let calendareView      = CalendarView(frame: CalendarView.sizeView)
  
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpViews()
  }
  
  
  func setViewModel(viewModel: MainScreenViewModelable) {
    
    navBar.setTitle(title: viewModel.dayDate)
    
    chartView.chartVC.setViewModel(viewModel               : viewModel.chartVCVM)
    mealCollectionView.collectionVC.setViewModel(viewModel : viewModel.collectionVCVM)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set Up Views

extension MainScreenView {
  
  private func setUpViews() {
    
    setUpStackViews()
    
    setUpBlurEffect()
    setCalendarView()
    setNewSugarDataView()
    
  }
  
  
  
  private func setUpStackViews() {
    
    let chartAndSupplyStack = UIStackView(arrangedSubviews: [
      chartView,
      insulinSupplyView
    ])
    insulinSupplyView.constrainHeight(constant: 30)
    chartAndSupplyStack.axis = .vertical
    chartAndSupplyStack.spacing = 5

    let contentStackView = UIStackView(arrangedSubviews: [
      chartAndSupplyStack,
      mealCollectionView
    ])
    contentStackView.axis = .vertical
    contentStackView.distribution = .fillEqually
    
    let stackView = UIStackView(arrangedSubviews: [
      navBar,
      contentStackView
    ])
    
    stackView.axis = .vertical
    stackView.spacing = 5
    
    
    addSubview(stackView)
    stackView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor)
  }
  
  
  // Set UP NewSugar View
  private func setNewSugarDataView() {
    addSubview(newSugarView)
    newSugarView.centerInSuperview()
    
    // Убираем вправый угол!
    newSugarView.hideViewOnTheRightCorner()
    
//
//    let testView = UIView(frame: .zero)
//    testView.backgroundColor = .yellow
//    addSubview(testView)
//    testView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 80, left: 10, bottom: 0, right: 10),size: .init(width: 200, height: 300))
  }
  
  private func setCalendarView() {
//
    addSubview(calendareView)
    calendareView.centerInSuperview(size: .init(
      width : CalendarView.sizeView.width,
      height: CalendarView.sizeView.height))

    
//    calendareView.hideToTheLeftCorner()
  }
  
  // Set Up Blur
  private func setUpBlurEffect() {
     addSubview(blurView)
    blurView.fillSuperview()

     blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnBlur)))
   }
  
  @objc private func didTapOnBlur() {
    self.superview?.endEditing(true)
  }
  
}
