//
//  MainViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainDisplayLogic: class {
  func displayData(viewModel: Main.Model.ViewModel.ViewModelData)
}

class MainViewController: UIViewController, MainDisplayLogic {

  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic)?
  
  
  var mainView: MainView!
  var tableView: UITableView!

  // MARK: Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = MainInteractor()
    let presenter             = MainPresenter()
    let router                = MainRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpMainView()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
  }
  
  
  
  
  // MARK: Display
  
  func displayData(viewModel: Main.Model.ViewModel.ViewModelData) {

  }

  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Configure Main View

extension MainViewController {
  
  // Нужен CustomNavBar но пока просто с title
  
  private func setUpMainView() {
    
    mainView = MainView(frame: view.frame)
    view.addSubview(mainView)
    
    configureTableView()
    
  }
  
  private func configureTableView() {
    
    tableView = mainView.tableView
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.showsVerticalScrollIndicator = false
    
    tableView.register(MainTableViewHeaderCell.self, forCellReuseIdentifier: MainTableViewHeaderCell.cellId)
    tableView.register(MainTableViewMiddleCell.self, forCellReuseIdentifier: MainTableViewMiddleCell.cellId)
    tableView.register(MainTableViewFooterCell.self, forCellReuseIdentifier: MainTableViewFooterCell.cellId)
  }
}


// MARK: Configure TableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
      
      case 0:
        return configureHeaderCell()
      
      case 1:
        
        return configureMiddleCell()
      
      case 2:
        return configureFooterCell()
     
      default:break
      
    }
    
    return UITableViewCell()
  }
  
  private func configureHeaderCell() -> MainTableViewHeaderCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewHeaderCell.cellId) as! MainTableViewHeaderCell
    
    return cell
    
   
  }
  
  private func configureMiddleCell() -> MainTableViewMiddleCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewMiddleCell.cellId) as! MainTableViewMiddleCell
    
    return cell
  }
  
  private func configureFooterCell() -> MainTableViewFooterCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewFooterCell.cellId) as! MainTableViewFooterCell
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
      
      case 0:
        return 200
      
      case 1:
        
        return Constants.Main.Cell.mainMiddleCellHeight
      
      case 2:
        return 200
      
      default:break
      
    }
    
    return 0
  }
  
  
}
