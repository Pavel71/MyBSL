//
//  AddNewProductView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//



import UIKit

// Вообщем надо подумать как организовать эту работу на новой архитектуре


protocol NewProductViewModelable {
  
  var listCategory: [String] {get}
  
  var name: String? {get}
  var carbo: String? {get}
  var category: String? {get}
  var massa: String? {get}
  var isFavorits: Bool {get}
}


class NewProductView: AddNewElementView {
  
  var foodValidator = FoodValidator()

  static let sizeView : CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 260)
  
  // Labels
  
  
  
  let nameLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Наименование:")
  let carboLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Углеводы на 100гр.:")
  let categoryLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Категория:")
  let massaLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "Масса продукта гр.:")
  let isFavoritLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "В избранном:")
//  let titleLabel = CustomLabels(font: .systemFont(ofSize: 18, weight: .heavy), text: "Введите данные пожалуйста!")
  
  // TextFields
  lazy var nameTextField = createTextField(padding: 5, placeholder: "Яблоко",cornerRaduis: 10)
  lazy var carboTextField = createTextField(padding: 5, placeholder: "11",cornerRaduis: 10)

  lazy var massaTextField = createTextField(padding: 5, placeholder: "150",cornerRaduis: 10)
  
  lazy var categoryWithButtonTextFiled: CustomCategoryTextField = {
    let textField = CustomCategoryTextField(padding: 5, placeholder: "Фрукты",cornerRaduis: 10)
    textField.addTarget(self, action: #selector(textDidChanged(textField:)), for: .editingChanged)
    textField.delegate = self
    return textField
  }()
  
  func createTextField(padding: CGFloat, placeholder: String,cornerRaduis: CGFloat) -> CustomTextField {
    let textField = CustomTextField(padding: padding, placeholder: placeholder,cornerRaduis: cornerRaduis)
    textField.addTarget(self, action: #selector(textDidChanged(textField:)), for: .editingChanged)
    textField.delegate = self
    return textField
  }
  
  
  // Switch
  
  
  
  let switchSegmentController: UISegmentedControl = {
    let sg = UISegmentedControl(items: ["Убрать","Добавить"])
    sg.selectedSegmentIndex = 0
    sg.tintColor = .white
    sg.layer.cornerRadius = 10
    sg.clipsToBounds = true
    sg.layer.borderWidth = 1
    sg.layer.borderColor = UIColor.white.cgColor
    sg.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    return sg
  }()
  

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    print("init new Food View ")
    
    carboTextField.keyboardType = .numberPad
    massaTextField.keyboardType = .numberPad
    titleLabel.textAlignment = .center
    

    // Labels
    
    let labelsStackView = UIStackView(arrangedSubviews: [
      nameLabel,
      categoryLabel,
      carboLabel,
      isFavoritLabel,
      massaLabel
      ])
    nameLabel.constrainWidth(constant: 120)
    labelsStackView.distribution = .fillEqually
    labelsStackView.axis = .vertical
    labelsStackView.spacing = 2
    
    
    // TextFields
    
    
    let textFieldsStackView = UIStackView(arrangedSubviews: [
      nameTextField,
      categoryWithButtonTextFiled,
      carboTextField,
      switchSegmentController,
      massaTextField
      ])
    textFieldsStackView.distribution = .fillEqually
    textFieldsStackView.axis = .vertical
    textFieldsStackView.spacing = 2
    
    
    // Buttons
    
    let buttonsStackView = UIStackView(arrangedSubviews: [
      cancelButton,
      okButton
      ])
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = 2
    
    
    let horizontalStackView =  UIStackView(arrangedSubviews: [
      labelsStackView, textFieldsStackView
      ])
    horizontalStackView.distribution = .fill
    horizontalStackView.spacing = 5
    
    let verticalStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      horizontalStackView,
      buttonsStackView
      ])
    
    titleLabel.constrainWidth(constant: NewProductView.sizeView.width)
    titleLabel.constrainHeight(constant: 30)
    buttonsStackView.constrainHeight(constant: 50)
    
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fill
    verticalStackView.spacing = 5
    addSubview(verticalStackView)
    verticalStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))

    setTitleSegmentController()
    hiddenMassaStackView(isHidden: true)
    
  }
  

  

  


  
  // MARK: Set Get View Model
  func set(viewModel: NewProductViewModelable) {

    // Если хотя бы имя добавленно ! то и остальные параметры тоже утсановленны!
    guard let name = viewModel.name else {return}
    nameTextField.text = name
    categoryWithButtonTextFiled.text = viewModel.category!
    
    switchSegmentController.selectedSegmentIndex = viewModel.isFavorits ? 1 : 0
    setTitleSegmentController()
    hiddenMassaStackView(isHidden: !viewModel.isFavorits)
    
    carboTextField.text = viewModel.carbo!
    massaTextField.text = viewModel.massa!
    
    foodValidator.setFieldsFromViewModel(viewModel: viewModel)
    
  }
  
  func getViewModel() -> FoodCellViewModel {
    
    let massa: String = foodValidator.isFavorit ? foodValidator.massa! : "100"
//    let massaInt = Int(massa)
//    let carboInt = Int(foodValidator.carbo!)!

    return FoodViewModel.Cell.init(id: nil, name: foodValidator.name!, category: foodValidator.category!, isFavorit: foodValidator.isFavorit, carbo: foodValidator.carbo!, portion: massa)
    
  }
  
  // MARK: Set CategoryFrom PickerView
  
  func setCategory(category: String) {
    categoryWithButtonTextFiled.text = category
    foodValidator.category = category
  }
  
  
  // MARK: Favorits
  

  
  private func setAnimateSegmentView() {
    
    layoutIfNeeded()
    
    UIView.transition(with: switchSegmentController, duration: 0.2, options: .transitionFlipFromRight, animations: {
      self.setTitleSegmentController()
    }) { (_) in
      
      UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
        self.hiddenMassaStackView(isHidden: self.switchSegmentController.selectedSegmentIndex == 0)
      }, completion: nil)
      
      self.layoutIfNeeded()
    }
    
  }
  
  private func setTitleSegmentController() {

    if self.switchSegmentController.selectedSegmentIndex == 0 {
      
      self.switchSegmentController.setTitle("", forSegmentAt: 1)
      self.switchSegmentController.setTitle("Убрать", forSegmentAt: 0)
      
    } else {
      
      self.switchSegmentController.setTitle("", forSegmentAt: 0)
      self.switchSegmentController.setTitle("Добавить", forSegmentAt: 1)
    }
  }
  

  
  // Segment Controller
  @objc func didChangeSegment(segment: UISegmentedControl) {
    foodValidator.isFavorit = segment.selectedSegmentIndex == 1
    setAnimateSegmentView()
  }

  // Add Button
  var didTapSaveButton: ((String?,FoodCellViewModel) -> Void)?
  override func handleSaveButton() {
    
    // Нужно собрать данные из этой View! и передать их котнроллеру
    foodValidator.checkCarboAndMassa()
    let viewModel = getViewModel()
    
    didTapSaveButton!(foodValidator.alertString, viewModel)
  }

  
  // Clear Fields
  
  func clearAllFieldsInView() {
    
    nameTextField.text      = ""
    carboTextField.text     = ""
    categoryWithButtonTextFiled.text  = ""
    massaTextField.text     = ""
    
    // Анимация не нужна
    switchSegmentController.selectedSegmentIndex = 0
    setTitleSegmentController()
    hiddenMassaStackView(isHidden: true)
    
    
    foodValidator.setDefault()
  }
  

  
  // MARK: Text Did Change
  
  
  @objc private func  textDidChanged(textField: UITextField) {
    
    guard let text = textField.text else {return}
    // Передаем в модельку данные
    switch textField {
      
    case nameTextField:
      foodValidator.name = text
    case carboTextField:
      foodValidator.carbo = text
    case categoryWithButtonTextFiled:
      foodValidator.category = text
      
    case massaTextField:
      foodValidator.massa = text
      
    default: break
    }
    
    
    
  }
  

  

  
  func hiddenMassaStackView(isHidden: Bool) {
    
    self.massaTextField.isHidden = isHidden
    self.massaLabel.isHidden = isHidden
  
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var newProductViewTextFieldBegintEditing: EmptyClouser?
}

// MARK: UiTextField Delegate
extension NewProductView {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    newProductViewTextFieldBegintEditing!()

  }
}
