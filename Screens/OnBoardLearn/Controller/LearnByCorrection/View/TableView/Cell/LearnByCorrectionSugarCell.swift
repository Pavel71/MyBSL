//
//  LearnByCorrectionSugarCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


protocol LearnByCorrectionSugarCellable {
  var sugar             : Double {get set}
  var correctionInsulin : Double? {get set}
  
}


class LearnByCorrectionSugarCell: UITableViewCell {
  
  static let cellID = "LearnByCorrectionSugarCell"
  
  
  
  var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  var insulinTextField: UITextField = {
     let tx = UITextField()
     tx.placeholder   = "0.0"
     tx.textColor     = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
     tx.textAlignment = .center
    return tx
   }()
   
   
   var insulinPickerView = InsulinPickerView()
  var passInsulinTextField: ((UITextField) -> Void)?
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    insulinTextField.delegate = self
    
    setUpViews()
    
    configureInsulinTextField()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: SetUp Views
extension LearnByCorrectionSugarCell {
  
  private func setUpViews() {
    
    let stackView = UIStackView(arrangedSubviews: [
    
      nameLabel,insulinTextField
    ])
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
  }
  
  
  private func configureInsulinTextField() {
     
     
     insulinTextField.inputView = insulinPickerView
     insulinTextField.addDoneButtonOnKeyboard()
     // Значение которое приходит с pickerView
     
     insulinPickerView.passValueFromPickerView = {[weak self] value in
       self?.insulinTextField.text = "\(value)"
       // Здесь же мне нужно прокинуть данные дальше куда надо!
      self?.passInsulinTextField!(self!.insulinTextField)
     }
  }
}

// MARK: Set View Models
extension LearnByCorrectionSugarCell {
  
  func setViewModel(viewModel:LearnByCorrectionSugarCellable ) {
    
    
    nameLabel.text = "\(viewModel.sugar)"    
    
  }
}
// MARK: Text Fiedl Delegate
extension LearnByCorrectionSugarCell: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    passInsulinTextField!(textField)
  }
  
}

