//
//  Array+ Extensions.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation

extension Array {
  
  
  func split() -> (Element,Element) {
    return (self[0],self[1])
  }
  
  
  
}

extension Array where Element: AdditiveArithmetic {
  
  mutating func setZeroValue() {
    self.insert(Element.zero, at: 0)
  }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
