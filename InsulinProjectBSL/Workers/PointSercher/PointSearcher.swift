//
//  PointSearcher.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 10.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class PointSearcher {
  
  static func getIndexPathTableViewByViewInCell(tableView: UITableView,view: UIView) -> IndexPath? {
    let point = tableView.convert(view.center, from: view.superview)
    guard let indexPath = tableView.indexPathForRow(at: point) else {return nil}
    return indexPath
  }
  
}
