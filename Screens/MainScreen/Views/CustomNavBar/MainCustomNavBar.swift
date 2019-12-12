//
//  MainCustomNavBar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//
import UIKit

class MainCustomNavBar: UIView {
  
  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  
  
  let titleLabel: UILabel = {
    
    let label = UILabel()
    label.text = "Главный экран"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()
  
  let addNewDinnerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
    button.addTarget(self, action: #selector(handleAddNewDinner), for: .touchUpInside)
    return button
  }()
  
  let robotButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "robot32").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleRobotMenu), for: .touchUpInside)
    return button
  }()
  
  // Clousers
  
  var didTapAddNewDataClouser : EmptyClouser?
  var didTapRobotMenuClouser  : EmptyClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    backgroundColor = .white
    setUpTitleLabel()
    
  }
  
  private func setUpTitleLabel() {
    
    let stackView = UIStackView(arrangedSubviews: [
    robotButton, titleLabel , addNewDinnerButton
    ])
    
    
    stackView.distribution = .equalCentering
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
  
  // Add New Dinner
  @objc private func handleAddNewDinner() {
    print("Add new Dinner")
    didTapAddNewDataClouser!()
  }
  
  // Robot
  @objc private func handleRobotMenu() {
    print("Hi iam a robot!")
    didTapRobotMenuClouser!()
  }
  
 
  
  
  override func draw(_ rect: CGRect) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset  = .init(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 2
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
