//
//  SwipeView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class SwipeView: UIView {
  
  let swipeMenuButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "up-arrow").withRenderingMode(.alwaysTemplate), for: .normal)    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(swipeMenuButton)
    swipeMenuButton.fillSuperview()
    
  }


  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
