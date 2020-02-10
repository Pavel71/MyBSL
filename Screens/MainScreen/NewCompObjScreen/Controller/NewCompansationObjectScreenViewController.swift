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
  
  
  
  // Menu Protocols Property
  
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
  var menuState: State = .closed
  var didPanGestureValueChange: ((UIPanGestureRecognizer) -> Void)?
  var didShowMenuProductsListViewControllerClouser: ((CGFloat) -> Void)?
  
  
  
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

// MARK: Catch  Clousers

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
    
    interactor?.makeRequest(request: .passCurrentSugar(sugar: text))
    //    view.endEditing(true)
    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
  }
  
  private func catchAddMealCellSwitcherValue(isOn: Bool) {
    // Здесь я посылаю сигнал нужно ли мне показывать модель с продукт листом?
    
    interactor?.makeRequest(request: .passIsNeedProductList(isNeed: isOn))
    tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
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
    
    cell.setViewModel(viewModel: viewModel.addMealCellVM)
    setAddMealCellClouser(cell: cell)
    return cell
    
  }
  
  // Sugar Cell
  private func configureSugarCell(indexPath: IndexPath) -> SugarCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SugarCell.cellId, for: indexPath) as!  SugarCell
    
    cell.setViewModel(viewModel: viewModel.sugarCellVM)
    setSugarCellClouser(cell: cell)
    
    return cell
  }
  
  // MARK: Set Cell Clouser
  private func setSugarCellClouser(cell:SugarCell ) {
    cell.passCurrentSugarClouser = {[weak self] text in
      self?.catchCurrentSugarString(text:text)
    }
  }
  
  private func setAddMealCellClouser(cell: AddMealCell) {
    cell.didPassSwitcherValueClouser = { [weak self] isOn in
      self?.catchAddMealCellSwitcherValue(isOn: isOn)
    }
    cell.showMenuController = {[weak self] in
      self?.showMenuController()
    }
    
    
    setProductListControllerCLousers(productListVC: cell.productListViewController)
    
  }
  
  private func setProductListControllerCLousers(productListVC: ProductListInDinnerViewController) {
    
    productListVC.didSelectTextFieldCellClouser = {[weak self] textfield in
      self?.didSelectTextFieldInProductList()
    }
    
    productListVC.didPortionTextFieldEndEditingToDinnerController = {[weak self] portion, index in
      // Нужно сделать Update в Viewmodel
      print(portion, index, "Portion End")
    }
      
    productListVC.didInsulinTextFieldEndEditingToDinnerController = {[weak self] insulin,index in
      print(insulin, index, "Insulin End")
    }
    
    productListVC.didDeleteProductClouser = {[weak self] products in
      self?.deleteProducts(products: products)
    }
    
  }
  
  
}

// MARK: Height
extension NewCompansationObjectScreenViewController {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch NewCompansationVCCellsCase(rawValue: indexPath.row) {
    case .sugarCell:
      
      return getSugarCellHeight(cellState: viewModel.sugarCellVM.cellState)
      
      
    case .addMealCell:
      
      return getAddmealCellHeight()
      
    case .none: return 100
    }
    
  }
  
  private func getAddmealCellHeight() -> CGFloat {
    
    switch viewModel.addMealCellVM.cellState {
    case .defaultState:
      return ProductListCellHeightWorker.getDefaultHeightCell()
    case .productListState:
      
      
      
      return ProductListCellHeightWorker.getWithProductListCellHeight(countProduct: viewModel.addMealCellVM.dinnerProductListVM.productsData.count)
    }
    
    
  }
  
  // MARK: SugsrCellheight
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


// MARK: ProductListTextField  Selected

extension NewCompansationObjectScreenViewController {
  
  private func didSelectTextFieldInProductList() {
    // MARK: TODO
    if menuState == .open {
      // Закрыть меню!
      didShowMenuProductsListViewControllerClouser!(0)
      
    }
    // Нужно настроить смещение экарана
  }
  
}



// MARK: Menu Controller Clousers

extension NewCompansationObjectScreenViewController : MainControllerInContainerProtocol {
  
  func showMenuController() {
    
    let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
    
    let mealViewOffsetY = CalculateDistance.calculateDistanceMealCellToMenuController(cellY: cell.frame.origin.y - 10)
    
    menuState = menuState.opposite
    // теперь здесь мне нужно прокинуть координаты
    didShowMenuProductsListViewControllerClouser!(mealViewOffsetY)
    
  }
  
  // Теперь мне нужно добавить данные в Product List и удалять их оттуда
  // MARK: Add
  func addProducts(products: [ProductRealm]) {
    
    interactor?.makeRequest(request: .addProductsInProductList(products: products))
    tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    
    
  }
  // MARK: Delete
  func deleteProducts(products: [ProductRealm]) {
    
    interactor?.makeRequest(request: .deleteProductsFromProductList(products: products))
    tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    
  }
  
  
  
}

// MARK: Menu Gesture
extension NewCompansationObjectScreenViewController: UIGestureRecognizerDelegate {
  
  //  работает! Но если бы я не знад что так можно хз было бы!
  // Поэтому прохождение курсов очень важная особенность! Нужно постоянно что то мониторить или собирать полезный код
  
  func setUppanGestureRecogniser() {
    slideMenuPanGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeMenu))
    slideMenuPanGestureRecogniser.delegate = self
    view.addGestureRecognizer(slideMenuPanGestureRecogniser)
  }
  
  func removeGestureRecogniser() {
    view.removeGestureRecognizer(slideMenuPanGestureRecogniser)
  }
  
  @objc private func handleSwipeMenu(gesture: UIPanGestureRecognizer) {
    didPanGestureValueChange!(gesture)
    
  }
  
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    // Вообщем если стоим на месте то отключи горизонтальное прокручивание
    return abs((slideMenuPanGestureRecogniser.velocity(in: slideMenuPanGestureRecogniser.view)).y) > abs((slideMenuPanGestureRecogniser.velocity(in: slideMenuPanGestureRecogniser.view)).x)
  }
}
