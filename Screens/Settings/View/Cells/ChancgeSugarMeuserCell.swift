//
//  ChancgeSugarMeuserCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 16.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


protocol ChangeSugarMeuserCellable  {
  var metrics : SugarMetric {get set}
}

class ChancgeSugarMeuserCell : UITableViewCell {
  
  
  var metrics: SugarMetric = .mgdl
  
  var didMetrticsChange : ((SugarMetric) -> Void)?

  
  let metricTitle : UILabel = {
    let label = UILabel()
    label.text = "mmol/ml (4.5-7.5)"
    label.numberOfLines = 0
    label.sizeToFit()
    return label
  }()
  
   var switcher: UISwitch = {
     let switcher = UISwitch()
     switcher.isOn               = false
     switcher.tintColor          = .red
     switcher.backgroundColor    = .red
     switcher.layer.cornerRadius = 16
     
     return switcher
   }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    switcher.addTarget(self, action: #selector(handleSwitcher), for: .valueChanged)
    setViews()
  }
  
  
  func configureCell(viewModel: ChangeSugarMeuserCellable) {
    self.metrics = viewModel.metrics
    setMetricsTitle()
  }
  
  @objc private func handleSwitcher(switcher:UISwitch ) {
    print("Switch Sugar Meusers")
    self.metrics = switcher.isOn ? .mgdl :  .mmoll
    setMetricsTitle()
    didMetrticsChange!(metrics)
  }
  
  private func setMetricsTitle() {
    self.metricTitle.fadeTransition(0.25)
    self.metricTitle.text = self.metrics.rawValue
  }
  
 
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Views
extension ChancgeSugarMeuserCell {
  
  private func setViews() {
    
     let hsStack = UIStackView(arrangedSubviews: [
     metricTitle,switcher
     ])
//    
    switcher.constrainWidth(constant: 50)

    
    hsStack.axis = .horizontal
    hsStack.distribution = .fill
    
    
    addSubview(hsStack)
    hsStack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
   }
  
}
