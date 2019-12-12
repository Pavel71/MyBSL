//
//  NewCompansationObjectScreenViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol NewCompansationObjectScreenDisplayLogic: class {
  func displayData(viewModel: NewCompansationObjectScreen.Model.ViewModel.ViewModelData)
}

class NewCompansationObjectScreenViewController: UIViewController, NewCompansationObjectScreenDisplayLogic {

  var interactor: NewCompansationObjectScreenBusinessLogic?
  var router: (NSObjectProtocol & NewCompansationObjectScreenRoutingLogic)?
  
  
  
  // VIews
  
  var mainView  : CompansationObjectView!
  var navBar    : CompObjScreenNavBar!
  var tableView : UITableView!
  

  // MARK: Object lifecycle
  
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewCompansationObjectScreenInteractor()
    let presenter             = NewCompansationObjectScreenPresenter()
    let router                = NewCompansationObjectScreenRouter()
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
//    view.backgroundColor = .purple
    
  }
  
  func displayData(viewModel: NewCompansationObjectScreen.Model.ViewModel.ViewModelData) {

  }
  
}

// MARK: SetpUpViews

extension NewCompansationObjectScreenViewController {
  
  private func setUpViews() {
    mainView  = CompansationObjectView()
    navBar    = mainView.navBar
    tableView = mainView.tableView
    
    confugireTableView()
    
    view.addSubview(mainView)
    mainView.fillSuperview()
    
    setViewClousers()
  }
  
  private func confugireTableView() {
    
    
    
    tableView.tableFooterView = UIView()
    
  }
  
  
}

// MARK: Set Views Clousers

extension NewCompansationObjectScreenViewController {
  
  private func setViewClousers() {
    navBar.backButtonCLouser = {[weak self] in
      self?.didTapNavBarBackButton()
    }
  }
  
  
}

// MARK: Cath Views Clousers

extension NewCompansationObjectScreenViewController {
  
  // NAV Bar Clouser
  private func didTapNavBarBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  
}
