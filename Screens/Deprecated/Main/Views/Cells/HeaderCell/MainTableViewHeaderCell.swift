//
//  MainTableViewHeaderCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MainTableViewHeaderCellable {
  
  var lastInjectionValue: Float {get}
  var lastTimeInjectionValue: Date? {get}
  var lastShugarValue: Float {get}
  var insulinSupplyInPanValue: Float {get}
  
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
  
  
  // Menu View Controller
  
  //  let menuViewController = MenuDinnerViewController()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    backgroundColor = .white
    
    insulinSupplyInPanValueLabel.textColor = .red
    
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

    let timeString = DateWorker.shared.getOnlyClock(date: viewModel.lastTimeInjectionValue)
    
    lastInjectionValueLabel.text = String(viewModel.lastInjectionValue)
    lastTimeInjectionValueLabel.text = timeString
    insulinSupplyInPanValueLabel.text = String(viewModel.insulinSupplyInPanValue)
    lastShugarValueLabel.text = String(viewModel.lastShugarValue)

  }
  
  
  // Короче надо засетить сюда флаг что мы меняем ячейку и пускай включается контроолер сверху
  //  func setUpMenuViewController() {
  //
  //    addSubview(menuViewController.view)
  //    menuViewController.view.fillSuperview()
  //    menuViewController.setDefaultChooseProduct()
  //
  //  }
  //
  //  func removeMenuViewController() {
  //    menuViewController.view.removeFromSuperview()
  //  }
  
  
  
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
