//
//  ResultCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 19.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Ячейка отвечает за подведение итогов по дозировке инсулина

// 1. Текущий сахар - в норме, нужна компенсация - размер, нужна коррекция углеводами
// 2. Кол-во углеводов - Инсулин на углеводы
// 3. Место укола -
// 4. Итого инсулина(Можно даже показать как высчитывается)
// 5. Кнопка Сохранить!
// 6. Сделать это в виде tableView - потомучто наполнятся она будет по разному в зависимости от улсовий! Мы просто делаем коррекцию уколом или коррекцию низкого сахар


// Для начала отрисую тут все и в презентере буду собирать модельку для этой ячейки!

protocol ResultCellable {
  
  var sugarState            : String  {get set}
  var carboCorrectBySugar   : Float?  {get set}
  var insulinCorrectBySugar : Float?  {get set}
  
  var carboTotal            : Double? {get set}
  var mealInsulin           : Float?  {get set}
  
  var resultInsulin         : Float?  {get set}
  
  var placeInjection        : String? {get set}
  
}

class ResultCell: UITableViewCell {
  
  
  //MARK:  Outlets
  
  lazy var generalTitle = CustomLabels(font: .systemFont(ofSize: 20, weight: .heavy), text: "Итоги", textColor: .black)
  
  
  lazy var sugarStateTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Компенсация сахара", textColor: .black)
  
  var valueCorrectBySugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "0.5", textColor: .black)
  
  var mealCarboTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Компенсация углеводов:", textColor: .black)
  
  // или просто сделать это NSString! просто тогда это будет выглядить не красиво!
//  var mealCarboLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "2.0", textColor: .black)
  
  var mealInsulinLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "2.0", textColor: .black)
  
  var totalInsulinTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Всего инсулина:", textColor: .black)
  
  var totalInsulinLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "2.5", textColor: .black)
  
  var placeInjectionTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Место укола:", textColor: .black)
  
  var placeInjectionValueLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Живот", textColor: .black)
  
  
  // MARK: StackViews
  
  // Sugar StackView
  
  lazy var compansationSugarStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
    sugarStateTitleLabel,valueCorrectBySugarLabel
    ])
    sv.spacing      = 5
    sv.distribution = .fill
    valueCorrectBySugarLabel.constrainWidth(constant: 60)
    return sv
  }()
  
  lazy var compansationCarboStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
    mealCarboTitleLabel,mealInsulinLabel
    ])
    sv.spacing      = 5
    sv.distribution = .fill
    mealInsulinLabel.constrainWidth(constant: 60)
    return sv
  }()
  
  lazy var totalInsulinStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
    totalInsulinTitleLabel,totalInsulinLabel
    ])
    sv.spacing      = 5
    sv.distribution = .fill
    totalInsulinLabel.constrainWidth(constant: 60)
    return sv
  }()
  
  lazy var placeInjectionStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
    placeInjectionTitleLabel,placeInjectionValueLabel
    ])
    sv.spacing      = 5
    sv.distribution = .fill
    placeInjectionValueLabel.constrainWidth(constant: 60)
    return sv
  }()
  
  
  
  
  
  static let cellID = "ResultCell"
  
  // MARK: Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setUpViews()
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}


// MARK: SetUpViews

extension ResultCell {
  
  private func setUpViews() {
    
    backgroundColor = .purple
    generalTitle.textAlignment = .center
    
    let verticalStackView = UIStackView(arrangedSubviews: [
    generalTitle,
    compansationSugarStackView,
    compansationCarboStackView,
    totalInsulinStackView,
    placeInjectionStackView
    
    ])
    
    verticalStackView.spacing      = 2
    verticalStackView.distribution = .fillEqually
    verticalStackView.axis         = .vertical
    
    
    addSubview(verticalStackView)
    verticalStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
  
}
