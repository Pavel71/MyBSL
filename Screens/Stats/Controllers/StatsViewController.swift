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
  
  // MARK: - Object lifecycle
  
  var statsView  = StatsView()
  var scrollView = UIScrollView()
  var testStackView = StackTestView()
  var testView      = TestView()

  var statsData : StatsModel!
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  deinit {
    print("Deinit Stats Controller")
  }
  
  
  
  // MARK: - Setup
  
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

// MARK: - Set Up Views
extension StatsViewController {
  
  private func setUpViews() {

   setUpScrollView()
   setStatsView()


  }
  
  // Stats View
  private func setStatsView() {
    
    // Зададим Чтобы Скролл был только по вертекали!
    statsView.translatesAutoresizingMaskIntoConstraints = false
    self.scrollView.addSubview(statsView)
    
    
    let contentLayouGuide = scrollView.contentLayoutGuide
    
    
    NSLayoutConstraint.activate([
      self.statsView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      
      self.statsView.leadingAnchor.constraint(equalTo: contentLayouGuide.leadingAnchor),
      self.statsView.topAnchor.constraint(equalTo: contentLayouGuide.topAnchor),
      self.statsView.trailingAnchor.constraint(equalTo: contentLayouGuide.trailingAnchor),
      self.statsView.bottomAnchor.constraint(equalTo: contentLayouGuide.bottomAnchor)
    ])
    
    

  }
  
  // Scroll View
  private func setUpScrollView() {
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.scrollView)
    
    let frameLayoutGuide = scrollView.frameLayoutGuide
    
    NSLayoutConstraint.activate([
      
      frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      frameLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  

}

