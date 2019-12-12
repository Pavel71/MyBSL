//
//  TopButtonView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Класс отвечает за кнопки управления обедам

// 1. Удалить Обед

// 2. Статус Компенсации
// 3. Редактировать обед

protocol TopButtonViewModalable {
  
  var type    : TypeCompansationObject {get}
  var carbo   : Double {get}
  var insulin : Double {get}
  
}

class TopButtonView: UIView {

  lazy var deleteButton              : UIButton = createButton(image: #imageLiteral(resourceName: "cancel"))
//  lazy var checkStatusDinnerButton: UIButton = createButton(image: #imageLiteral(resourceName: "info"))
  lazy var updateButton              : UIButton = createButton(image: #imageLiteral(resourceName: "tools"))
  lazy var injectionResultButton     : UIButton = createButton(image: #imageLiteral(resourceName: "anesthesia"))
  
  // Кнопочка если у нас полноценный обед
  lazy var carboMealResultButton     : UIButton = createButton(image: #imageLiteral(resourceName: "food"))
  
  lazy var sugarCorrectByCarboButton : UIButton = createButton(image: #imageLiteral(resourceName: "candy"))
  
  // Кнопочка если мы просто что-то едим для выравнивания сахара!
  
  
  
  func createButton(image: UIImage) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
    return button
  }
  
  var injectionResultLabel  = CustomLabels(font: .systemFont(ofSize: 16), text: "6.0")
  var carboInMealLabel      = CustomLabels(font: .systemFont(ofSize: 16), text: "25.0")
  var carboCorrectionLabel  = CustomLabels(font: .systemFont(ofSize: 16), text: "5.0")
  
  
  var cellDataStackView = UIStackView()
  
  var mealObjectStackView            : UIStackView!
  var correctSugarByInsulinStackView : UIStackView!
  var correctSugarByCarboStackView   : UIStackView!
  

  
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.layer.cornerRadius = 10
    self.clipsToBounds      = true
    
    setUpViews()
    
  }
  
  // MARK: Handle Button Action
  
  @objc private func handleButtonAction(button: UIButton) {
    
    switch button {
    case deleteButton:
      print("Delete Clouser")
    case updateButton:
      print("Update Clouser")
    case injectionResultButton:
      print("Show Short Stat by Injections")
    case carboMealResultButton:
      print("Show Message that it it a Meak Carbo")
    case sugarCorrectByCarboButton :
      print("Show That it is a correction Carbo")

    default:break
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set View Models
extension TopButtonView {
  
  func setViewModel(viewModel:TopButtonViewModalable) {
    
    switch viewModel.type {
    case .correctSugarByCarbo:
      print("PЗдесь я устанавливаю стек вью с конфеткой")
      
      carboCorrectionLabel.text               = "\(viewModel.carbo)"
      
      correctSugarByInsulinStackView.isHidden = true
      correctSugarByCarboStackView.isHidden   = false
      mealObjectStackView.isHidden            = true
      
    case .correctSugarByInsulin:
      print("Здесь я устанавливаю стек вью с шприцом")
      
      injectionResultLabel.text               = "\(viewModel.insulin)"
      
      correctSugarByInsulinStackView.isHidden = false
      correctSugarByCarboStackView.isHidden   = true
      mealObjectStackView.isHidden            = true

    case .mealObject:
      print("Тут у меня картиночка с обедом и шприц с инсулином!")
      
      carboInMealLabel.text                   = "\(viewModel.carbo)"
      injectionResultLabel.text               = "\(viewModel.insulin)"
      
      correctSugarByInsulinStackView.isHidden = false
      correctSugarByCarboStackView.isHidden   = true
      mealObjectStackView.isHidden            = false
    }

    
  }
  
}


// MARK: Set Up Views


// У меня может быть варианта стека в зависимости от типа ячейки которая приходит!

extension TopButtonView {
  
  private func setUpViews() {
    
    
    configureCorrectSugarByInsulinStackView()
    configureMealObjectStackView()
    configureCorrectSugarByCarboStackView()
    
    let allStackView = UIStackView(arrangedSubviews: [
    correctSugarByCarboStackView,mealObjectStackView,correctSugarByInsulinStackView
    
    ])
    allStackView.distribution = .fillEqually
    allStackView.spacing      = 5
     
     let stackView = UIStackView(arrangedSubviews: [
       deleteButton,allStackView,updateButton
     ])
    
    stackView.distribution = .equalCentering
     
     addSubview(stackView)
     stackView.fillSuperview()
  }
  
  private func configureCorrectSugarByInsulinStackView()  {
    
    correctSugarByInsulinStackView = UIStackView(arrangedSubviews: [
    injectionResultButton,injectionResultLabel
    ])
    correctSugarByInsulinStackView.distribution = .fillEqually
    correctSugarByInsulinStackView.spacing      = 10
    
    
  }
  private func configureMealObjectStackView() {
    
    mealObjectStackView = UIStackView(arrangedSubviews: [
    carboMealResultButton,carboInMealLabel
    ])
    mealObjectStackView.distribution = .fillEqually
    mealObjectStackView.spacing      = 10
    
//    mealObjectStackView = UIStackView(arrangedSubviews: [
//    carboMealStackView
//    ])
//    mealObjectStackView.distribution = .fillEqually
//    mealObjectStackView.spacing      = 5
    
    
    
  }
  private func configureCorrectSugarByCarboStackView()  {
    correctSugarByCarboStackView = UIStackView(arrangedSubviews: [
    sugarCorrectByCarboButton,carboCorrectionLabel
    ])
    correctSugarByCarboStackView.distribution = .fillEqually
    correctSugarByCarboStackView.spacing = 10
    
    
  }
}
