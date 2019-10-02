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
  
  var choosePlaceInjection = ChoosePlaceInjectionView(frame: .init(x: 0, y: 0, width: 280, height: 350))
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .yellow
    
    
    choosePlaceInjection.center = view.center
    view.addSubview(choosePlaceInjection)
    
    
//    setUpForceRecogniser()
    

  }
  
  
  
  private func setUpForceRecogniser() {
      let forceGesture = ForceGestureRecognizer(forceThreshold: 20)
      forceGesture.addTarget(self, action: #selector(forceTap))
      view.addGestureRecognizer(forceGesture)
  }
  
  @objc private func forceTap(gesture: ForceGestureRecognizer) {
    print("Force Tap")
    
    print(gesture.force)
  }
  
  // MARK: Display
  
  func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
