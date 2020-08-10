//
//  StackTestView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 31.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

class TestView : UIView {
  
  var topView : UIView = {
     let v = UIView()
     v.translatesAutoresizingMaskIntoConstraints = false
     v.heightAnchor.constraint(equalToConstant: 300).isActive = true
     v.backgroundColor = .purple
     return v
   }()
   
   var middleView : UIView = {
     let v = UIView()
     v.translatesAutoresizingMaskIntoConstraints = false
     v.heightAnchor.constraint(equalToConstant: 200).isActive = true
     v.backgroundColor = .yellow
     return v
   }()
   
   var bottomView : UIView = {
     let v = UIView()
     v.translatesAutoresizingMaskIntoConstraints = false
     v.heightAnchor.constraint(equalToConstant: 400).isActive = true
     v.backgroundColor = .green
     return v
   }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let vStack = StackTestView()
    addSubview(vStack)
    vStack.fillSuperview()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



class StackTestView : UIStackView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    axis = .vertical
    distribution = .fill
    spacing = 5
    
    [topView,middleView,bottomView].forEach(addArrangedSubview(_:))
    
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var topView : UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.heightAnchor.constraint(equalToConstant: 300).isActive = true
    v.backgroundColor = .purple
    return v
  }()
  
  var middleView : UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.heightAnchor.constraint(equalToConstant: 200).isActive = true
    v.backgroundColor = .yellow
    return v
  }()
  
  var bottomView : UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.heightAnchor.constraint(equalToConstant: 400).isActive = true
    v.backgroundColor = .green
    return v
  }()
}
