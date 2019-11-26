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
  
  var mainScreenView = MainScreenView()
  
  
  var mainScreenViewModel: MainScreenViewModelable!

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
    navigationController?.navigationBar.isHidden = true
    
    // Сделаем запрос в реалм чтобы получить новые данные по ViewModel
    interactor?.makeRequest(request: .getViewModel)
  }
  
  func displayData(viewModel: MainScreen.Model.ViewModel.ViewModelData) {

  }
  
  
  
}

//MARK: Set Views
extension MainScreenViewController {
  
  
   private func setViews() {
    
    view.addSubview(mainScreenView)
    mainScreenView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
//    mainScreenView.fillSuperview()
    
  }
}




