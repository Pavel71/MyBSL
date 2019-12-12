//
//  CompObjScreenNavBar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class CompObjScreenNavBar: UIView {
  
  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  
  // Buttons
  var backButtonCLouser: EmptyClouser?
  
  let backButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "left-arrow").withRenderingMode(.alwaysTemplate), for: .normal)
    button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    setUpViews()
  }
  
  
  
  override func draw(_ rect: CGRect) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset  = .init(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 2
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Handle Signals
extension CompObjScreenNavBar {
  
  @objc private func handleBack() {
    print("Dismiss VC")
    backButtonCLouser!()
  }
  
}

// MARK: Set Up Views
extension CompObjScreenNavBar {
  
  private func setUpViews() {
    
    addSubview(backButton)
    backButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 5, left: 10, bottom: 5, right: 0))
    
  }
  
}
