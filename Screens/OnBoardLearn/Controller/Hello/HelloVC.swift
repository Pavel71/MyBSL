//
//  HelloVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Итак нужно запилить Эти классы приветсвия и тд и получить данные от пользователя!








class HelloVC: UIViewController,PagesViewControllerable {
  var didIsNextButtonValid: ((Bool) -> Void)?
  var nextButtonIsValid: Bool = false
  
  
  
  var helloLabel: UILabel = {
    let label = UILabel()
    label.text = "Привет! Меня зовут МаркТурбо! \n Я помогу тебе с расчетом дозировок инсулина! \n Только сперва тебе нужно менять обучить! "
    label.numberOfLines = 0
    label.textAlignment = .center
    
    return label
  }()
  
  
  var markTurboImage: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "ROBOT"))
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
//  var nextButton: UIButton = {
//
//    let button = UIButton(type: .system)
//    button.setTitle("Дальше", for: .normal)
//    button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
//    return button
//  }()
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    
  }
  
//  @objc private func nextPage() {
//    print("Пролистать Page")
//
////    let parentController = super
//  }
  
}

// MARK: SetUpView

extension HelloVC {
  
  private func setUpView() {
    
    let vstack = UIStackView(arrangedSubviews: [
    markTurboImage,
    helloLabel
    ])
    vstack.axis = .vertical
    vstack.spacing = 20
    vstack.constrainWidth(constant: UIScreen.main.bounds.width - 20)
    
    view.addSubview(vstack)
    vstack.centerInSuperview()
    
  }
}
