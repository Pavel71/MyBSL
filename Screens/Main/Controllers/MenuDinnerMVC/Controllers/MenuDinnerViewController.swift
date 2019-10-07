//
//  MenuDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// Сейчас идея выпукивать контроолер из первой ячейки и увеличивать ее размер!


class MenuDinnerViewController: UIViewController {

  
  // Views
  var menuDinnerView = MenuDinnerView()
  var tableView: UITableView!
  
  // CLousers
  var didTapSwipeMenuBackButton: EmptyClouser?
  var didAddProductInDinnerClouser: (([ProductRealm]) -> Void)?
  // ViewModel

  var tableViewProductsData: [MenuProductListViewModel] = []
//  var allMealsData
  
  // Properties
  var currentSegment: Segment = .allProducts
  let foodRealmManager = FoodRealmManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    view.backgroundColor = .white
    setUpMenuDinnerView()
    
    tableViewProductsData = fetchAllProducts()
    tableView.reloadData()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("View Will Appear Menu Dinner")
  }
  
  func setDefaultChooseProduct() {
    
    for row  in tableViewProductsData.indices {
      tableViewProductsData[row].isChoosen = false
    }
    tableView.reloadData()
    
  }
  

  
}

// MARK: Set UP Views
extension MenuDinnerViewController {
  
  private func setUpMenuDinnerView() {
    
    view.addSubview(menuDinnerView)
    menuDinnerView.fillSuperview()
    
    tableView = menuDinnerView.tableView
    
    tableView.register(MenuFoodListCell.self, forCellReuseIdentifier: MenuFoodListCell.cellId)
    tableView.delegate = self
    tableView.dataSource = self
    
    setClousersMenuView()

    
  }
  
  private func setClousersMenuView() {
    
    menuDinnerView.swipeView.swipeMenuButton.addTarget(self, action: #selector(handleSwipeMenuBack), for: .touchUpInside)
    
    menuDinnerView.tableHeaderView.didSegmentValueChange = {[weak self] sc in
      self?.didsegmentChange(segmentController: sc)
    }
  }
  
}

// MARK: Set Up CLousers or Methods

extension MenuDinnerViewController {
  
  // MARK: Swipe Menu Back
  
  @objc private func handleSwipeMenuBack() {
    didTapSwipeMenuBackButton!()
  }
  
  // MARK: SegmentChange
  
  private func didsegmentChange(segmentController: UISegmentedControl) {
    guard let segment = Segment(rawValue: segmentController.selectedSegmentIndex) else {return}
    
    setTableViewDataToSegment(segment: segment)
    
    
    tableView.reloadData()
  }
  

  
  private func setTableViewDataToSegment(segment: Segment) {
    
    switch segment {
    case .allProducts:
      tableViewProductsData = fetchAllProducts()
    case .favorits:
      tableViewProductsData = tableViewProductsData.filter({ (viewModel) -> Bool in
        return viewModel.isFavorit == true
      })
      
    default:break
    }
    currentSegment = segment
  }
}


// MARK: Realm Layer

extension MenuDinnerViewController {

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
  
  private func getProductFromRealm(indexPath: IndexPath) -> ProductRealm? {
    
    let choosed = tableViewProductsData[indexPath.row].isChoosen
    
    var product: ProductRealm?
    
    if !choosed {
      
      let producIdToDinner = tableViewProductsData[indexPath.row].id
      // Или проще здесь его достать добавить в массив и отправить массив в Main
      // так как нам нужны будут списки продуктов если выбираем обед
      
      product = foodRealmManager.getProductById(id: producIdToDinner)
    }
    
    tableViewProductsData[indexPath.row].isChoosen = !choosed
    return product
  }
  
}

extension MenuDinnerViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var currentCount: Int
    switch  currentSegment {
    case .meals:
      print("Предлагаем другое кол-во")
      return 0
    default:
      currentCount = tableViewProductsData.count
    }
    return currentCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch currentSegment {
    case .meals:
      print("Будет совя ячейка!")
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: MenuFoodListCell.cellId, for: indexPath) as! MenuFoodListCell
      cell.setViewModel(viewModel: tableViewProductsData[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
  
  
  // Did Select Row
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch currentSegment {
    case .meals:
      print("Выбор обедов обрабатывается по своему")
    default:
      
      if let product = getProductFromRealm(indexPath: indexPath) {
        
          didAddProductInDinnerClouser!([product])
      }
     

    }
    
    
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  
  
  
  // Header In Section
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MenuFoodListheaderInSectionView()
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  
}
