//
//  SettingCustomNavBar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



final class StatsNavBar: UIView {
  
  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  
  // MARK: Outlets
  
  var title : UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    label.text = "Статистика"
    return label
  }()
  

  
  // MARK: Clousers
  

  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: Signals


 override func draw(_ rect: CGRect) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset  = .init(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 2
    
  }

}


// MARK: Set View Model
extension StatsNavBar {
  
//  func configureNavBar(useEmail: String) {
//    self.title.text = useEmail
//  }
}

// MARK: Set Up Views

extension StatsNavBar {
  
  func setUpViews() {
    
    
    
    let stackView = UIStackView(arrangedSubviews: [
    UIView(),title,UIView()
    ])
    stackView.distribution = .equalCentering
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    
  }
  
}
