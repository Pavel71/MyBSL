//
//  ProductListCellWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Класс отвечает за расчет высоты ячейки!

class ProductListCellHeightWorker {
  
  static  let spacing                : CGFloat = 5
  static  let valueHeight            : CGFloat = 30
  static  let titleHeight            : CGFloat = 20
  static  let padding                : UIEdgeInsets = .init(top: 10, left: 10, bottom: 25, right: 10)
  
  static  let addButtonHeight        : CGFloat = 45
  static  let blankProductListHeight : CGFloat = 90
  
  static  let listProductRowHeight   : CGFloat = 34
}


extension ProductListCellHeightWorker {
  
  
  static func getAddmealCellHeight(cellState:AddMealCellState,productCount: Int) -> CGFloat {
    
    switch cellState {
      
    case .defaultState:
      return ProductListCellHeightWorker.getDefaultHeightCell()
      
    case .productListState:
      
      return ProductListCellHeightWorker.getWithProductListCellHeight(countProduct:productCount)
    }
    
    
  }
  
  
  private static func getDefaultHeightCell() -> CGFloat {
    return valueHeight + titleHeight + (spacing * 2) + padding.top + padding.bottom
  }
  
  
  private static func getWithProductListCellHeight(countProduct: Int) -> CGFloat {
    return getDefaultHeightCell() + blankProductListHeight + (listProductRowHeight * CGFloat(countProduct))
  }
}
