//
//  SugarLevelView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



// Класс отвечает за слайдер с помощью которого можно будет выбрать оптимальный уровень сахара


//protocol SugarLevelVewModable {
//  var lowerSliderValue  : Double {get set}
//  var higherSliderValue : Double {get set}
//}



class SugarLevelView: UIView {
  

  
  let rangeSliderContentView = UIView()
  
  var titleLabel: UILabel = {
    let tv = UILabel()
    tv.font          = UIFont.systemFont(ofSize: 16)
    tv.text          = "Выберите пожалуйста диапозон желаемого уровеня сахара в крови в mlmol!"
    tv.textAlignment = .center
    tv.numberOfLines = 0
    return tv
  }()
  
  var lowerLabel: UILabel = {
    let l           = UILabel()
    l.font          = UIFont.systemFont(ofSize: 16)
    l.textAlignment = .center
    l.text          = "4.5"
    return l
  }()
  
  var higherLabel: UILabel = {
    let l           = UILabel()
    l.font          = UIFont.systemFont(ofSize: 16)
    l.textAlignment = .center
    l.text          = "7.5"
    return l
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set View Model

extension  SugarLevelView {
  
  func setViewModel(viewModel:SugarLevelModel) {
    lowerLabel.text  = "\(viewModel.sugarLowerLevel)"
    higherLabel.text = "\(viewModel.sugarHigherLevel)"
  }
  
}

// MARK: Set Up Views

extension  SugarLevelView {
  
  private func setUpViews() {
    
    let hStack = UIStackView(arrangedSubviews: [
    lowerLabel,higherLabel
    ])
    hStack.spacing = 5
    hStack.distribution = .fillEqually
   
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      hStack,
      rangeSliderContentView
    ])
    

    stackView.axis         = .vertical
    stackView.spacing      = 5
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
  
  
}
