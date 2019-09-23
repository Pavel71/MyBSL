//
//  FoodTableViewHeader.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class FoodTableViewHeader: UIView {
  
  static let headerSize: CGRect = .init(x: 0, y: 0, width: 0, height: 50)
  
  var items: [String] = []
  
  lazy var segmentController: UISegmentedControl = {
    let sg = UISegmentedControl(items: items) // ["Все продукты","Избранное", "Обеды"]
    sg.selectedSegmentIndex = 0

    sg.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    
    sg.backgroundColor = .clear
    sg.tintColor = .clear
    
    sg.setTitleTextAttributes([
      NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 20),
      NSAttributedString.Key.foregroundColor: UIColor.lightGray
      ], for: .normal)
    
    sg.setTitleTextAttributes([
      NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 20),
      NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.0592937693, green: 0.4987372756, blue: 0.822627306, alpha: 1)
      ], for: .selected)
    
    return sg
  }()
  

  
  let barStackView = UIStackView(arrangedSubviews: [])
  let deSelectedBarColor = UIColor(white: 0, alpha: 0.0)
  let selectedBarColor = #colorLiteral(red: 0.0592937693, green: 0.4987372756, blue: 0.822627306, alpha: 1)
  
  init(frame: CGRect, setSegments: [String]) {
    self.items = setSegments
    super.init(frame: frame)

    let verticalStackView = UIStackView(arrangedSubviews: [
      segmentController,
      barStackView
      ])
    
    barStackView.constrainHeight(constant: 3)
    
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fill

    addSubview(verticalStackView)
    verticalStackView.fillSuperview()
    
    fillBarStackView()

    
  }
  
  private func fillBarStackView() {

    for _ in 1...segmentController.numberOfSegments {
      let barView = UIView()
      barView.backgroundColor = deSelectedBarColor
      barView.layer.cornerRadius = 2
      
      barStackView.addArrangedSubview(barView)
    }
    barStackView.distribution = .fillEqually
    barStackView.arrangedSubviews.first?.backgroundColor = #colorLiteral(red: 0.0592937693, green: 0.4987372756, blue: 0.822627306, alpha: 1)
  }
  
  var didSegmentValueChange: ((UISegmentedControl) -> Void)?
  @objc private func handleSegmentChange(segmentController: UISegmentedControl) {
    
//    barStackView.arrangedSubviews.forEach { $0.backgroundColor = deSelectedBarColor }
    
    guard let segment = Segment(rawValue: segmentController.selectedSegmentIndex) else {return}
    
    if segment != .meals {
      UIView.animate(withDuration: 0.2) {
        self.barStackView.arrangedSubviews.forEach { $0.backgroundColor = self.deSelectedBarColor }
        self.barStackView.arrangedSubviews[segmentController.selectedSegmentIndex].backgroundColor = self.selectedBarColor
      }
    }
    
    didSegmentValueChange!(segmentController)
    
   
  }
  
 
  
  override var intrinsicContentSize: CGSize {
    return UIView.layoutFittingExpandedSize
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
