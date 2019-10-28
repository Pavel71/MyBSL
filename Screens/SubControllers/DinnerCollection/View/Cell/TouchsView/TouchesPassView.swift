//
//  TouchesPassView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 27/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Класс дает фидбек если мы щелкаем на его view то получаем nil если на subView то ловим subView
class TouchesPassView: UIView {
  
  
  var didHitTestProductListViewControllerClouser: ((Bool) -> Void)?
  
  override func hitTest(_ point: CGPoint,with event: UIEvent?) -> UIView? {
    
    let view = super.hitTest(point, with: event)

    
    if view === self {
      print("Hit Touches View")
      didHitTestProductListViewControllerClouser!(true)
      return nil
    }

    didHitTestProductListViewControllerClouser!(false)
    return view
    
    
  }
}
