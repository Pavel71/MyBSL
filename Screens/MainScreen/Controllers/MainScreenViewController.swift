//
//  MainScreenViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit


enum TableViewLayer: Int {
  
  case topLayer
  case insulinInjectionLayer
}



protocol MainScreenDisplayLogic: class {
  func displayData(viewModel: MainScreen.Model.ViewModel.ViewModelData)
}

class MainScreenViewController: UIViewController, MainScreenDisplayLogic {

  var interactor: MainScreenBusinessLogic?
  var router: (NSObjectProtocol & MainScreenRoutingLogic)?
  
  
  
  // Properties
  
//  var tableView = UITableView(frame: .zero, style: .plain)
  
  var chartVC           : ChartViewController!
  var mealCollectionVC  : MealCollectionVC!
  var insulinSupplyView : InsulinSupplyView!
  
  var mainScreenView = MainScreenView()
  var mainScreenViewModel: MainScreenViewModelable! {
    
    didSet {
      mainScreenView.setViewModel(viewModel: mainScreenViewModel)
    }
  }

  // MARK: Object lifecycle
  
   init() {
     super.init(nibName: nil, bundle: nil)
     setup()
   }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = MainScreenInteractor()
    let presenter             = MainScreenPresenter()
    let router                = MainScreenRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("View Will Appear Main Screeen")
    navigationController?.navigationBar.isHidden = true
    
    // Сделаем запрос в реалм чтобы получить новые данные по ViewModel
    interactor?.makeRequest(request: .getViewModel)
  }
  
  func displayData(viewModel: MainScreen.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .setViewModel(let viewModel):
      mainScreenViewModel = viewModel
    }

  }
  
  
  
}

//MARK: Set Views
extension MainScreenViewController {
  
  
   private func setViews() {
    
    chartVC           = mainScreenView.chartView.chartVC
    mealCollectionVC  = mainScreenView.mealCollectionView.collectionVC
    insulinSupplyView = mainScreenView.insulinSupplyView
    
    view.addSubview(mainScreenView)
    mainScreenView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)

    setClousers()
  }
  
  // MARK: Set Clousers From Views
  
  private func setClousers() {
    setChartVCClousers()
    
    setMealVCClousers()
    
    setInsulinSupplyClousers()
    
  }
  // ChartVC Clousers
  private func setChartVCClousers() {
    chartVC.passMealIdCLouser = { [weak self] mealId in
      self?.catchMealIdFromChart(mealId: mealId)
    }
  }
  // MealVC Clousers
  private func setMealVCClousers() {
    mealCollectionVC.passMealIdItemThanContinueScroll = {[weak self] mealId in
      self?.catchMealIDFromMealVCThanScrolled(mealId: mealId)
    }
  }
  
  private func setInsulinSupplyClousers() {
    insulinSupplyView.passSiganlLowSupplyLevel  = {[weak self] in
      self?.catchInsulinViewSupplyLevelLow()
    }
    
    insulinSupplyView.passSignalShowSupplyLevel = {[weak self] in
      self?.catchInsulinViewShowSupplyLevel()
    }
  }
}


// MARK: Catch Clousers From Views

extension MainScreenViewController {
  
  // Catch Meal Id Than Selected in Chart
  
  private func catchMealIdFromChart(mealId: String) {
    
    // теперь мне нужно поймать ячейку с этим Id и показать ее юзеру
    let rowMealById = mealCollectionVC.dinners.firstIndex{$0.mealId == mealId}
    guard let indexRow = rowMealById else {return}
    

    mealCollectionVC.collectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: true)
    
  }
  
  // CatchMealVC CLousers
  
  private func catchMealIDFromMealVCThanScrolled(mealId: String) {
    // теперь мне нужно подсветить entry по mealId
    chartVC.highlitedEntryByMealId(mealId: mealId)
  }
  
  // Catch InsulinSupplyView
  
  private func catchInsulinViewSupplyLevelLow() {
    self.showAlertController(title: "Низкий запас инсулина!", message: "Замените картридж с инсулином!")
  }
  
  private func catchInsulinViewShowSupplyLevel() {
    
    let supplyLevel = mainScreenViewModel.insulinSupplyVM.insulinSupply
    self.showAlertController(title: "Инсулина в картридже.", message: "\(supplyLevel)ед.")
  }
  
}







