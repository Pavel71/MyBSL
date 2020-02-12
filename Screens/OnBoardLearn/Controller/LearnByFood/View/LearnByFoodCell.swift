//
//  LearnByFoodCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



protocol LearnVyFoodCellable {
  
  var name    : String {get set}
  var carbo   : Double {get set}
  var portion : Double {get set}
  var image   : UIImage {get set}
  var insulin : Double? {get set}
}


class LearnByFoodCell: UITableViewCell {
  
  static let cellID  = "LearnByFoodCellID"
  
  
  
  var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()
  
  var portionLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.systemFont(ofSize: 12)
     label.numberOfLines = 0
     return label
   }()
  
  var carboLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.systemFont(ofSize: 12)
     label.numberOfLines = 0
     return label
   }()
  
  var productImageView: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  var insulinTextField: UITextField = {
    let tx = UITextField()
    tx.placeholder = "0.0"
    tx.textColor   = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    return tx
  }()
  
  
  var insulinPickerView = InsulinPickerView()

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpViews()
    
    
   configureInsulinTextField()
  }
  
  private func configureInsulinTextField() {
    
    
    insulinTextField.inputView = insulinPickerView
    insulinTextField.addDoneButtonOnKeyboard()
    // Значение которое приходит с pickerView
    
    insulinPickerView.passValueFromPickerView = {[weak self] value in
      self?.insulinTextField.text = "\(value)"
      // Здесь же мне нужно прокинуть данные дальше куда надо!
    }
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set UP Views

extension LearnByFoodCell {
  
  private func setUpViews() {
    
    let verticalStack = UIStackView(arrangedSubviews: [
      nameLabel,
      portionLabel,
      carboLabel
    ])
    verticalStack.axis = .vertical
    verticalStack.spacing = 5
    verticalStack.distribution = .fill
    
    
    
    let horizontalStackView = UIStackView(arrangedSubviews: [
      productImageView,verticalStack,insulinTextField
    ])
    productImageView.constrainWidth(constant: 100)
    insulinTextField.constrainWidth(constant: 60)
    
    horizontalStackView.spacing = 10
    horizontalStackView.distribution = .fill
    
    addSubview(horizontalStackView)
    horizontalStackView.fillSuperview(padding: .init(top: 10, left: 5, bottom: 10, right: 0))
    
  }
}

// MARK: Set ViewModel

extension LearnByFoodCell {
  func setViewModel(viewModel: LearnVyFoodCellable) {
    
    
    let carboValueString = "\(viewModel.carbo)"
    let attributedWithTextColor: NSAttributedString = "Углеводов: \(carboValueString) гр.".attributedStringWithColor([carboValueString], color: UIColor.red)

    carboLabel.attributedText = attributedWithTextColor

    nameLabel.text          = viewModel.name
    portionLabel.text       = "Порция: \(viewModel.portion) гр."
    productImageView.image  = viewModel.image
    
    
  }
}



