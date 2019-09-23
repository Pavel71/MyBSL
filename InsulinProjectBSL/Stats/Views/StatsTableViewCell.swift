//
//  StatsTableViewCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 02/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
  
  static let cellID = "statsCellID"
  
  

  private let headerTableVIew: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  var mealCellViewModel: MealDummy! {
    didSet {
      headerTableVIew.text = mealCellViewModel.name
      tableViewData = mealCellViewModel.products
      expanded(isExpand: mealCellViewModel.isExpand)
    }
  }
  
  private var tableViewData:[ProductDummy] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    print("reload cell")
    
    addSubview(headerTableVIew)
    headerTableVIew.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    headerTableVIew.constrainHeight(constant: 50)
    
  }
  
  private func setUpTableView() {
    addSubview(tableView)
    tableView.anchor(top: headerTableVIew.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    
    // Высота tableView в зависимости от кол-ва обедов
    
    let tableVIewHeight = Constants.Meal.heightRowMealTableViewCell * CGFloat(tableViewData.count)
    tableView.constrainHeight(constant: tableVIewHeight)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "someCell")
    
    tableView.tableFooterView = UIView()
    
  }
  
  private func removeTableVIew() {
    tableView.removeFromSuperview()
  }
  
  private func expanded(isExpand: Bool) {
     isExpand ? self.setUpTableView() : self.removeTableVIew()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

extension StatsTableViewCell: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "someCell", for: indexPath)
    cell.textLabel?.text = tableViewData[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    print("cell in meal")
  }
  

}
