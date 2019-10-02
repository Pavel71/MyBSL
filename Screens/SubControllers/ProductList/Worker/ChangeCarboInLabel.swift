//
//  ChangeCarboInLabel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class ComputedValueThanChangeOne {

  static func changeCarboInlabel(tableView: UITableView, carboOn100Grm: Int,portion: Int,indexPath:IndexPath) -> String {
    

    let carboInPortion: Int = CalculateValueTextField.calculateCarboInPortion(carboIn100grm: carboOn100Grm, portionSize: portion)
    
    let carbo = changeCarboInCell(indexPath: indexPath, carboInPortion: carboInPortion, tableView: tableView)
    return carbo
  }
  
  
  private static func changeCarboInCell(indexPath: IndexPath, carboInPortion: Int,tableView: UITableView) -> String {
    
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell
    cell.carboInPortionLabel.text = String(carboInPortion)
    return String(carboInPortion)
  }
  
  
  static func getIndexPathIntableViewForTextFiedl(textField: UITextField, tableView: UITableView) -> IndexPath? {
    
    let point = tableView.convert(textField.center, from: textField.superview)
    guard let indexPath = tableView.indexPathForRow(at: point) else {return nil}
    
    return indexPath
  }
  
}
