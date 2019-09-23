//
//  CustomNavBar.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//


import UIKit

class CustomNavBar: UIView {

  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  static let headerId = "HeaderId"
  
  
  let backButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
    button.isHidden = true
    return button
  }()
  
  let addButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "add"), for: .normal)
    
    return b
  }()
  
  let sortButtonByType: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "order"), for: .normal)
    button.addTarget(self, action: #selector(handleTapChangeSectionButton), for: .touchUpInside)
    return button
  }()
  
  let searchBar: UISearchBar = {
    let sB = UISearchBar()
    sB.searchBarStyle  = .minimal
    sB.placeholder = "Поиск..."
    sB.sizeToFit()
    sB.isTranslucent = false
    
    
    return sB
  }()
  
  
  init(frame: CGRect, withBackButton: Bool) {
    super.init(frame: frame)
    
    
    backgroundColor = .white
    
    let rightButtonStackView = UIStackView(arrangedSubviews: [
      sortButtonByType,
      addButton
      
      ])
    rightButtonStackView.distribution = .fillEqually
    rightButtonStackView.spacing = 5
    
    addSubview(rightButtonStackView)
    rightButtonStackView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5))


    addSubview(backButton)
    backButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
    
    let searchBarLeadingAnchor =  withBackButton ? backButton.trailingAnchor : leadingAnchor
    backButton.isHidden = !withBackButton
    
    addSubview(searchBar)
    searchBar.anchor(top: topAnchor, leading: searchBarLeadingAnchor, bottom: bottomAnchor, trailing: rightButtonStackView.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5))
    
  }
  
  var isDefaultSectionView = true
  
  var didTapChangeSectionViewButton: (() -> Void)?

  @objc private func handleTapChangeSectionButton() {

    isDefaultSectionView = !isDefaultSectionView
    changeImageSortButton(isSortList: isDefaultSectionView)

    didTapChangeSectionViewButton!()
  }
  
  func changeImageSortButton(isSortList: Bool) {
    
    let imageSort = isSortList ? #imageLiteral(resourceName: "order")  : #imageLiteral(resourceName: "list")
    UIView.transition(with: sortButtonByType, duration: 0.2, options: [.transitionCrossDissolve], animations: {
      self.sortButtonByType.setImage(imageSort, for: .normal)
    }, completion: nil)
    
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

