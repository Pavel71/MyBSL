//
//  MainTableViewFooterCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class MainTableViewFooterCell: UITableViewCell {
  
  static let cellId = "MainTableViewFooterCellId"
  
  let robotView = RobotView()
  
  let saveButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Сохранить", for: .normal)
    b.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    
    b.tintColor = UIColor.white
    b.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    return b
  }()
  
  let predicateinsulinButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Получить расчет", for: .normal)
    b.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    b.isEnabled = true
    b.tintColor = UIColor.white
    b.backgroundColor = .lightGray
    
    return b
  }()
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

    robotView.didChangeRobotImage = {[weak self] in
      self?.changeEnablePredictaButton()
    }

    self.didTapSaveButtonClouser = {[weak robotView] in
      robotView?.handleTap()
    }

    let buttonStackView = UIStackView(arrangedSubviews: [
      saveButton,
      predicateinsulinButton
      ])


    buttonStackView.axis = .vertical
    buttonStackView.distribution = .fillEqually
    buttonStackView.spacing = 10

    buttonStackView.isLayoutMarginsRelativeArrangement = true
    buttonStackView.layoutMargins = .init(top: 30, left: 10, bottom: 30, right: 10)


    let overAllStackView = UIStackView(arrangedSubviews: [
      robotView,buttonStackView

      ])

    overAllStackView.distribution = .fillEqually

    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    
  }
  
  var didTapSaveButtonClouser: (() -> Void)?
  @objc private func didTapSaveButton() {
    print("Did Tap Save Button")
    didTapSaveButtonClouser!()
  }
  
  private func changeEnablePredictaButton() {
    predicateinsulinButton.isEnabled = true
    predicateinsulinButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
  }
  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
