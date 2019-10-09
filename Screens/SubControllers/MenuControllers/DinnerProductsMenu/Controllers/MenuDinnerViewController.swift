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
  let menuRealmWorker = MenuRealmWorker()
//  let foodRealmManager = FoodRealmManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("View Did Load")
    
    view.backgroundColor = .white
    setUpMenuDinnerView()
    
    tableViewProductsData = menuRealmWorker.fetchAllProducts()
    tableView.reloadData()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    print("Vie Did Appear")
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
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
extension MenuDinnerViewController {
  
  private func setUpMenuDinnerView() {
    
    // Задача добавить это View но на половину экарана
    
    view.addSubview(menuDinnerView)
    
    // Пока вынужден использовать  view так опустить вниз весь функционал и вызывать опускать вьюшку на половниу экрана
    
    menuDinnerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    menuDinnerView.constrainHeight(constant: view.frame.height / 2)
    
    
//    menuDinnerView.fillSuperview()
    
    tableView = menuDinnerView.tableView
    
    tableView.register(MenuFoodListCell.self, forCellReuseIdentifier: MenuFoodListCell.cellId)
    tableView.delegate = self
    tableView.dataSource = self
    
    
    tableView.rowHeight = 50
    
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
      tableViewProductsData = menuRealmWorker.fetchAllProducts()
    case .favorits:
      tableViewProductsData = menuRealmWorker.fetchFavorits()
      
    default:break
    }
    currentSegment = segment
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
      cell.setViewModel(viewModel: tableViewProductsData[indexPath.row], isFavoritsSegment: currentSegment == .favorits)
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
      // Во всех остальных случаях
      
      let choosed = tableViewProductsData[indexPath.row].isChoosen
      tableViewProductsData[indexPath.row].isChoosen = !choosed
      
      if !choosed {
        
        let producIdToDinner = tableViewProductsData[indexPath.row].id
        guard let product = menuRealmWorker.getProductFromRealm(productId: producIdToDinner) else {return}
        didAddProductInDinnerClouser!([product])
      }

    }

    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  
  
  
  // Header In Section
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MenuFoodListheaderInSectionView()
    header.showPortionLabel(isFavoritsSegment: currentSegment == .favorits)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.MenuController.TableView.headerInSectionHeight
  }
  
  
}
