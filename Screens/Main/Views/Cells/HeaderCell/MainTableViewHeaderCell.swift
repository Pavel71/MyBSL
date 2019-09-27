//
//  MainTableViewHeaderCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MainTableViewHeaderCellable {
  
  var lastInjectionValue: String {get}
  var lastTimeInjectionValue: String {get}
  var lastShugarValueLabel: String {get}
  var insulinSupplyInPanValue: String {get}
}


class MainTableViewHeaderCell: UITableViewCell {
  
  static let cellId = "MainTableViewHeaderCellId"
  
  // Нужно заполнить эту ячейку определенными полями
  
  // Injections
  lazy var lastInjectionLabel =  createTitleLabels(name: "Последняя инъекция")
  lazy var lastInjectionValueLabel = createValueLabels()
  
  // Time Injections
  lazy var lastTimeInjectionLabel =  createTitleLabels(name: "Последнее время инъекции")
  lazy var lastTimeInjectionValueLabel = createValueLabels()
  
  // Insulin Supply
  lazy var insulinSupplyInPanLabel =  createTitleLabels(name: "Кол-во Инсулина в картридже")
  lazy var insulinSupplyInPanValueLabel = createValueLabels()
  
  // Last Shugar Value
  
  lazy var lastShugarLabel =  createTitleLabels(name: "Последние данные по сахару")
  lazy var lastShugarValueLabel = createValueLabels()
  
  // Title Label
  lazy var titleLabel = createTitleLabels(name: "Быстрая статистика", fontSize: 22)
  
  private func createTitleLabels(name: String, fontSize: CGFloat = 18 ) -> UILabel {
    let label = UILabel()
    label.text = name
    label.font = UIFont.systemFont(ofSize: fontSize)
    label.numberOfLines = 0
    return label
    
  }
  private func createValueLabels() -> UILabel {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = "100"
    return label
  }
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .white
    
    let labelsStackView = UIStackView(arrangedSubviews: [
      lastInjectionLabel,
      lastTimeInjectionLabel,
      lastShugarLabel,
      insulinSupplyInPanLabel
      ])
    labelsStackView.axis = .vertical
    labelsStackView.distribution = .fillEqually
    
    let valuelabelsStackView = UIStackView(arrangedSubviews: [
      lastInjectionValueLabel,
      lastTimeInjectionValueLabel,
      lastShugarValueLabel,
      insulinSupplyInPanValueLabel
      ])
    valuelabelsStackView.axis = .vertical
    valuelabelsStackView.distribution = .fillEqually
    valuelabelsStackView.constrainWidth(constant: Constants.numberValueTextFieldWidth)
    
    let horizontalStackView = UIStackView(arrangedSubviews: [
      labelsStackView,valuelabelsStackView
      ])
    
    let overAllStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      horizontalStackView
      ])
    overAllStackView.axis = .vertical
    overAllStackView.distribution = .fill
    titleLabel.textAlignment = .center
    titleLabel.constrainHeight(constant: 30)
    
    

    
    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: .init(top: 5, left: 8, bottom: 5, right: 8))

  }
  
  func setViewModel(viewModel:MainTableViewHeaderCellable) {
    
    lastInjectionValueLabel.text = viewModel.lastInjectionValue
    lastTimeInjectionValueLabel.text = viewModel.lastTimeInjectionValue
    insulinSupplyInPanValueLabel.text = viewModel.insulinSupplyInPanValue
    lastShugarValueLabel.text = viewModel.lastShugarValueLabel
  }
  
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}







//    let injectionStackView = UIStackView(arrangedSubviews: [
//      lastInjectionLabel,lastInjectionValueLabel
//      ])
//
//    let timeStackView = UIStackView(arrangedSubviews: [
//      lastTimeInjectionLabel,lastTimeInjectionValueLabel
//      ])
//
//    let insulinSupplyStackView = UIStackView(arrangedSubviews: [
//      insulinSupplyInPanLabel,insulinSupplyInPanValueLabel
//      ])
//
//    let shugarStackView = UIStackView(arrangedSubviews: [
//      lastShugarLabel,lastShugarValueLabel
//      ])
//
//    let verticalStackView = UIStackView(arrangedSubviews: [
//      injectionStackView,
//      timeStackView,
//      insulinSupplyStackView,
//      shugarStackView
//
//      ])
//    verticalStackView.axis = .vertical
//    verticalStackView.distribution = .fill
