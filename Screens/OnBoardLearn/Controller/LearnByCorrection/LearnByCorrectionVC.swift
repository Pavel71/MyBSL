//
//  LearnByCorrectionVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Итак задача Экрана собрать данные как пользователь собирается корректировать высокие сахара!

class LearnByCorrectionVC: UIViewController {
  
  
  var tableView = UITableView(frame: .zero, style: .plain)
  var tableData: [LearnByCorrectionModal] = LearnByCorrectionModal.getTestData()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpViews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
}

// MARK: Set Up Views

extension LearnByCorrectionVC {
  
  private func setUpViews() {
    
    configureTableView()
    
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    
  }
  
  private func configureTableView() {
    
    tableView.delegate   = self
    tableView.dataSource = self
    
    tableView.tableFooterView = UIView()
    tableView.separatorStyle  = .none
    
    tableView.register(LearnByCorrectionSugarCell.self, forCellReuseIdentifier: LearnByCorrectionSugarCell.cellID)
  }
  
}

// MARK: TableView Delegate DataSource
extension LearnByCorrectionVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LearnByCorrectionSugarCell.cellID, for: indexPath) as! LearnByCorrectionSugarCell
    cell.setViewModel(viewModel: tableData[indexPath.row])
    return cell
  }
  
  
}
