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
  var footerView = MealProductsFooterView(frame: .init(x: 0, y: 0, width: 0, height: Constants.ProductList.TableFooterView.footerHeight))
  
  
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
    
    footerView.setViewModel(viewModel: viewModel.resultVM)
    products = viewModel.cells

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
    
    let headerView = MealProductsHeaderInSection()
    headerView.backgroundColor = .white
    
    let stackView = UIStackView(arrangedSubviews: [
    headerView,
    tableView
    ])
    headerView.constrainHeight(constant: 36)
    stackView.axis = .vertical
    
    
    view.addSubview(stackView)
    stackView.fillSuperview()
    
//    view.addSubview(tableView)
//    tableView.fillSuperview()
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
    
    tableView.tableFooterView = footerView

    
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
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let header = MealProductsHeaderInSection()
//    return header
//  }
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 36
//  }
  
  // Footer
  
//  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//    return footerView
//  }
//
//  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//    return Constants.ProductList.TableFooterView.footerHeight
//  }
  
}


// MARK: TableView Delegate

extension MealProductsVC: UITableViewDelegate {
  
  
}

