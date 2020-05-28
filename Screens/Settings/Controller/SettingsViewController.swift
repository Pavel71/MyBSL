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
  
  
  // MARK: Properties
  
  
  let settingView = SettingsView()

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
    
    
    setUpViews()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
  }
  
  
  
  // MARK: Display
  
  func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .logOut(let result):
      getAnswerLogOut(result: result)
    default:break
    }

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: SET UP VIEWS

extension SettingsViewController {
  
  func setUpViews() {
    
    view.addSubview(settingView)
    settingView.fillSuperview()
    
    setViewClousers()
  }
}

// MARK: Set Views Clousers
extension SettingsViewController {
  
  private func setViewClousers() {
    
    setNavBarClousers()
    
  }
  
  
  private func setNavBarClousers() {
    settingView.customNavBar.didTapLogOutButton = {[weak self] in
     
      self?.handlelogOutButton()
    }
  }
}


extension SettingsViewController {
  
  // MARK: Log Out
  
  private func handlelogOutButton() {
    
    interactor?.makeRequest(request: .logOut)
    
  }
  
  private func getAnswerLogOut(result: Result<Bool,NetworkFirebaseError>) {
    
    switch result {
    case .success(_):
      
      let appState = AppState.shared
      appState.toogleMinorWindow(minorWindow: appState.loginRegisterWindow)
      
    case .failure(let error):
      
      showErrorMessage(text: error.localizedDescription)
    }
  }
  
}
