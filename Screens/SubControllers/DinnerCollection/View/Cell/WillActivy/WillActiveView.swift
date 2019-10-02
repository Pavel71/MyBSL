//
//  WillActiveView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class WillActiveView: UIView {
  
  
  let activityImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "running").withRenderingMode(.alwaysTemplate))
    iv.tintColor = .white
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
  let activityTitle = CustomLabels(font: UIFont.systemFont(ofSize: 17), text: "Физическая нагрузка:")
  
  let activeOn: UISwitch = {
    let st = UISwitch()
    st.tintColor = Constants.Color.lightBlueBackgroundColor
    st.onTintColor = Constants.Color.darKBlueBackgroundColor
    return st
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  
    activityTitle.numberOfLines = 0
    
    let vStackView = UIStackView(arrangedSubviews: [
      activityTitle,activityImageView
  
      ])
    
//    activityImageView.constrainHeight(constant: 30)
//    activityImageView.constrainWidth(constant: 30)
    
    
    
    let containerView = UIView()
    containerView.addSubview(activeOn)
    activeOn.centerInSuperview()

    let overStackView = UIStackView(arrangedSubviews: [
      activityTitle,activityImageView,containerView
      ])

    overStackView.distribution = .fillEqually
    
    
    addSubview(overStackView)
    overStackView.fillSuperview()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
