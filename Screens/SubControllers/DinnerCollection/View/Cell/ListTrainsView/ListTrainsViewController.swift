//
//  ListTrainsView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Set Up In MainViewController!


class ListTrainsViewController: UITableViewController {
  
  
  var tableViewData: [String] = ["Бассейн","Бокс"]
  
  // Clousers
  var didSelectCell: ((String) -> Void)?
  
  override init(style: UITableView.Style) {
    super.init(style: style)

    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    view.backgroundColor = .white
    view.alpha = 0

    
  }
  
  
  
  func addNewTrain(train: String) {
    
    if !tableViewData.contains(train) && !train.isEmpty {
      tableViewData.append(train)
      tableView.reloadData()
    }
    
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: TableView Delegate DataSource

extension ListTrainsViewController {
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    cell.textLabel?.text = tableViewData[indexPath.row]
    return cell
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let trainName = tableViewData[indexPath.row]
    didSelectCell!(trainName)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch  editingStyle {
    case .delete:
      tableViewData.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    default:break
      
    }
  }
}
