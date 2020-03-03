//
//  ResultFooterView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 20.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


protocol ResultFooterViewable {
  
  var message   : String {get set}
  var value     : String {get set}
  var viewState : ResultFooterViewState {get set}
}


class ResultFooterView : UIView {
  
  
  //MARK:  Outlets
  
  lazy var generalTitle = CustomLabels(font: .systemFont(ofSize: 20, weight: .heavy), text: "Итоги", textColor: .white)
  
  
  lazy var sugarStateTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Компенсация сахара", textColor: .white)
  
  var valueCorrectBySugarLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "0.5", textColor: .white)
  
  var mealCarboTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Компенсация углеводов:", textColor: .white)
  
  // или просто сделать это NSString! просто тогда это будет выглядить не красиво!
  //  var mealCarboLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "2.0", textColor: .black)
  
  var mealInsulinLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "2.0", textColor: .white)
  
  
  var totalInsulinTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Всего инсулина:", textColor: .white)
  
  var totalInsulinLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "2.5", textColor: .white)
  
  var placeInjectionTitleLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Место укола:", textColor: .white)
  
  var placeInjectionValueLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Живот", textColor: .white)
  
  
  // MARK: BUttons
  
  var totalInsulinButton: UIButton = {
    
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "anesthesia").withRenderingMode(.alwaysTemplate), for: .normal)
    b.addTarget(self, action: #selector(handleTotalInsulinButton), for: .touchUpInside)
    b.tintColor = .white
    return b
    
  }()
  
  var sugarInBloodBeforeButton: UIButton = {
     
     let b = UIButton(type: .system)
     b.setImage(#imageLiteral(resourceName: "sugar-cubes").withRenderingMode(.alwaysTemplate), for: .normal)
     b.addTarget(self, action: #selector(handleSugarInBloodButton), for: .touchUpInside)
     b.tintColor = .white
     return b
     
   }()
  
  var sugarBeforeLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "7.1", textColor: .white)
  
  var sugarInBloodAfterButton: UIButton = {
    
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "sugar-cubes").withRenderingMode(.alwaysTemplate), for: .normal)
    b.addTarget(self, action: #selector(handleSugarInBloodButton), for: .touchUpInside)
    b.tintColor = .white
    return b
    
  }()
  
  var carboInMealButton: UIButton = {
     
     let b = UIButton(type: .system)
     b.setImage(#imageLiteral(resourceName: "food").withRenderingMode(.alwaysOriginal), for: .normal)
     b.addTarget(self, action: #selector(handleCarboInMealButton), for: .touchUpInside)
     
     return b
     
   }()
  
  var mealCarboLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "36", textColor: .white)

  
  
  
  
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
  
//  lazy var totalInsulinStackView: UIStackView = {
//    let sv = UIStackView(arrangedSubviews: [
//      totalInsulinLabel,totalInsulinLabel
//    ])
//    sv.spacing      = 5
//    sv.distribution = .fill
//    totalInsulinLabel.constrainWidth(constant: 60)
//    return sv
//  }()
  
  lazy var placeInjectionStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
      placeInjectionTitleLabel,placeInjectionValueLabel
    ])
    sv.spacing      = 5
    sv.distribution = .fill
    placeInjectionValueLabel.constrainWidth(constant: 60)
    return sv
  }()
  
  
  // MARK: Symbols StackView
  
  
  lazy var carboMealStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
      carboInMealButton,mealCarboLabel
    ])
    sv.distribution = .fillEqually
    sv.spacing      = 5
    return sv
  }()
  
  lazy var sugarBeforeStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [
      sugarInBloodBeforeButton,sugarBeforeLabel
    ])
    sv.distribution = .fillEqually
    sv.spacing      = 5
    return sv
  }()
  
  lazy var totalInsulinStackView: UIStackView = {

     let sv = UIStackView(arrangedSubviews: [
      totalInsulinButton,totalInsulinLabel
     ])
     sv.distribution = .fillEqually
     sv.spacing      = 5
     return sv
   }()
  
  
  lazy var mealAndTotalInsulinStackView: UIStackView = {

    let sv = UIStackView(arrangedSubviews: [
      sugarBeforeStackView,createSpreadImageView(),carboMealStackView,createSpreadImageView(),totalInsulinStackView
    ])
    sv.distribution = .fillEqually
    sv.spacing      = 5
    return sv
  }()
  
  
  
  let resultLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Нужен инсулин (ед.)", textColor: .white)
  let resultValue = CustomLabels(font: .systemFont(ofSize: 20, weight: .bold), text: "2.0", textColor: .white)
  
 
  
  
  
  
  
  static let cellID = "ResultCell"
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    //    setUpViews()
    setUpViews2()
  }
  
  
  
  
  private func createSpreadImageView() -> UIImageView {
    let iv = UIImageView(image: #imageLiteral(resourceName: "spreadArrow"))
    iv.imageColor = .white
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    
      return iv
  }
  
  
 
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set up ViewModel

extension ResultFooterView {
  
  func setViewModel(viewModel: ResultFooterViewable) {
    
    
    resultLabel.text = viewModel.message
    resultValue.text = viewModel.value
    
    hidden(state: viewModel.viewState)
    
  }
  
  private func hidden(state: ResultFooterViewState) {
     
     
     self.isHidden = state == .hidden
   }
}


// MARK: Handle Signals

extension ResultFooterView {
  
  @objc private func handleTotalInsulinButton() {
    print("Show Total Insulin")
  }
  
  @objc private func handleSugarInBloodButton() {
    print("Show Sugar ")
  }
  
  @objc private func handleCarboInMealButton() {
    print("Show Carbo")
  }
}


// MARK: SetUpViews

extension ResultFooterView {
  
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
  
  private func setUpViews2() {
    
    
    backgroundColor = .purple
    generalTitle.textAlignment = .center
    
    
//    let leftStackView = UIStackView(arrangedSubviews: [
//      totalInsulinButton,
//      placeInjectionTitleLabel
//
//    ])
//    leftStackView.axis = .vertical
//    leftStackView.distribution = .fillEqually
//    leftStackView.spacing = 2
//    leftStackView.alignment = .center
//
//    let rightStackView = UIStackView(arrangedSubviews: [
//      totalInsulinLabel,
//      placeInjectionValueLabel
//    ])
//
//    rightStackView.axis = .vertical
//    rightStackView.distribution = .fillEqually
//    rightStackView.spacing = 2
//    rightStackView.alignment = .center
//
//    let horizontalStackView = UIStackView(arrangedSubviews: [
//      leftStackView,rightStackView
//    ])
//    horizontalStackView.distribution = .fillEqually
//    horizontalStackView.spacing = 5
    
    
    let resultStackView = UIStackView(arrangedSubviews: [
    resultLabel,resultValue
    ])
    
    resultLabel.textAlignment = .center
    resultValue.textAlignment = .center
    
    resultStackView.distribution = .fillEqually
    resultStackView.spacing = 5
    
    
    
    let overAllStackView = UIStackView(arrangedSubviews: [
      generalTitle,
      resultStackView
//      mealAndTotalInsulinStackView
    ])
    overAllStackView.axis = .vertical
    overAllStackView.spacing = 5
    overAllStackView.distribution = .fillEqually
    
    
    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
  
  
  
  
  
}
