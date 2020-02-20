//
//  ResultsList.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 20.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



class ResultsListViewController: UITableViewController {
  
  
//  var viewModel: ResultsListVM
  
  init() {
    super.init(style: .plain)
    
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.isUserInteractionEnabled = false
    
//    tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
