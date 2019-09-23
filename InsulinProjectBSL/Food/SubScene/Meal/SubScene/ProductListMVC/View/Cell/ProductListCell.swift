//
//  ProductsInMealCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 02/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol ProductViewModelCell {
  var name: String {get}
  var portion: String {get}
  var carboInPortion: String {get}
}

class ProductListCell: UITableViewCell {
  
  static let cellID = "Product Cell"
  
  
  let chooseImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "circumference").withRenderingMode(.alwaysTemplate))
   
    iv.sizeToFit()
    iv.isHidden = true
    return iv
  }()
  
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 20)
    label.textColor = .lightGray
    label.numberOfLines = 0
    return label
  }()
  
  let portionTextField: UITextField = {
    let textField = UITextField()
    textField.font = UIFont(name: "DINCondensed-Bold", size: 18)
    textField.textColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
//    textField.keyboardType = .numberPad

    textField.textAlignment = .right
    return textField
  }()
  
  let carboInPortionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 18)
    label.textColor = .lightGray
    label.textAlignment = .left
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    portionTextField.keyboardType = .numberPad
    portionTextField.returnKeyType = .done
//    portionTextField.clearButtonMode  = .whileEditing
    
    let stackView = UIStackView(arrangedSubviews: [
      nameLabel,carboInPortionLabel,portionTextField
      ])

    carboInPortionLabel.constrainWidth(constant: 50)
    portionTextField.constrainWidth(constant: 50)
    
    stackView.distribution = .fill
    stackView.spacing = 5
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.Meal.ProductCell.margin)
    
    addDoneButtonOnKeyboard()
  }
  
  func addDoneButtonOnKeyboard(){
    
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(self.doneButtonAction))
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    portionTextField.inputAccessoryView = doneToolbar
  }
  
  @objc func doneButtonAction(){
    portionTextField.resignFirstResponder()
    // Сработает делегат и все будет норм!
    print("Tap Done Button")
  }
  
  
  func setViewModel(viewModel: ProductViewModelCell, withChooseButton: Bool = false) {
    
    nameLabel.text = viewModel.name
    portionTextField.text = viewModel.portion
    carboInPortionLabel.text = viewModel.carboInPortion
    
//    chooseImageView.isHidden = !withChooseButton

  }
  

  

  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


