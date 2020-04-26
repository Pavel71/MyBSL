//
//  Bindable.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation




class Bindable<T> {
  
  var value: T? {
    didSet {
      observer?(value)
    }
  }
  
  var observer: ((T?) -> Void)?
  
  func bind(observer: @escaping ((T?) -> Void)) {
    
    self.observer = observer
  }
}
