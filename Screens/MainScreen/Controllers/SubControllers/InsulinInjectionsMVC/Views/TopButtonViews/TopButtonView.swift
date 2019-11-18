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

class TopButtonView: UIView {

  lazy var deleteDinnerButton: UIButton = createButton(image: #imageLiteral(resourceName: "cancel"))
//  lazy var checkStatusDinnerButton: UIButton = createButton(image: #imageLiteral(resourceName: "info"))
  lazy var updateDinnerButton: UIButton = createButton(image: #imageLiteral(resourceName: "tools"))
  lazy var injectionResultDinnerButton: UIButton = createButton(image: #imageLiteral(resourceName: "anesthesia"))
  
  
  func createButton(image: UIImage) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
    return button
  }
  
  
  // Injections Stack
  
//  let injectionImageView: UIImageView = {
//    let iv = UIImageView(image: #imageLiteral(resourceName: "anesthesia").withRenderingMode(.alwaysTemplate))
//    iv.tintColor = .white
//    iv.contentMode = .scaleAspectFit
//    iv.clipsToBounds = true
//    return iv
//  }()
  let injectionResultLabel = CustomLabels(font: .systemFont(ofSize: 16), text: "6.0")
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpViews()
    
  }
  
  @objc private func handleButtonAction(button: UIButton) {
    
    switch button {
    case deleteDinnerButton:
      print("Delete Clouser")
    case updateDinnerButton:
      print("Update Clouser")
    case injectionResultDinnerButton:
      print("Show Short Stat by Injections")

    default:break
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up Views

extension TopButtonView {
  
  private func setUpViews() {
    
    let injectionStackView = UIStackView(arrangedSubviews: [
    injectionResultDinnerButton,injectionResultLabel
    ])
    injectionStackView.distribution = .fillEqually
    injectionStackView.spacing = 10
    
     
     let stackView = UIStackView(arrangedSubviews: [
       deleteDinnerButton,injectionStackView,updateDinnerButton
     ])
    
    stackView.distribution = .equalCentering
     
     addSubview(stackView)
     stackView.fillSuperview()
  }
}
