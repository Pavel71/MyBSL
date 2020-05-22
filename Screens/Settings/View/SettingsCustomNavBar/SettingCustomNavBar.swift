//
//  SettingCustomNavBar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



final class SettingCustomNavBar: UIView {
  
  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  
  // MARK: Outlets
  
  var logOutButton : UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Log out", for: .normal)
    b.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
    return b
  }()
  
  var fetchAllFromFireStoreButton : UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Fetch All From FireStore", for: .normal)
    b.addTarget(self, action: #selector(handlefetchAll), for: .touchUpInside)
    return b
  }()
  
  
  // MARK: Clousers
  
  var didTapLogOutButton: EmptyClouser?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: Signals
  
  @objc private func handleLogOut() {
    didTapLogOutButton!()
  }
  
  @objc private func handlefetchAll() {
    print("Fetch All")
    
    let locator = ServiceLocator.shared
    
    let fetchService: FetchService! = locator.getService()
    
//    fetchService.getRealmDataFromFireStore()
  }
  


 override func draw(_ rect: CGRect) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset  = .init(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 2
    
  }

}

// MARK: Set Up Views

extension SettingCustomNavBar {
  
  func setUpViews() {
    
    
    
    let stackView = UIStackView(arrangedSubviews: [
    UIView(),fetchAllFromFireStoreButton,logOutButton
    ])
    stackView.distribution = .equalCentering
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    
  }
  
}
