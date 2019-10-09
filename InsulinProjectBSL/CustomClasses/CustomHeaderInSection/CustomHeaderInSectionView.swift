//
//  CustomHeaderInSectionView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 03/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



enum Expand {

  case expanded
  case closed
  
  var switchValue: Expand {
    switch self {
    case .expanded: return .closed
    case .closed: return .expanded
    }
  }
}

class CustomHeaderInSectionView: UIView {

  var currentExpand: Expand = .expanded {
    
    didSet {
      
      switch currentExpand {
        
      case .closed:
        carboOn100Label.alpha = 0
        sectionNameLabel.textColor = .white
        
      case .expanded:
        carboOn100Label.alpha = 1
        sectionNameLabel.textColor = .lightGray

      }
    }
  }
  
  private let headerButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleHeaderSectionButton), for: .touchUpInside)
    
    return button
  }()
  
  let sectionNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "DINCondensed-Bold", size: 22)
    label.numberOfLines = 0
    
    return label
  }()
  
  private let carboOn100Label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    
    label.font = UIFont(name: "DINCondensed-Bold", size: 18)
//    label.text = "Углеводы на 100гр."
    label.textColor = UIColor.lightGray

    label.alpha = 0
    label.textAlignment = .center
    return label
  }()
  
  private let portionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    
    label.font = UIFont(name: "DINCondensed-Bold", size: 18)
    label.text = "Порция"
    label.textColor = UIColor.lightGray
    
    label.alpha = 0
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    let backGroundContanerViwe = UIView()
    backGroundContanerViwe.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    backGroundContanerViwe.layer.cornerRadius = Constants.HeaderInSection.cornerRadius
    backGroundContanerViwe.clipsToBounds = true
    addSubview(backGroundContanerViwe)
    backGroundContanerViwe.fillSuperview(padding: .init(top: 3, left: 5, bottom: 5, right: 5))
    
    let rightStackView = UIStackView(arrangedSubviews: [
      UIView(),
      portionLabel,
      carboOn100Label
      ])

    rightStackView.distribution = .fillEqually
    rightStackView.spacing = 5
    
    
    let stackView = UIStackView(arrangedSubviews: [
      sectionNameLabel,
      rightStackView
      ])
    
    sectionNameLabel.constrainWidth(constant: Constants.Food.TableViewHeaderInSection.nameLabelWidth)
    stackView.distribution = .fill
    addSubview(stackView)
    stackView.fillSuperview(padding: Constants.cellMargin)
    
    addSubview(headerButton)
    headerButton.fillSuperview()
    
  }
  
  func setData(isExpanded: Bool, isOnlyOneSection: Bool, sectionName: String, rightLabelName: String? = nil, section: Int,isFavoritSegment: Bool = false) {
    
    // Если секция скрыта то только белый шрифт и скрытый лейбел, если нет то
    headerButton.tag = section
    sectionNameLabel.text = sectionName
    
    currentExpand = isExpanded ? .expanded : .closed
    
    headerButton.isEnabled = isOnlyOneSection // Отключаю активацию кнопки если мы в режиме лист
    guard let rightLabelName = rightLabelName else {return}
    carboOn100Label.text = rightLabelName
    portionLabel.alpha = isFavoritSegment ? 1:0

  }
  

  
  
  
  var didTapHeaderSectionButton: ((UIButton,Expand) -> Void)?
  
  @objc private func handleHeaderSectionButton(sender: UIButton) {
    
    didTapHeaderSectionButton!(sender,currentExpand)
    currentExpand = currentExpand.switchValue
    
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.cornerRadius = 10
    clipsToBounds = true
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
