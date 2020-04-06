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
  
  static func getSugarCellHeight(cellState: SugarCellState) -> CGFloat {
   
       let cellHeight: CGFloat
   
       switch cellState {
       case .currentLayer:
         cellHeight = SugarCellHeightWorker.getDefaultHeight()
       case .currentLayerAndCorrectionLabel:
         cellHeight = SugarCellHeightWorker.getCurrentSugarLayerAndComapnsationLayerHeight()
//        SugarCellHeightWorker.getCurrentSugarLayerAndCOrrectionLabelHeight()
       case .currentLayerAndCorrectionLayer:
         cellHeight = SugarCellHeightWorker.getCurrentSugarLayerAndComapnsationLayerHeight()
       }
   
       return cellHeight
     }
  
  private static func getDefaultHeight() -> CGFloat {
    
    
    return valueHeight + titleHeight + (spacing * 4) + padding.top + padding.bottom
  }
  
  private static func getCurrentSugarLayerAndCOrrectionLabelHeight() -> CGFloat {
    
    return getDefaultHeight() + spacing + compansationTitleHeight
  }
  
  private static func getCurrentSugarLayerAndComapnsationLayerHeight() -> CGFloat {
    
    return getCurrentSugarLayerAndCOrrectionLabelHeight() + valueHeight
  }
  
  
   
  
}
