//
//  StatsViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//


// Использую пока для тестирования!


// Теперь когда подгружаем экран нам нужно получить Хорошие обеды и плохие обеды из Реалма
// Идем в Интерактор и запрашиваем данные потом обновляем Экран!
// Теперь нужно будет получить данные для робота + данные для Других полей и все будет норм!



import UIKit

protocol StatsDisplayLogic: class {
  func displayData(viewModel: Stats.Model.ViewModel.ViewModelData)
}



class StatsViewController: UIViewController, StatsDisplayLogic {
  
  var interactor: StatsBusinessLogic?
  var router: (NSObjectProtocol & StatsRoutingLogic)?
  
  // MARK: Object lifecycle
  
  var statsView: StatsView!
  var scrollView = UIScrollView()
  
  
  
  var statsData : StatsModel!
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  deinit {
    print("Deinit Stats Controller")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    self.scrollView.frame = self.view.bounds
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
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpViews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
    
    interactor?.makeRequest(request: .getStatsModel)
  }
  
  
  
  
  func displayData(viewModel: Stats.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .passStatsModelToVC(let statsModel):
      
      statsView.setViewModel(viewModel: statsModel)
      
    }
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Set Up Views
extension StatsViewController {
  
  private func setUpViews() {
    
    
    self.view.addSubview(self.scrollView)
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
    
    statsView = StatsView(frame: view.frame)
    
    // Зададим Чтобы Скролл был только по вертекали!
    
    self.scrollView.addSubview(statsView)
    
    //    self.statsView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.statsView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
      self.statsView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
      self.statsView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
      self.statsView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
      self.statsView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
    ])
    scrollView.contentInset.bottom = 100
    //    self.scrollView.contentSize = .init(width: self.view.frame.size.width, height: self.statsView.frame.height)
    self.scrollView.contentSize.height = statsView.frame.height
    
  }
}

