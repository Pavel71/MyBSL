//
//  CalculateDistance.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//



// Класс отвечает за рсчет расстояние между MainController и MenuController

import UIKit


class CalculateDistance {
  
  
  static func calculateDistanceMealCellToMenuController(cellY: CGFloat) -> CGFloat {
  
    let middelScreenHeight = UIScreen.main.bounds.height / 2
    
    var currentDistance: CGFloat
    
    if middelScreenHeight > cellY {
      currentDistance = middelScreenHeight - cellY - Constants.HeaderInSection.heightForHeaderInSection - Constants.ProductList.marginCell.top * 2
    } else {
      currentDistance = (cellY - middelScreenHeight + Constants.HeaderInSection.heightForHeaderInSection + Constants.ProductList.marginCell.top * 2) * -1
    }
    
    return currentDistance
  }
  
}
