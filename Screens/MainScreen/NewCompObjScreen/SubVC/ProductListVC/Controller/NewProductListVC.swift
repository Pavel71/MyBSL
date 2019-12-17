//
//  NewProductListVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class NewProductListVC : BaseProductList {
  
  
  var tableData : [ProductListViewModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  override func setUpTableView() {
    
    super.setUpTableView()
    configureTableView()
    
    
  }
  
}

// MARK: Set Up ProductListViews

extension NewProductListVC {
  
  private func configureTableView() {
    
    tableView.tableHeaderView = headerView
    tableView.dataSource      = self
    tableView.register(NewProductListCell.self, forCellReuseIdentifier: NewProductListCell.cellId)
    tableView.keyboardDismissMode = .interactive
    
    tableView.tableFooterView = tableData.isEmpty ? UIView() : footerView
  }
}

// MARK: TableView DataSource
extension NewProductListVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: NewProductListCell.cellId, for: indexPath) as! NewProductListCell
    
    return cell
  }
  
  
}

// MARK: Header in Section
extension NewProductListVC {
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = ProductListHeaderInSection(withInsulinLabel: true,temaColor: .darkGray)
    // Если продуктов нет то скрой хеадер
    header.isHidden = tableData.isEmpty
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.ProductList.headerInSectionHeight
  }
  
}
