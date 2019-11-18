//
//  MainScreenMiddleView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class MainScreenMiddleView: UIView {
  
  
  let collectionViewController = InsulinInjectionsCollectionViewController()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(collectionViewController.view)
    collectionViewController.view.fillSuperview()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
