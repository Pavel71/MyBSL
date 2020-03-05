//
//  InjectionPlaceCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Ячейка отвечает за отображение места укола
// Пока сделаю просто кнопку по нажатию на которую у нас появится дополнительная View с выбором места укола
// Потом возможно обновлю дизайн!


protocol InjectionPlaceCellable {
  
  var cellState  : InjectionPlaceCellState {get set}
  var titlePlace : String {get set}
}


enum InjectionPlaceCellState {
  case hidden,showed
}

class InjectionPlaceCell: UITableViewCell {
  
  static let cellId = "InjectionPlaceCell"
  
  
  
  var chooseButton: UIButton = {
    let b = UIButton(type: .system)
    b.clipsToBounds      = true
    b.layer.cornerRadius = 10
    b.backgroundColor    = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    b.setTitle("Выбрать", for: .normal)
    b.setTitleColor(.white, for: .normal)
    return b
  }()
  
  var chooseTitle: UILabel = {
    let label           = UILabel()
    label.font          = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.text          = "Место укола:"
    label.textColor     = .white
    label.numberOfLines = 0
    return label
  }()
  
  // MARK: Clousers
  
  var didTapChooseButton: EmptyClouser?
  
  // MARK: Handle Signals Func
  @objc private func tapChooseButton() {
    didTapChooseButton!()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    chooseButton.addTarget(self, action: #selector(tapChooseButton), for: .touchUpInside)
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}




// MARK: Set Up Views
extension InjectionPlaceCell {
  
  private func setUpViews() {
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    let containerView = UIView()
    containerView.addSubview(chooseButton)
    chooseButton.fillSuperview(padding: .init(top: 20, left: 0, bottom: 20, right: 0))
    
    
    let stackView = UIStackView(arrangedSubviews: [
    chooseTitle,containerView
    ])
    stackView.spacing      = 10
    stackView.distribution = .fillEqually
    
    
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
  
}

// MARK: Ser View Models
extension InjectionPlaceCell {
  
  func setViewModel(viewModel: InjectionPlaceCellable) {
    
    let title = viewModel.titlePlace.isEmpty ? "---" : viewModel.titlePlace
    chooseButton.setTitle(title, for: .normal)
    
    self.isHidden = viewModel.cellState == .hidden
  }
  
}
