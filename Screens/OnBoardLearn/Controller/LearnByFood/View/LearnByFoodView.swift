//
//  LearnByFoodView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Итак сделаю просто 5 строк с текстфилдами и свитчем буду эти данные переключать если надо

class LearnByFoodView: UIView {
  
  
  var insulinTitle: UILabel = {
    let label = UILabel()
    label.text = "Инсулин"
    
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func createDataRow(image: UIImage,name:String,carbo:String) -> UIStackView {
    
    let nameLabel = UILabel()
    nameLabel.text = name
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    
    let carboLabel = UILabel()
    nameLabel.text = carbo
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    
    let verticalStack = UIStackView(arrangedSubviews: [
    nameLabel,
    carboLabel
    ])
    verticalStack.axis = .vertical
    verticalStack.spacing = 5
    
    
    let imageVIew = UIImageView(image: image)
    imageVIew.contentMode = .scaleAspectFit
    
    let horizontalStackView = UIStackView(arrangedSubviews: [
    imageVIew,verticalStack
    ])
    horizontalStackView.spacing = 10
    
    return horizontalStackView

    
  }
  
  
  
}
