//
//  StatsView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 23.06.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// И так нам нужен title и robot View

// 1. Теперь нужно сделать модель с данными для RobotView - тут нужно оттакливатся от кол-во объектов и подумать о градацции уровней робота!



class StatsView: UIView {
  
  
  // MARK: Outlets
  
  var statsNavBar = StatsNavBar(frame: StatsNavBar.sizeBar)
  
  let screenWidth = UIScreen.main.bounds.width
  
  
  
  var countDinnersLabel: UILabel = {
    let l = UILabel()
    l.font          = UIFont.systemFont(ofSize: 16)
    l.text          = "Кол-во обедов 10 500"
    l.textAlignment = .center
    return l
  }()
  
  var mediumSugarForTenDaysTitle : UILabel = {
    let l = UILabel()
    l.font          = UIFont.systemFont(ofSize: 16)
    l.text          = "Средний сахар за последние 10 дней:"
    l.numberOfLines = 0
    return l
  }()
  
  var mediumSygarValue : UILabel = {
    let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 16)
      l.text = "5.6"
      return l
  }()
  
  var mediumInsulinForAllInjections : UILabel = {
    let l = UILabel()
    l.font          = UIFont.systemFont(ofSize: 16)
    l.text          = "Средний инсулина на 10 гр. углеводов:"
    l.numberOfLines = 0
    return l
  }()
  
  var mediumInsuliValue : UILabel = {
    let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 16)
      l.text = "1.2"
      return l
  }()
  
  // ROBOT View
  var robotView   = RobotView()
  // Pie Chart View
  
  var pieChartVC  = PieChartViewController()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    setUpViews()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}


//MARK: Set View Model
extension StatsView {
  
  func setViewModel(viewModel: StatsModel) {
    
    mediumInsuliValue.text = "\(viewModel.meanInsulinOnCarbo)"
    mediumSygarValue.text  = "\(viewModel.meanSugarFor10Days)"
    pieChartVC.setDataCount(pieChartModel: viewModel.pieChartModel)
    robotView.setViewModel(viewModel: viewModel.robotViewModel)
    countDinnersLabel.text = "Кол-во обедов \(viewModel.robotViewModel.allCompObjCount)"
    
  }

}
// MARK: Set Up Views
extension StatsView {
  
  private func setUpViews() {
    addNavBar()
    addVstack()
    
  }
  
  private func addNavBar() {
    addSubview(statsNavBar)
    statsNavBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
  }
  
  private func addVstack() {
    
    let padding : CGFloat = 10
    
    let mediumSugarStack = UIStackView(arrangedSubviews: [
      mediumSugarForTenDaysTitle,mediumSygarValue
    ])
    mediumSugarStack.distribution = .fill
    mediumSugarStack.spacing      = 5
    
    mediumSugarForTenDaysTitle.constrainWidth(constant: screenWidth - 50 - padding)
    
    let mediumInsulinStack = UIStackView(arrangedSubviews: [
      mediumInsulinForAllInjections,mediumInsuliValue
    ])
    mediumInsulinStack.distribution = .fill
    mediumInsulinStack.spacing      = 5
    
    mediumInsulinForAllInjections.constrainWidth(constant: screenWidth - 50 - padding)
    
    let vStack = UIStackView(arrangedSubviews: [
    countDinnersLabel,
    robotView,
    mediumSugarStack,
    mediumInsulinStack,
    pieChartVC.view
    ])
    
    pieChartVC.view.constrainWidth(constant: screenWidth - padding)
    pieChartVC.view.constrainHeight(constant: screenWidth - padding)
    
    vStack.distribution = .fill
    vStack.spacing      = 5
    vStack.axis         = .vertical
    vStack.alignment    = .center
    
    addSubview(vStack)
    vStack.anchor(top: statsNavBar.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: padding * 2, left: padding, bottom: 0, right: padding))
  }
  

}
