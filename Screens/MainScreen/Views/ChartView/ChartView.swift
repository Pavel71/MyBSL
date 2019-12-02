//
//  ChurtView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ChartView: UIView {
  
  // Возможно тут будут еще какие-нибудь модули
  
  // Сделаю все через UIView Controlelr и все буду работать через него
  
  let chartVC = ChartViewController()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(chartVC.view)
    chartVC.view.fillSuperview()
    
    backgroundColor = .red
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
