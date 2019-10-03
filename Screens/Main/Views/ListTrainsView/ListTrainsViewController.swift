//
//  ListTrainsView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ListTrainsViewController: UITableViewController {
  
  
  var tableViewData: [String] = ["Бассейн","Бокс"]
  
  override init(style: UITableView.Style) {
    super.init(style: style)
    
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    cell.textLabel?.text = tableViewData[indexPath.row]
    return cell
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Select Row")
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    print("Delete Row")
    
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch  editingStyle {
    case .delete:
      print("Delete")
    default:break
      
    }
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

