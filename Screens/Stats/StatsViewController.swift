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


struct SectionType {
  var name: String
  var meals: [MealDummy]
  
}

struct MealDummy {
  var isExpand: Bool = false
  var name: String
  var products: [ProductDummy]
}

struct ProductDummy {
  var name: String
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
  
  
  // Doom Data
  
  var dummyData = [
    SectionType(name: "Завтраки",
                meals: [
                  MealDummy(isExpand: false, name: "Гречневая каша",
                            products: [
                              ProductDummy(name: "гречка"),
                              ProductDummy(name: "молоко"),
                              ProductDummy(name: "гречка")
                    ]),
                  MealDummy(isExpand: false,name: "Омлет",
                            products: [
                              ProductDummy(name: "яйца"),
                              ProductDummy(name: "молоко")])
      ]),
    SectionType(name: "Обеды",
                meals: [
                  MealDummy(isExpand: false,name: "Борщ", products: [
                    ProductDummy(name: "капуста"),
                    ProductDummy(name: "говядина")
                    ]),
                  MealDummy(isExpand: false,name: "Пельмени", products: [
                    ProductDummy(name: "пельмени")
                    ]),
                  MealDummy(isExpand: false,name: "Сосиски с овощами", products: [
                    ProductDummy(name: "сосиски"),
                    ProductDummy(name: "овощи")
                    ])
                  ])
  
  ]
  
  var tableView = UITableView(frame: .zero, style: .plain)
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
 
//
//    view.addSubview(tableView)
//    tableView.fillSuperview()
//
//    tableView.delegate = self
//    tableView.dataSource = self
//    tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.cellID)
//
//    tableView.estimatedRowHeight = 200
//    tableView.rowHeight = UITableView.automaticDimension
//
//    tableView.tableFooterView = UIView()
//    tableView.separatorStyle = .none
    
  }
  
  func displayData(viewModel: Stats.Model.ViewModel.ViewModelData) {

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return dummyData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dummyData[section].meals.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.cellID, for: indexPath) as! StatsTableViewCell
    
    cell.mealCellViewModel = dummyData[indexPath.section].meals[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return dummyData[section].name
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    // Расширяем tableView
    let isExpand = dummyData[indexPath.section].meals[indexPath.row].isExpand
    dummyData[indexPath.section].meals[indexPath.row].isExpand = !isExpand

    tableView.reloadRows(at: [indexPath], with: .automatic)

  }
  
  
  
  
}
