//
//  LearnByCorrectionVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// 1. Нужно добавить хедер с описанием какие у нас поля
// 2. Нужно добавить свитчер чтобы переключить моли в граммы
// 3. Добавить знак вопроса и показать алерт снова!
// 4. Добавить viewmodel и сделать функцию валидации по заполнению полей инсулина

class LearnByCorrectionVC: UIViewController,PagesViewControllerable {
  
  var didIsNextButtonValid: ((Bool) -> Void)?

  var nextButtonIsValid: Bool = false {
    
    didSet {
      didIsNextButtonValid!(nextButtonIsValid)
    }
    
  }
  
  
  
  var tableView = UITableView(frame: .zero, style: .plain)
  var tableData: [LearnByCorrectionModal] = []
  var viewModel: LearnByCorrectionVM!
  
  init(didIsNextButtonValid:@escaping ((Bool) -> Void),viewModel: LearnByCorrectionVM) {
    super.init(nibName: nil, bundle: nil)
    
    self.viewModel = viewModel
    self.didIsNextButtonValid = didIsNextButtonValid
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    configureVM()
    setUpViews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
}

//MARK: Configure VM

extension  LearnByCorrectionVC {
  private func configureVM() {
    tableData = viewModel.tableData
    viewModel.didUpdateValidForm = {[weak self] isValid in
      self?.nextButtonIsValid = isValid
      
    }
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
    
    tableView.tableHeaderView = LearnByCorrectionHeader(frame: .init(x: 0, y: 0, width: 0, height: 50))
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
    setCellClouser(cell: cell)
    
    return cell
  }
  
  private func setCellClouser(cell: LearnByCorrectionSugarCell) {
    
    cell.passInsulinValue = {[weak self] insulin in
      
      guard let index = self?.tableView.indexPath(for: cell)!.row else {return}
      
      self?.viewModel.addInsulinInObject(insulinValue: insulin, index: index)
    }
    
  }
  
  
  
  
  
}
