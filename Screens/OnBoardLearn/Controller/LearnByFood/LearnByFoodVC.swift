//
//  LearnByFoodVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit




class LearnByFoodVC: UITableViewController,PagesViewControllerable {
  
  var didIsNextButtonValid: ((Bool) -> Void)?
  var nextButtonIsValid: Bool = false {
    didSet {didIsNextButtonValid!(nextButtonIsValid)}
  }
  
  
  var viewModel:LearnByFoodVM!
  var tableViewData: [LearnByFoodModel] =  []
  
  
  init(didIsNextButtonValid:@escaping ((Bool) -> Void),viewModel: LearnByFoodVM) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.didIsNextButtonValid = didIsNextButtonValid
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    configureTableView()
    
    configureViewModel()
  }
  
  private func configureViewModel() {
   tableViewData = viewModel.tableData
    viewModel.didUpdateValidForm = {[weak self] isValid in
      self?.nextButtonIsValid = isValid
    }
  }
  
  private func configureTableView() {
    
    // Тут нужен высота статус бара и навигатони бара
    let topPadding    =  UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
//    let bottomPadding = self.tabBarController!.tabBar.frame.size.height
    tableView.contentInset = .init(top: topPadding, left: 0, bottom: 0, right: 0)
    // Без скроллинга
    tableView.allowsSelection      = false
    tableView.isScrollEnabled      = false
    tableView.keyboardDismissMode  = .interactive
    tableView.tableFooterView      = UIView()
    registerCell()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  private func registerCell() {
    
    tableView.register(LearnByFoodCell.self, forCellReuseIdentifier: LearnByFoodCell.cellID)
  }
  
}


// MARK: TableView Deleagate DataSource

extension LearnByFoodVC {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: LearnByFoodCell.cellID, for: indexPath) as! LearnByFoodCell
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row])
    setCellClouser(cell: cell)
    return cell
  }
  
  private func setCellClouser(cell:LearnByFoodCell) {
    
    cell.passInsulinValue = {[weak self] insulin in
      guard let index = self?.tableView.indexPath(for: cell)!.row else {return}
      self?.viewModel.addInsulinInObject(insulinValue: insulin, index: index)
    }
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    let topPadding    =  UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!

    return (tableView.frame.height - topPadding) / CGFloat(tableViewData.count)
  }
}
