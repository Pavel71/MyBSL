//
//  MainMenuProductListViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class MainMenuProductListViewController: BaseProductList {
  
//  var mealId: String = ""
  var tableViewData: [ProductListViewModel] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    configureFooterResultsView()
  }

}



// MARK: Set UPViews

extension MainMenuProductListViewController {
  
  private func configureFooterResultsView() {
    
    footerView.resultsView.setTextColor(color: .white)
  }
  
  private func configureTableView() {
    
    tableView.backgroundColor = .clear
    
    tableView.register(MainMenuProductListCell.self, forCellReuseIdentifier: MainMenuProductListCell.cellId)
    tableView.dataSource = self
  }
}

// MARK: Set View Models
extension MainMenuProductListViewController {
  // View Models
  
  func setViewModel(viewModel: ProductListInMealViewModel) {
    
    tableViewData = viewModel.productsData
    
    setResultViewModel()
  }
  
  private func setResultViewModel() {
    
    let productListResultViewModel = ConfirmProductListResultViewModel.calculateProductListResultViewModel(data: tableViewData)
    
    footerView.resultsView.setViewModel(viewModel: productListResultViewModel,withInsulin: false)
    
    tableView.reloadData()
  }
}

extension MainMenuProductListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MainMenuProductListCell.cellId, for: indexPath) as! MainMenuProductListCell
    
    let viewModel = tableViewData[indexPath.row]
    cell.setViewModel(viewModel: viewModel)
    return cell
  }


  
}

// MARK: Set Header
extension MainMenuProductListViewController {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = ProductListHeaderInSection(withInsulinLabel: false,temaColor: .white)
    // Если продуктов нет то скрой хеадер
    header.isHidden = tableViewData.isEmpty
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.ProductList.headerInSectionHeight
  }
}
