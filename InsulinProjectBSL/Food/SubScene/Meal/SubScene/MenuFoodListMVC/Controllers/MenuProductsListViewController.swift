//
//  MenuFoodListViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 17/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Задача класса собрать массив продуктов с Определнной моделью и передать его в MealViewController!

class MenuProductsListViewController: UIViewController {
  
  static let screenWidth: CGFloat = (UIScreen.main.bounds.width / 2) + 50
  
  init() {
    print("Init Menu View Controller")
    super.init(nibName: nil, bundle: nil)
  }
  deinit {
    print("Deinit Menu Controller")
  }
  
  let foodRealmManager = FoodRealmManager()
  
  // Back Data!
  var addProductsData: [MealViewModel.ProductCell] = []
  
  
  let searchBar: UISearchBar = {
    let sB = UISearchBar()
    sB.searchBarStyle  = .minimal
    sB.placeholder = "Поиск..."
    sB.sizeToFit()
    sB.isTranslucent = false
    
    
    return sB
  }()
  
  
  // Table View
  var tableHeaderView = FoodTableViewHeader(frame: FoodTableViewHeader.headerSize, setSegments: ["Все продукты","Избранное"])
  var currentSegment: Segment = .allProducts
  
  var tableView = UITableView(frame: .zero, style: .plain)
  
  var tableViewData: [MenuProductListViewModel] = []
  
  // CLousers
  
  var didAddProductInMealClouser: ((String) -> Void)?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.frame = CGRect(x: 0, y: 0, width: MenuProductsListViewController.screenWidth, height: UIScreen.main.bounds.height)
    
    
     setUpSearchBar()
     setUpTableView()
    
     tableViewData =  fetchAllProducts()
     tableView.reloadData()
  }
  
  // View Layer
  
  private func setUpSearchBar() {
    view.addSubview(searchBar)
    searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .zero,size: .init(width: 0, height: 60))
    searchBar.delegate = self
  }
  
  private func setUpTableView() {
    
    view.addSubview(tableView)
    tableView.anchor(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    
//    tableView.estimatedRowHeight = 200
//    tableView.rowHeight = UITableView.automaticDimension
//
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.keyboardDismissMode = .interactive
    
    tableView.register(MenuFoodListCell.self, forCellReuseIdentifier: MenuFoodListCell.cellId)
    tableView.tableHeaderView = tableHeaderView
    
    tableHeaderView.didSegmentValueChange = {[weak self] segmentControll in self?.didSegmentChange(segmentControll: segmentControll)}
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

// MARK: SearchBar Delegate
extension MenuProductsListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    
    print(searchText)
    
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

extension MenuProductsListViewController {
  
  private func didSegmentChange(segmentControll: UISegmentedControl) {
    
    guard let segment = Segment(rawValue: segmentControll.selectedSegmentIndex) else {return}
    
    setTableViewDataToSegment(segment: segment)
    
    
    tableView.reloadData()
    
  }
  
  private func setTableViewDataToSegment(segment: Segment) {
    
    switch segment {
      case .allProducts:
        tableViewData = fetchAllProducts()
      case .favorits:
        tableViewData = tableViewData.filter({ (viewModel) -> Bool in
          return viewModel.isFavorit == true
        })
      
    default:break
    }
    currentSegment = segment
  }
}

// MARK: Realm Layer

extension MenuProductsListViewController {
  // Fetch All product
  private func fetchAllProducts() -> [MenuProductListViewModel] {
    
    let realmItems = foodRealmManager.allProducts()

    var dummyArray: [MenuProductListViewModel] = []

    for product in realmItems {
      let carboString = String(product.carbo)
//      let portionString = String(product.portion)
      let productCellViewModel = MenuProductListViewModel(id: product.id, name: product.name, carboOn100Grm: carboString, isFavorit: product.isFavorits)

      dummyArray.append(productCellViewModel)
    }

    return dummyArray
  }
}


// MARK: TableView Delegate DataSource
extension MenuProductsListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MenuFoodListCell.cellId, for: indexPath) as! MenuFoodListCell
    cell.setViewModel(viewModel: tableViewData[indexPath.row])
    return cell
  }
  
  // Did Select Row
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    tableViewData[indexPath.row].isChoosen = !tableViewData[indexPath.row].isChoosen
    
    let producIdToAddMeal = tableViewData[indexPath.row].id
    
    didAddProductInMealClouser!(producIdToAddMeal)
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  // Header In Section
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MenuFoodListheaderInSectionView()

    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return MenuFoodListheaderInSectionView.height
  }
  
}
