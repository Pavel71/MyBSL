//
//  NewCompansationObjectScreenViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.12.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit


enum NewCompansationVCCellsCase: Int,CaseIterable {
  case sugarCell
  case addMealCell
}

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
  
  
  // ViewModel
  
  var viewModel: NewCompObjViewModel! //{didSet{tableView.reloadData()}}

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
    
    interactor?.makeRequest(request: .getBlankViewModel)
    
  }
  
  // MARK: Display Data
  
  func displayData(viewModel: NewCompansationObjectScreen.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .setViewModel(let viewModel):
      self.viewModel = viewModel
      
    default:break
    }
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
    
    tableView.allowsSelection      = false
//    tableView.rowHeight            = UITableView.automaticDimension
//    tableView.estimatedRowHeight   = 50
    tableView.keyboardDismissMode  = .interactive
    tableView.delegate             = self
    tableView.dataSource           = self
    tableView.tableFooterView      = UIView()
    
    
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(SugarCell.self, forCellReuseIdentifier: SugarCell.cellId)
    tableView.register(AddMealCell.self, forCellReuseIdentifier: AddMealCell.cellId)
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
  
  private func catchCurrentSugarString(text: String) {
    
    print(text)
    interactor?.makeRequest(request: .passCurrentSugar(sugar: text))
//    view.endEditing(true)
    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
  }
  

  
}

// MARK: TableView DataSource and Delegate
extension NewCompansationObjectScreenViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return NewCompansationVCCellsCase.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch NewCompansationVCCellsCase(rawValue: indexPath.row) {
    case .sugarCell:
      return configureSugarCell(indexPath: indexPath)
    case .addMealCell:
      return configureAddMealCell(indexPath: indexPath)
    case .none: return UITableViewCell()
    }
    
  }
  
  // AddMealCell
  
  private func configureAddMealCell(indexPath: IndexPath) -> AddMealCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: AddMealCell.cellId, for: indexPath) as! AddMealCell
    
    return cell
    
  }
  
  // Sugar Cell
  private func configureSugarCell(indexPath: IndexPath) -> SugarCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SugarCell.cellId, for: indexPath) as!  SugarCell
    
    cell.setViewModel(viewModel: viewModel.sugarCellVM)
    setSugarCellClouser(cell: cell)
    
    return cell
  }
  
  private func setSugarCellClouser(cell:SugarCell ) {
    cell.passCurrentSugarClouser = {[weak self] text in
      self?.catchCurrentSugarString(text:text)
    }
  }
  
  // MARK: Height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch NewCompansationVCCellsCase(rawValue: indexPath.row) {
    case .sugarCell:
        
      return getSugarCellHeight(cellState: viewModel.sugarCellVM.cellState)
      
    case .addMealCell:
      return 100

    case .none: return 100
    }
    
  }
  
  private func getSugarCellHeight(cellState: SugarCellState) -> CGFloat {
    
    let cellHeight: CGFloat
    
    switch cellState {
    case .currentLayer:
      cellHeight = SugarCellHeightWorker.getDefaultHeight()
    case .currentLayerAndCorrectionLabel:
      cellHeight = SugarCellHeightWorker.getCurrentSugarLayerAndCOrrectionLabelHeight()
    case .currentLayerAndCorrectionLayer:
      cellHeight = SugarCellHeightWorker.getCurrentSugarLayerAndComapnsationLayerHeight()
    }
    
    return cellHeight
  }
  
  
}
