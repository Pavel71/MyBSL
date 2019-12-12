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
    
    tableView.keyboardDismissMode  = .interactive
//    tableView.alwaysBounceVertical = false
    tableView.delegate             = self
    tableView.dataSource           = self
    tableView.tableFooterView      = UIView()
    
    
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(SugarCell.self, forCellReuseIdentifier: SugarCell.cellId)
  }
  
  
}

// MARK: Set Views Clousers

extension NewCompansationObjectScreenViewController {
  
  private func setViewClousers() {
    
    navBar.backButtonCLouser = {[weak self] in
      self?.didTapNavBarBackButton()
    }
    navBar.saveButtonCLouser = {[weak self] in
      self?.didTapNavBarSaveButton()
    }
    
    
  }
  
  
}

// MARK: Cath Views Clousers

extension NewCompansationObjectScreenViewController {
  
  // NAV Bar Clouser
  private func didTapNavBarBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  private func didTapNavBarSaveButton() {
    
    print("Собрать модель и сохранить и сделать дисмисс ")
  }
  
  // SUgarTextField RightButton
  
  private func didTapSugarTextFieldButton(text: String) {
    
    // пришел сахар и нужно проверить! В норме он или нет! Значит мы должны взять сервис и проверить! Он нам вернет 3 позиции выше нормы норма и инже нормы!
    
    
    navBar.saveButton.isEnabled = true
    view.endEditing(true)
  }
  
  private func checkSugar(sugar: String) {
    let sugarFloat = (sugar as NSString).floatValue
    let wayCorrectPosition = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: sugarFloat)
    
    switch wayCorrectPosition {
    case .dontCorrect:
      print("Сахар в норме можно показывать ячейку с продуктами")
    case .correctDown:
      print("Высокий сахар нужно скорректировать доп инсулином и показываем продукты")
    case .correctUp:
      print("Сахар ниже нормы Показываем возможность добавить продукты")
    default:break
    }
  }
  
}

// MARK: TableView DataSource and Delegate
extension NewCompansationObjectScreenViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: SugarCell.cellId, for: indexPath) as!  SugarCell
    setCellClouser(cell: cell)
    return cell
  }
  
  private func setCellClouser(cell:SugarCell ) {
    cell.didTapSugarTextFieldButton = {[weak self] text in
      self?.didTapSugarTextFieldButton(text:text)
    }
  }
  
  // Height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
    case 0:
      return 100
    default:
      return 400
    }
    
  }
  
  
}
