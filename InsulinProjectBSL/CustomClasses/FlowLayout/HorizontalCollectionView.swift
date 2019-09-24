//
//  HorizontalCollectionView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {
  
  
  init() {
    let layout = BetterSnapingLayout()
    layout.scrollDirection = .horizontal
    
    super.init(collectionViewLayout: layout)
    collectionView.decelerationRate = .fast
    collectionView.backgroundColor = .white
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
