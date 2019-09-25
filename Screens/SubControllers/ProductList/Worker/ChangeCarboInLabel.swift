//
//  ChangeCarboInLabel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class ChangeCarboInlabel {

  static func changeCarboInlabel(tableView: UITableView, carboOn100Grm: Int,portion: Int,indexPath:IndexPath) {
    

    let carboInPortion: Int = Calculator.calculateCarboInPortion(carboIn100grm: carboOn100Grm, portionSize: portion)
    
    changeCarboInCell(indexPath: indexPath, carboInPortion: carboInPortion, tableView: tableView)
  }
  
  
  private static func changeCarboInCell(indexPath: IndexPath, carboInPortion: Int,tableView: UITableView) {
    
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell
    cell.carboInPortionLabel.text = String(carboInPortion)
  }
  
  
  static func getIndexPathIntableViewForTextFiedl(textField: UITextField, tableView: UITableView) -> IndexPath? {
    
    let point = tableView.convert(textField.center, from: textField.superview)
    guard let indexPath = tableView.indexPathForRow(at: point) else {return nil}
    
    return indexPath
  }
  
}
