//
//  MainCustomNavBar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//
import UIKit

class MainCustomNavBar: UIView {
  
  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  
  
  let titleLabel: UILabel = {
    
    let label = UILabel()
    label.text = "Главный экран"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    backgroundColor = .white
    setUpTitleLabel()
    
  }
  
  private func setUpTitleLabel() {
    addSubview(titleLabel)
    titleLabel.fillSuperview(padding: .init(top: 0, left: 0, bottom: 10, right: 0))
  }
  
 
  
  
  override func draw(_ rect: CGRect) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset  = .init(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 2
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
