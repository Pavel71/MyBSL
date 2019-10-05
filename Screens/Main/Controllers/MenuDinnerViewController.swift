//
//  MenuDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Сейчас идея выпукивать контроолер из первой ячейки и увеличивать ее размер!


class MenuDinnerViewController: UIViewController {
  
  
  let swipeMenuButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "up-arrow").withRenderingMode(.alwaysTemplate), for: .normal)
    button.addTarget(self, action: #selector(handleSwipeMenuBack), for: .touchUpInside)
    
    return button
  }()
  
  
  // clousers
  
  var didTapSwipeMenuBackButton: EmptyClouser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setUpSwipeMenuBackButton()
    
  }
  
  private func setUpSwipeMenuBackButton() {
    view.addSubview(swipeMenuButton)
    swipeMenuButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .zero,size: .init(width: 0, height: 30))
    
  }
  
  // MARK: Swipe Menu Back
  
  @objc private func handleSwipeMenuBack() {
    didTapSwipeMenuBackButton!()
  }
  
  
}
