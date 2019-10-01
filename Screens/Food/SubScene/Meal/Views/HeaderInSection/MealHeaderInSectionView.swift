//
//  MealHeaderInSectionView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 30/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealHeaderinSectionView: UIView {
  
  
  
  private let headerButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleHeaderSectionButton), for: .touchUpInside)
    return button
  }()
  
  let sectionName: UILabel = {
    let label = UILabel()    
    label.numberOfLines = 0
    return label
  }()
  
  private let rightLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.attributedText = NSAttributedString(string: "Порция в гр.", attributes: [
      NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 20),
      NSAttributedString.Key.foregroundColor: UIColor.lightGray  // UIColor.lightGray
      ])
    label.alpha = 0
    label.textAlignment = .right
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    let stackView = UIStackView(arrangedSubviews: [
      sectionName,
      rightLabel
      ])
    rightLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true

    
    stackView.distribution = .fill
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    
    addSubview(headerButton)
    headerButton.fillSuperview()
    
  }
  
  func setData(name: String, section: Int) {
    sectionName.attributedText = NSAttributedString(string: name,
      attributes: [
      NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 20),
      NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.0592937693, green: 0.4987372756, blue: 0.822627306, alpha: 1)
      ])
    headerButton.tag = section
  }
  
  var didTapHeaderSectionButton: ((UIButton,UILabel,UILabel) -> Void)?
  @objc private func handleHeaderSectionButton(sender: UIButton) {
    didTapHeaderSectionButton!(sender,rightLabel, sectionName)
  }
  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
