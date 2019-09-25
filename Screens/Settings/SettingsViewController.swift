//
//  SettingsViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol SettingsDisplayLogic: class {
  func displayData(viewModel: Settings.Model.ViewModel.ViewModelData)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {

  var interactor: SettingsBusinessLogic?
  var router: (NSObjectProtocol & SettingsRoutingLogic)?

  // MARK: Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  

  deinit {
    print("Deinit Settings Controller")
  }
  

  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SettingsInteractor()
    let presenter             = SettingsPresenter()
    let router                = SettingsRouter()
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
    
    view.backgroundColor = .yellow
  }
  
  // MARK: Display
  
  func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
