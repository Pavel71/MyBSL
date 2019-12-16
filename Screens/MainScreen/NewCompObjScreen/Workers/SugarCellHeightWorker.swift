//
//  SugarCellHeightWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 16.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Класс отвечает за расчет высоты ячейки в зависимости от условий

class SugarCellHeightWorker {
  
  // Properties
  
  static let spacing                 : CGFloat = 5
  static let valueHeight             : CGFloat = 30
  static let titleHeight             : CGFloat = 20
  static let compansationTitleHeight : CGFloat = 40
  
  static let padding     : UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
  
  // Func
  
  // MARK: Get Default Height
  
  static func getDefaultHeight() -> CGFloat {
    
    
    return valueHeight + titleHeight + (spacing * 4) + padding.top + padding.bottom
  }
  
  static func getCurrentSugarLayerAndCOrrectionLabelHeight() -> CGFloat {
    
    return getDefaultHeight() + spacing + compansationTitleHeight
  }
  
  static func getCurrentSugarLayerAndComapnsationLayerHeight() -> CGFloat {
    
    return getCurrentSugarLayerAndCOrrectionLabelHeight() + valueHeight 
  }
  
}
