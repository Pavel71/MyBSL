//
//  MainTableViewFooterCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol MainTableViewFooterCellable {
  
  var totalInsulinValue: Float {get set}
}

class MainTableViewFooterCell: UITableViewCell {
  
  static let cellId = "MainTableViewFooterCellId"
  
  let robotView = RobotView()
  let totalView = TotalView()
  
  let saveButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Сохранить", for: .normal)
    b.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    
    b.tintColor = UIColor.white
    b.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    b.isEnabled = false
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

    self.didTapSaveButtonToRobotViewClouser = {[weak robotView] in
      robotView?.handleTap()
    }

    let buttonStackView = UIStackView(arrangedSubviews: [
      totalView,
      saveButton,
      predicateinsulinButton
      ])


    buttonStackView.axis = .vertical
    buttonStackView.distribution = .fillEqually
    buttonStackView.spacing = 8

    buttonStackView.isLayoutMarginsRelativeArrangement = true
    buttonStackView.layoutMargins = .init(top: 20, left: 10, bottom: 20, right: 10)


    let overAllStackView = UIStackView(arrangedSubviews: [
      robotView,buttonStackView

      ])

    overAllStackView.distribution = .fillEqually

    addSubview(overAllStackView)
    overAllStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    
  }
  
  func setViewModel(viewModel: MainTableViewFooterCellable) {
    totalView.totalInsulinValue.text = "\(viewModel.totalInsulinValue)"
  }
  
  var didTapSaveButtonClouser: (() -> Void)?
  var didTapSaveButtonToRobotViewClouser: (() -> Void)?
  @objc private func didTapSaveButton() {
    
    // Таким образом сохранение в реалм произойдет в паралельном потоке
    
    self.didTapSaveButtonClouser!()
    
    
    didTapSaveButtonToRobotViewClouser!()
    
  }
  
  private func changeEnablePredictaButton() {
    predicateinsulinButton.isEnabled = true
    predicateinsulinButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
  }
  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
