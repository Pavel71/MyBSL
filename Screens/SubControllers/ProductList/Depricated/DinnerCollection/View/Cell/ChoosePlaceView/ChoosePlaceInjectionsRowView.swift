//
//  ChoosePlaceInjectionsRowView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ChoosePlaceInjectionsRowView: UIView {
  
//  let placeInJectionsLabel = CustomLabels(font: UIFont.systemFont(ofSize: 18), text: "Место укола:")
  
  let chooseButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleChoosePlace), for: .touchUpInside)
    button.backgroundColor = Constants.Color.darKBlueBackgroundColor
    button.layer.cornerRadius = Constants.cornerRadiusForButtonAndTextField
    button.setTitle("Выберете ...", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  let plaсeImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "dot-and-circle").withRenderingMode(.alwaysTemplate))
    iv.tintColor = .white
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    placeInJectionsLabel.numberOfLines = 0
    
    let stackView = UIStackView(arrangedSubviews: [
      plaсeImageView,chooseButton
      ])
    stackView.distribution = .fillEqually
    addSubview(stackView)
    stackView.fillSuperview()
    
    
  }
  
  var didTapChoosePlaceInjections: EmptyClouser?
  @objc private func handleChoosePlace() {
    didTapChoosePlaceInjections!()
  
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
