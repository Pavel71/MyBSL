//
//  MenuFoodListViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 17/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift


// Задача класса собрать массив продуктов с Определнной моделью и передать его в MealViewController!

class MenuInMealViewController: UIViewController,MenuControllerInContainerProtocol {

  init() {
    print("Init Menu View Controller")
    super.init(nibName: nil, bundle: nil)
  }
  deinit {
    print("Deinit Menu Controller")
  }
  
  let menuRealmWorker = MenuRealmWorker()

  
  // Back Data!
  var addProductsData: [ProductListViewModel] = []
  
  
  let searchBar: UISearchBar = {
    let sB = UISearchBar()
    sB.searchBarStyle  = .minimal
    sB.placeholder = "Поиск..."
    sB.sizeToFit()
    sB.isTranslucent = false
    
    
    return sB
  }()
  
  
  
  var currentSegment: Segment = .allProducts
  
  var menuView = MenuView(segmentItems: ["Все","Избранное"])
  
  var tableView:UITableView!
  var tableViewData: [MenuModel.MenuProductListViewModel] = []
  
  // CLousers
  var didAddProductClouser: (([ProductRealm]) -> Void)?
  var didDeleteProductClouser: (([ProductRealm]) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setUpMenuView()
    
     tableViewData =  menuRealmWorker.fetchAllProducts()
     tableView.reloadData()
  }
  
  
  
  func setDefaultChooseProduct() {
    
    for row  in tableViewData.indices {
      tableViewData[row].isChoosen = false
    }
    tableView.reloadData()
  
  }
  

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}


// MARK: Set UP Views
extension MenuInMealViewController {
  
  private func setUpMenuView() {

    view.addSubview(menuView)
    menuView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 10),size: .init(width: 0, height: UIScreen.main.bounds.height / 2))
    
    menuView.searchBar.delegate = self
    
    configureTableView()
    setMenuViewClousers()
  }
  
  private func configureTableView() {
    tableView = menuView.tableView
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(MenuFoodListCell.self, forCellReuseIdentifier: MenuFoodListCell.cellId)
    
    
  
    tableView.keyboardDismissMode = .interactive
  }
  
  private func setMenuViewClousers() {
    menuView.tableHeaderView.didSegmentValueChange = {[weak self] segmentControll in self?.didSegmentChange(segmentControll: segmentControll)}
  }
  
  

}


// MARK: SearchBar Delegate
extension MenuInMealViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    
    if searchText.isEmpty {
      setTableViewDataToSegment(segment: currentSegment)
      
    } else {
      tableViewData = tableViewData.filter({ (product) -> Bool in
        product.name.contains(searchText)
      })
    }
    
    tableView.reloadData()
   
  }
}

// MARK: DId Tap Some Buttons Change Text Or Segment

extension MenuInMealViewController {
  
  private func didSegmentChange(segmentControll: UISegmentedControl) {
    
    guard let segment = Segment(rawValue: segmentControll.selectedSegmentIndex) else {return}
    
    setTableViewDataToSegment(segment: segment)
    
    
    tableView.reloadData()
    
  }
  
  private func setTableViewDataToSegment(segment: Segment) {
    
    switch segment {
      case .allProducts:
        tableViewData = menuRealmWorker.fetchAllProducts()
      case .favorits:
        tableViewData = menuRealmWorker.fetchFavorits()
      
    default:break
    }
    currentSegment = segment
  }
}


// MARK: TableView Delegate DataSource
extension MenuInMealViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MenuFoodListCell.cellId, for: indexPath) as! MenuFoodListCell
    cell.setViewModel(viewModel: tableViewData[indexPath.row], isFavoritsSegment: currentSegment == .favorits)
    
    
    return cell
  }
  
  // Did Select Row
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    
    passProductToDinner(indexPath: indexPath)
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  private func passProductToDinner(indexPath: IndexPath) {
    
    let choosed = tableViewData[indexPath.row].isChoosen
    tableViewData[indexPath.row].isChoosen = !choosed
    
    let producIdToAddMeal = tableViewData[indexPath.row].id
    guard let product = menuRealmWorker.getProductFromRealm(productId: producIdToAddMeal) else {return}
    
    if choosed {
      
      didDeleteProductClouser!([product])
    } else {
      didAddProductClouser!([product])
    }
    
  }
  
  // Header In Section
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let header = MenuFoodListheaderInSectionView()
//    header.showPortionLabel(isFavoritsSegment: currentSegment == .favorits)
//    return header
//  }
//  
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return Constants.MenuController.TableView.headerInSectionHeight
//  }
  
}
