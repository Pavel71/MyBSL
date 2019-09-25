//
//  ViewForHeaderInSection.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//



import UIKit

class ViewForHeaderInSection: UIView {
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Наименование:"
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .left
    return label
  }()
  
  let carboLabel: UILabel = {
    let label = UILabel()
    label.text = "Углеводы на 100гр."
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.textAlignment = .right
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.8352028728, green: 0.835346818, blue: 0.8351936936, alpha: 1)
    
    let stackView = UIStackView(arrangedSubviews: [
      nameLabel,
      carboLabel
      ])
    carboLabel.constrainWidth(constant: 100)
    stackView.distribution = .fill
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 0, left: 10, bottom: 0, right: 10))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
