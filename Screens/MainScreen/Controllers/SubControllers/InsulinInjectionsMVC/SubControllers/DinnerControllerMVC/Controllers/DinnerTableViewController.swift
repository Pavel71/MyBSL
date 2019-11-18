//
//  DinnerTableViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class DinnerTableViewController: UIViewController {
  
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpViews()
  }

}


// MARK: Set UP Views

extension DinnerTableViewController {
  
  private func setUpViews() {
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    setUpTableView()
  }
  
  private func setUpTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    configureTableView()
    
  }

  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(DinnerCell.self, forCellReuseIdentifier: DinnerCell.cellId)
    tableView.keyboardDismissMode = .interactive
    tableView.allowsSelection = false
    
    
    
  }
  

  
}

// MARK: TableView DataSource

extension DinnerTableViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DinnerCell.cellId, for: indexPath) as! DinnerCell
    cell.nameLabel.text = "Яблоко"
    cell.carboInPortionLabel.text = "11"
    cell.portionLabel.text = "100"
    cell.insulinLabel.text = "1.0"
    return cell
  }
  
  
}


// MARK: TableView Delegate

extension DinnerTableViewController: UITableViewDelegate {
  
  
  
  
}

