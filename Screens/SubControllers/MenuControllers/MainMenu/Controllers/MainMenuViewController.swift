//
//  MenuDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 05/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit




class MainMenuViewController: UIViewController,MenuControllerInContainerProtocol {
  
  
  

  // Views
  var menuDinnerView = MenuView(segmentItems: ["Все","Избранное","Обеды"])
  var tableView: UITableView!
  
  // CLousers
  var didTapSwipeMenuBackButton: EmptyClouser?
  var didAddProductClouser: (([ProductRealm]) -> Void)?
  var didDeleteProductClouser: (([ProductRealm]) -> Void)?
//  var didAddProductInDinnerClouser: (([ProductRealm]) -> Void)?
  
  // ViewModel
  var tableViewProductsData: [MenuModel.MenuProductListViewModel] = []
  // Я так думаю что под обеды мне нужна своя модель
  var tableViewMealsData: [MenuModel.MenuMealViewModel] = []

  
  // Properties
  var currentSegment: Segment = .allProducts
  
  // Workers
  let menuRealmWorker = MenuRealmWorker()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("View Did Load Menu Dinner")
    
    view.backgroundColor = .white
    setUpMenuDinnerView()

  }
  
  deinit {
    print("Deinit Menu Dinner")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableViewProductsData = menuRealmWorker.fetchAllProducts()
    tableView.reloadData()
    print("View Will Appear Menu Dinner")
  }
  
  func setDefaultChooseProduct() {
    
    //  Эту функцию нужно будет исправить обязательно
    
    for row  in tableViewProductsData.indices {
      tableViewProductsData[row].isChoosen = false
    }
    tableViewProductsData = menuRealmWorker.fetchAllProducts()
    tableView.reloadData()
    
  }
  

  
}

// MARK: Set UP Views
extension MainMenuViewController {
  
  private func setUpMenuDinnerView() {
    
    // Задача добавить это View но на половину экарана
    
    menuDinnerView.searchBar.delegate = self
    
    view.addSubview(menuDinnerView)
    
    // Пока вынужден использовать  view так опустить вниз весь функционал и вызывать опускать вьюшку на половниу экрана
    
    menuDinnerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 10))
    
    menuDinnerView.constrainHeight(constant: Constants.screenHeight / 2)
    
    configureTableView()
    setClousersMenuView()

    
  }
  
  private func configureTableView() {
    
    tableView = menuDinnerView.tableView
    
    tableView.register(MenuFoodListCell.self, forCellReuseIdentifier: MenuFoodListCell.cellId)
    tableView.register(MenuMealListCell.self, forCellReuseIdentifier: MenuMealListCell.cellId)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  private func setClousersMenuView() {
    
    menuDinnerView.tableHeaderView.didSegmentValueChange = {[weak self] sc in
      self?.didsegmentChange(segmentController: sc)
    }
  }
  
}

// MARK: Set Up CLousers or Methods

extension MainMenuViewController {
  
  
  // MARK: Meal Cell CLousers
  
  private func didTapExpandButton(_ button: UIButton) {
    print("Expand Button")
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: button) else {return}
    
    // Сохранять ничего в Realm не будем просто покажим
    
    let expanded = tableViewMealsData[indexPath.row].isExpanded
    tableViewMealsData[indexPath.row].isExpanded = !expanded
    

    tableView.reloadRows(at: [indexPath], with: .automatic)

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
        tableViewProductsData = menuRealmWorker.fetchAllProducts()
      case .favorits:
        tableViewProductsData = menuRealmWorker.fetchFavorits()
      
      case .meals:
        // Нужно убрать раскрытые обеды это не очень юзабельно Сохранение
        // если что это можно будет сделать здесь пока не вижу смысла можт я уберу это вообще!
        tableViewMealsData = menuRealmWorker.fetchAllMeals()
      
    }
    currentSegment = segment
  }
}


// MARK: TableView Delegate


extension MainMenuViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var currentCount: Int
    switch  currentSegment {
      case .meals:
        currentCount = tableViewMealsData.count
      default:
        currentCount = tableViewProductsData.count
    }
    return currentCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch currentSegment {
      
      case .meals:
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuMealListCell.cellId, for: indexPath) as! MenuMealListCell
        let viewModel = tableViewMealsData[indexPath.row]
        cell.setViewModel(viewModel: viewModel)
        setMealCellClousers(cell)
        
        return cell
      
      default:
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuFoodListCell.cellId, for: indexPath) as! MenuFoodListCell
        cell.setViewModel(viewModel: tableViewProductsData[indexPath.row], isFavoritsSegment: currentSegment == .favorits)
        return cell
    }

  }
  
  private func setMealCellClousers(_ cell:MenuMealListCell ) {
    cell.didTapExpandButtonClouser = { [weak self] button in
      self?.didTapExpandButton(button)
    }
  }
  
  
  // Did Select Row
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch currentSegment {
      case .meals:
        passMealToDinner(indexPath: indexPath)
      default:
        passProductToDinner(indexPath: indexPath)
    }

    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  // MARK: Pass Product To Dinner
  
  private func passProductToDinner(indexPath: IndexPath) {
    
    let choosed = tableViewProductsData[indexPath.row].isChoosen
    tableViewProductsData[indexPath.row].isChoosen = !choosed
    
    let producIdToDinner = tableViewProductsData[indexPath.row].id
    guard let product = menuRealmWorker.getProductFromRealm(productId: producIdToDinner) else {return}
    
    if choosed {
      
      didDeleteProductClouser!([product])
    } else {
      didAddProductClouser!([product])
    }

  }
  
  private func passMealToDinner(indexPath: IndexPath) {
    let choosed = tableViewMealsData[indexPath.row].isChoosen
    tableViewMealsData[indexPath.row].isChoosen = !choosed
    
    // Что можно сделать ! Если choosed то удалить этот продукт или продукты
    // ТОгда по нажатию и снятию галочки будут происходить эти дела
    // Но здесь важно что нужно добавить при открытие меню наполнять продукты но это конечно не реально потомучто меню будет открыватся только на чистой ячейки поэтому эта работа он идет именно сейчас добавил у брал по нажатию
    guard let mealId = tableViewMealsData[indexPath.row].mealId else {return}
    // Получить массив всех продуктов
    guard let products = menuRealmWorker.fetchAllProductsInMeal(mealId: mealId) else {return}
    
    if choosed {
      print("Удалить продукты")
      didDeleteProductClouser!(products)
    } else {
      didAddProductClouser!(products)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch  currentSegment {
    case .meals:
      // Здесь мы посчитаем в ручную размер ячеек!
      let isExpanded = tableViewMealsData[indexPath.row].isExpanded
      let countProductInMeal = tableViewMealsData[indexPath.row].products.count
      let mealName = tableViewMealsData[indexPath.row].name
      
      let cellHeight = CalculateHeightView.calculateMealCellHeight(isExpanded: isExpanded, countRow: countProductInMeal, mealName: mealName)
      
      return cellHeight
      
    default:
      return UITableView.automaticDimension
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

extension MainMenuViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    if searchText.isEmpty {
      setTableViewDataToSegment(segment: currentSegment)
      
    } else {
      
      tableViewProductsData = tableViewProductsData.filter({ (product) -> Bool in
        product.name.contains(searchText)
      })
    }
    
    tableView.reloadData()
    
  }
}
