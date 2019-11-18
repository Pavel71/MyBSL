//
//  StatsViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//


// Использую пока для тестирования!





import UIKit

protocol StatsDisplayLogic: class {
  func displayData(viewModel: Stats.Model.ViewModel.ViewModelData)
}



class StatsViewController: UIViewController, StatsDisplayLogic {

  var interactor: StatsBusinessLogic?
  var router: (NSObjectProtocol & StatsRoutingLogic)?

  // MARK: Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  deinit {
    print("Deinit Stats Controller")
  }
  
 
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = StatsInteractor()
    let presenter             = StatsPresenter()
    let router                = StatsRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  var tableView = UITableView(frame: .zero, style: .plain)
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    setViews()
//    registerCell()

  }
 
  
 
  
  func displayData(viewModel: Stats.Model.ViewModel.ViewModelData) {

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

////MARK: Set Views
//extension StatsViewController {
//
//
//   private func setViews() {
//
//    view.addSubview(tableView)
//    tableView.fillSuperview()
//
//    tableView.delegate = self
//    tableView.dataSource = self
//
////    tableView.estimatedRowHeight = 200
////    tableView.rowHeight = UITableView.automaticDimension
////
//    tableView.tableFooterView = UIView()
//    tableView.separatorStyle = .none
//
//   }
//
//  private func registerCell() {
//     tableView.register(TopViewCell.self, forCellReuseIdentifier: TopViewCell.cellId)
//     tableView.register(MiddleCell.self, forCellReuseIdentifier: MiddleCell.cellId)
//   }
//}
//
//
//
//// MARK: TableViewDelegate and DataSource
//
//extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
//
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 1
//  }
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 2
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    let tableViewLayer = getTableVIewLayer(indexPath: indexPath)
//
//    switch tableViewLayer {
//    case .topLayer:
//      let cell = tableView.dequeueReusableCell(withIdentifier: TopViewCell.cellId, for: indexPath) as! TopViewCell
//      return cell
//
//    case .insulinInjectionLayer:
//
//      let cell = tableView.dequeueReusableCell(withIdentifier: MiddleCell.cellId, for: indexPath) as! MiddleCell
//
//      return cell
//
//    }
//
//  }
//
//
//
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//
//
//
//  }
//
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    let tableViewLayer = getTableVIewLayer(indexPath: indexPath)
//
//    switch tableViewLayer {
//    case .topLayer:
//      return 150
//    case .insulinInjectionLayer:
//      return SomeConstants.MiddleCell.cellHeight
//
//    }
//  }
//
//  private func getTableVIewLayer(indexPath: IndexPath) -> TableViewLayer {
//    return TableViewLayer.init(rawValue: indexPath.row)!
//  }
//
//
  
  

