//
//  TotalInsulinView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 29.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class TotalInsulinView: UIView {
  
  let totalInsulinImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "anesthesia").withRenderingMode(.alwaysTemplate))
    iv.tintColor = .white
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
  let totalInsulinLabel = CustomLabels(font: UIFont.systemFont(ofSize: 18), text: "0.0")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    totalInsulinLabel.textAlignment = .center
    
    let stackView = UIStackView(arrangedSubviews: [
    totalInsulinImageView,totalInsulinLabel
    ])
    stackView.spacing = 5
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.fillSuperview()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
