//
//  NewMealView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 10/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol NewMealViewModelable {

  var mealId: String? {get}
  var name: String? {get}
  var typeOfMeal: String? {get}

}


class NewMealView: AddNewElementView {
  
  static let size: CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 230)
  
  var mealValidator = MealValidator()
  
  var mealId: String?
  
  
  
  // Name Meal
  let nameLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Наименование:")
  
  lazy var nameTextField = createTextField(padding: 5, placeholder: "Яблоко",cornerRaduis: 10, selector: #selector(textFieldDidChange))
  
  var nameTextView: UITextView = {
    let tv = UITextView()
    tv.font = UIFont.systemFont(ofSize: 16)
    tv.clipsToBounds = true
    tv.layer.cornerRadius = 10
    return tv
  }()
  
  // Type Meal
  let typeMealLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Тип обеда:")
  
  lazy var categoryWithButtonTextFiled: CustomCategoryTextField = {
    let textField = CustomCategoryTextField(padding: 5, placeholder: "Завтраки",cornerRaduis: 10)
    textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    textField.delegate = self
    return textField
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    nameTextView.delegate = self
    
    let firstStack = UIStackView(arrangedSubviews: [
      nameLabel, nameTextView
      ])
    nameLabel.constrainWidth(constant: 120)
    nameTextView.constrainHeight(constant: 80)
    firstStack.distribution = .fill
    
    let secondStackView = UIStackView(arrangedSubviews: [
      typeMealLabel,categoryWithButtonTextFiled
      ])
    secondStackView.distribution = .fill
    typeMealLabel.constrainWidth(constant: 120)
    

    
    
    let buttonsStackView = UIStackView(arrangedSubviews: [
      cancelButton,
      okButton
      
      ])
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = 2
    
    let verticalStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      firstStack,
      secondStackView,
      buttonsStackView
      ])
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fill
    verticalStackView.spacing = 5
    

    titleLabel.constrainHeight(constant: 30)
    buttonsStackView.constrainHeight(constant: 50)
    
    addSubview(verticalStackView)
    verticalStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    
  }
  
  // MARK: SOme Functions
  
  func setViewModel(viewModel: NewMealViewModelable) {
    
//    nameTextField.text                 = viewModel.name
    
    nameTextView.text                  = viewModel.name
    categoryWithButtonTextFiled.text  = viewModel.typeOfMeal
    mealValidator.setFieldsFromViewModel(viewModel: viewModel)
    // Если пришел id Meal  
    guard let mealID = viewModel.mealId else {return}
    mealId = mealID
  }
  
  func clearAllFieldsInView() {
    
//    nameTextField.text                 = ""
    nameTextView.text                  = ""
    categoryWithButtonTextFiled.text  = ""
    self.mealId = nil
    mealValidator.setDefault()
  }
  
  func getViewModel() -> MealViewModel {

    return MealViewModel.init(isExpand: true, name: mealValidator.name!, typeMeal: mealValidator.typeOfMeal!, products: [], mealId: self.mealId)
    
  }
  
  func setCategory(typeOfMeal: String) {
    categoryWithButtonTextFiled.text = typeOfMeal
    mealValidator.typeOfMeal = typeOfMeal
  }
  
  // MARK: Handle Some Buttons in View
  

//  var didTapSaveMealClouser: EmptyClouser?
//  override func handleSaveButton() {
//    didTapSaveMealClouser!()
//    
//  }
//  
//  var didTapCancelButtonClouser: EmptyClouser?
//  override func handleCancelButton() {
//    didTapCancelButtonClouser!()
//  }
  
  @objc private func textFieldDidChange(textField: UITextField) {
    
    switch textField {
      
//      case nameTextField:
//        mealValidator.name = nameTextField.text
      case categoryWithButtonTextFiled:
        mealValidator.typeOfMeal = categoryWithButtonTextFiled.text
      
    default: break
    }
    
  }
  
//  var didTapShowTypeOfMealsClouser: EmptyClouser?
//  @objc private func handleShowListCategoryButton() {
//    didTapShowTypeOfMealsClouser!()
//    
//  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

extension NewMealView: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    guard let text = textView.text else {return}
    mealValidator.name = text
  }
}


