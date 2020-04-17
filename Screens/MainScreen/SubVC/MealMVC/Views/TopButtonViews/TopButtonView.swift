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

enum CanRedactingCompObj {
  case can,not
}

protocol TopButtonViewModalable {
  
  var type          : TypeCompansationObject {get}
  var carbo         : Double {get}
  var insulin       : Double {get}
  var sugarBefore   : Double {get}
  var sugarAfter    : Double {get}
  var isRedactating : CanRedactingCompObj {get}
  
}

class TopButtonView: UIView {
  
  
  // MARK: Buttons

  lazy var deleteButton              : UIButton = createButton(image: #imageLiteral(resourceName: "cancel"))
//  lazy var checkStatusDinnerButton: UIButton = createButton(image: #imageLiteral(resourceName: "info"))
  lazy var updateButton              : UIButton = createButton(image: #imageLiteral(resourceName: "tools"))
  lazy var injectionResultButton     : UIButton = createButton(image: #imageLiteral(resourceName: "anesthesia"))
  
  // Кнопочка если у нас полноценный обед
  lazy var carboMealResultButton     : UIButton = createButton(image: #imageLiteral(resourceName: "food"))
  
  lazy var sugarCorrectByCarboButton : UIButton = createButton(image: #imageLiteral(resourceName: "candy"))
  lazy var sugarBeforeButton         : UIButton = createButton(image: #imageLiteral(resourceName: "sugar-cubes"))
  lazy var sugarAfterButton          : UIButton = createButton(image: #imageLiteral(resourceName: "sugar-cubes"))
  
  // Кнопочка если мы просто что-то едим для выравнивания сахара!
  
  
  // MARK: Clousers
  
  var didTapDeleteButton     :  EmptyClouser?
  var didTapUpdateButton     :  EmptyClouser?
  var didTapShowSugarBefore  : StringPassClouser?
  var didTapShowSugarAfter   : StringPassClouser?
  var didTapShowTotalCarbo   : StringPassClouser?
  var didTapShowTotalInsulin : StringPassClouser?
  
  
  
  
  func createButton(image: UIImage) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
    return button
  }
  
  var injectionResultLabel  = CustomLabels(font: .systemFont(ofSize: 16), text: "6.0")
  var carboInMealLabel      = CustomLabels(font: .systemFont(ofSize: 16), text: "25.0")
  var carboCorrectionLabel  = CustomLabels(font: .systemFont(ofSize: 16), text: "5.0")
  var sugarBeforeLabel      = CustomLabels(font: .systemFont(ofSize: 16), text: "5.0")
  var sugarAfterLabel       = CustomLabels(font: .systemFont(ofSize: 16), text: "5.0")
  
  
  var cellDataStackView = UIStackView()
  
  var mealObjectStackView            : UIStackView!
  var correctSugarByInsulinStackView : UIStackView!
  var correctSugarByCarboStackView   : UIStackView!
  var sugarBeforeStackView           : UIStackView!
  var sugarAfterStackView            : UIStackView!
  

  
  
  
  
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
      
      didTapDeleteButton!()
    case updateButton:
      
      didTapUpdateButton!()
      
    case injectionResultButton:
      
      didTapShowTotalInsulin!(injectionResultLabel.text ?? "")
      
    case carboMealResultButton:
      
      didTapShowTotalCarbo!(carboInMealLabel.text ?? "")
      
    case sugarCorrectByCarboButton :
      print("Show That it is a correction Carbo")
      
    case sugarBeforeButton:
      didTapShowSugarBefore!(sugarBeforeLabel.text ?? "")
    case sugarAfterButton:
      didTapShowSugarAfter!(sugarAfterLabel.text ?? "")

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
    
    sugarBeforeLabel.text = "\(viewModel.sugarBefore.roundToDecimal(2))"
    sugarAfterLabel.text  = "\(viewModel.sugarAfter.roundToDecimal(2))"
    
    switch viewModel.type {
    case .correctSugarByCarbo:
      
      
      carboCorrectionLabel.text               = "\(viewModel.carbo.roundToDecimal(2))"
      
      correctSugarByInsulinStackView.isHidden = true
      correctSugarByCarboStackView.isHidden   = false
      mealObjectStackView.isHidden            = true
      
    case .correctSugarByInsulin:
      
      
      injectionResultLabel.text               = "\(viewModel.insulin.roundToDecimal(2))"
      
      correctSugarByInsulinStackView.isHidden = false
      correctSugarByCarboStackView.isHidden   = true
      mealObjectStackView.isHidden            = true

    case .mealObject:
      
      
      carboInMealLabel.text                   = "\(viewModel.carbo.roundToDecimal(2))"
      injectionResultLabel.text               = "\(viewModel.insulin.roundToDecimal(2))"
      
      correctSugarByInsulinStackView.isHidden = false
      correctSugarByCarboStackView.isHidden   = true
      mealObjectStackView.isHidden            = false
    }
    
    // Не позволяем редактировать обхект если его статус изменилдся с прогресса на другой!
    setStateRedactingCompansationObject(canRedacting: viewModel.isRedactating)

    
  }
  
  private func setStateRedactingCompansationObject(canRedacting: CanRedactingCompObj) {
    
    switch canRedacting {
    case .can:
      deleteButton.isHidden = false
      updateButton.isHidden = false
      
      sugarAfterStackView.isHidden = true
    case .not:
      deleteButton.isHidden = true
      updateButton.isHidden = true
      
      sugarAfterStackView.isHidden = false

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
    configurateSugarBeforeStackView()
    configurateSugarAfterStackView()
    
    let allStackView = UIStackView(arrangedSubviews: [
    sugarBeforeStackView,
    correctSugarByCarboStackView,mealObjectStackView,correctSugarByInsulinStackView,
    sugarAfterStackView
    
    ])
    allStackView.distribution = .equalSpacing

    
    
     
     let stackView = UIStackView(arrangedSubviews: [
       deleteButton,allStackView,updateButton
     ])
    
    stackView.distribution = .equalSpacing

    
     addSubview(stackView)
     stackView.fillSuperview()
  }
  
  private func configurateSugarBeforeStackView() {
    sugarBeforeStackView = UIStackView(arrangedSubviews: [
    
    sugarBeforeButton,sugarBeforeLabel,
    
    ])
    sugarBeforeStackView.distribution = .fillEqually
    sugarBeforeStackView.spacing      = 3
  }
  
  private func configurateSugarAfterStackView() {
    sugarAfterStackView = UIStackView(arrangedSubviews: [
    
    sugarAfterButton,sugarAfterLabel,
    
    ])
    sugarAfterStackView.distribution = .fillEqually
    sugarAfterStackView.spacing      = 3
    
    sugarAfterStackView.isHidden = true
  }
  
  private func configureCorrectSugarByInsulinStackView()  {
    
    correctSugarByInsulinStackView = UIStackView(arrangedSubviews: [
    
    injectionResultButton,injectionResultLabel,
    
    ])
    correctSugarByInsulinStackView.distribution = .fillEqually
    correctSugarByInsulinStackView.spacing      = 3
    
    
  }
  private func configureMealObjectStackView() {
    
    mealObjectStackView = UIStackView(arrangedSubviews: [
    
    carboMealResultButton,carboInMealLabel
    ])
    mealObjectStackView.distribution = .fillEqually
    mealObjectStackView.spacing      = 3
    

    
    
    
  }
  private func configureCorrectSugarByCarboStackView()  {
    correctSugarByCarboStackView = UIStackView(arrangedSubviews: [
      
    sugarCorrectByCarboButton,carboCorrectionLabel,
      
    ])
    correctSugarByCarboStackView.distribution = .fillEqually
    correctSugarByCarboStackView.spacing = 3
    
    
  }
}
