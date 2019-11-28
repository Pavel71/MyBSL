//
//  DinnerTableViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealProductsVC: UIViewController {
  
  
  let tableView = UITableView(frame: .zero, style: .plain)
  var footerView = MealProductsFooterView()
  
  
  var products: [MealProductViewModel] = [] {
    didSet {tableView.reloadData()}
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpViews()
  }

}


// MARK: Set View Model

extension MealProductsVC {
  
  func setViewModel(viewModel: MealProductsVCViewModel) {
    products = viewModel.cells
    footerView.setViewModel(viewModel: viewModel.resultVM)
    // Здесь также нужна модель резалт вью
  }
}

// MARK: Set UP Views

extension MealProductsVC {
  
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
    tableView.register(MealProductCell.self, forCellReuseIdentifier: MealProductCell.cellId)
    tableView.keyboardDismissMode = .interactive
    tableView.allowsSelection = false
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 30
    
//    tableView.tableFooterView = footerView

    
  }
  

  
}

// MARK: TableView DataSource

extension MealProductsVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MealProductCell.cellId, for: indexPath) as! MealProductCell
    cell.setViewModel(viewModel: products[indexPath.row])
    return cell
  }
  
  
}

// MARK: TableView Header And Footer

extension MealProductsVC {
  
  // Header
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MealProductsHeaderInSection()
    return header
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 36
  }
  
  // Footer
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footerView
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return Constants.ProductList.TableFooterView.footerHeight
  }
  
}


// MARK: TableView Delegate

extension MealProductsVC: UITableViewDelegate {
  
  
}

