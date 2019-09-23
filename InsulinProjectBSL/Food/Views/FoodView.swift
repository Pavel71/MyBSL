//
//  FoodView.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class FoodView: UIView {
  
  
  var customNavBar = CustomNavBar(frame: CustomNavBar.sizeBar, withBackButton: false)
  let tableView = UITableView(frame: .zero, style: .plain)
  let headerTableView = FoodTableViewHeader(frame:FoodTableViewHeader.headerSize,setSegments: ["Все продукты","Избранное", "Обеды"])
  
  let newProductView = NewProductView(frame: NewProductView.sizeView)
  
  let pickerView = UIPickerView()
  
  var blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    return blurView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    setUpCustomNavBar()
    setUpTableView()
    setUpBlurEffect()
    setUpNewProductView()
    setUpPickerView()
  }
  
  private func setUpCustomNavBar() {
    addSubview(customNavBar)
    customNavBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
  }
  
  private func setUpBlurEffect() {
    addSubview(blurView)
    blurView.fillSuperview()

    blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnBlur)))
  }
  
  @objc private func didTapOnBlur() {

    pickerView.isHidden = true
    self.endEditing(true)
  }
  
  private func setUpNewProductView() {

    addSubview(newProductView)
    newProductView.centerInSuperview()

    // Убираем вправый угол!
    newProductView.hideViewOnTheRightCorner()
  }
  
  private func setUpTableView() {
    
    addSubview(tableView)
    tableView.anchor(top: customNavBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: Constants.tableViewTopPadding, left: 0, bottom: 0, right: 0))
//    tableView.layoutMargins.top = Constants.tableViewTopPadding
    
    tableView.keyboardDismissMode = .interactive
    tableView.tableHeaderView = headerTableView
    
  }
  
  private func setUpPickerView() {
    
    addSubview(pickerView)
    pickerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .zero,size: .init(width: 0, height: 140))
    pickerView.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
