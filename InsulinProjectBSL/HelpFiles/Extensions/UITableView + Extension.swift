//
//  UITableView + Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 04/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

extension IndexPath {
  static fileprivate func fromRow(_ row: Int,_ section: Int) -> IndexPath {
    return IndexPath(row: row, section: section)
  }
}

extension UITableView {
  func applyChanges(deletions: [Int], insertions: [Int], updates: [Int],section: Int) {
    beginUpdates()

    let deletIndex = deletions.map { (del) in
      return IndexPath.fromRow(del,section)
    }
    let insertIndex = insertions.map { (insert) in
      return IndexPath.fromRow(insert,section)
    }
    let updateIndex = updates.map { (update) in
      return IndexPath.fromRow(update,section)
    }
//    deleteRows(at: deletions.map(IndexPath.fromRow($0,section)), with: .automatic)
//    insertRows(at: insertions.map(IndexPath.fromRow($0,section)), with: .automatic)
//    reloadRows(at: updates.map(IndexPath.fromRow($0,section)), with: .automatic)
    
    deleteRows(at: deletIndex, with: .automatic)
    insertRows(at: insertIndex, with: .automatic)
    reloadRows(at: updateIndex, with: .automatic)
    endUpdates()
  }
}
