//
//  FoodViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift
import ProgressHUD


protocol FoodDisplayLogic: class {
  func displayData(viewModel: Food.Model.ViewModel.ViewModelData)
}

class FoodViewController: UIViewController, FoodDisplayLogic {

  var interactor: FoodBusinessLogic?
  var router: (NSObjectProtocol & FoodRoutingLogic)?
  
//  var arraySectionExpanded = [Bool]()
  
  
  // При каждом сете проверяем какие секции были раскрыты какие закрыты! Что бы отобразить так это оставил Юзер
  var foodViewModel = [FoodViewModel.init(items: [])] {
    
    didSet {
      if foodViewModel.count == 1 {
        // Если мы хотим просто список то раскрой его сразу
        foodViewModel[0].isExpanded = true
      }
    }
  }
  

  // MARK: Object lifecycle
  var currentSegment: Segment = .allProducts
  
  var foodView: FoodView!
  var customNavBar: CustomNavBar!
  
//  var newProductView: NewProductView!
  var newProductView: NewProductView!
  
  
  var blurView: UIVisualEffectView!
  var tableView: UITableView!
  var pickerView: UIPickerView!
  
  var headerInSection: CustomHeaderInSectionView!
  var headerInSectionWorker = HeaderInSectionWorker()
  
  
  var realmObserverTokken: NotificationToken!
  // Это нужно для анимации
  var addViewBottomY: CGFloat!
  // Если мы обновляем продукт то вот его индекс
  var updateProductId: String?
  var currentSection: Int!
  
  var pickerData:[String] = [] {
    didSet {
      pickerView.reloadAllComponents()
    }
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  deinit {
    print("Deinit Food Controlelr")
  }
  
  
  // MARK: Setup
  
  private func setup() {
    
    let viewController        = self
    let interactor            = FoodInteractor()
    let presenter             = FoodPresenter()
    let router                = FoodRouter()
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

    setUpView()
//    fetchProductBySegment(segment: currentSegment)

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // При возвращение на этот экран выдели последний активный сегмент!
    
    
    navigationController?.navigationBar.isHidden = true
    setKeyboardNotification()
    
    interactor?.makeRequest(request: .setRealmObserverToken)

    // Пока вот так коряво но это работает
    foodView.headerTableView.setsegmentIndex = currentSegment.rawValue

    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    realmObserverTokken.invalidate()
    NotificationCenter.default.removeObserver(self)
  }
  

  

  
  // MARK: Display
  
  func displayData(viewModel: Food.Model.ViewModel.ViewModelData) {
    
    // Set View Model
    switch viewModel {
      
      case .setViewModel(let viewModel):

        foodViewModel = headerInSectionWorker.updateViewModelByExpandSection(newViewModel:viewModel, with: currentSegment) as! [FoodViewModel]
      
      case .setProductRealmObserver(let productRealmObserver):
        realmObserverTokken = productRealmObserver
      
      case .setDataToNewProductView(let viewModel):
        
        newProductView.set(viewModel: viewModel)
        pickerData = viewModel.listCategory
        
        pickerView.isHidden = true
        
        
        AddNewElementViewAnimated.showOrDismissNewView(newElementView: newProductView, blurView: blurView, customNavBar: customNavBar, tabbarController: tabBarController!, isShow: true)
      
      case .displayAlertSaveNewProduct(let success):
        saveNewProduct(success: success)
    }

    // Задача здесь простая если какие то секции открыты то после перезагрузки отсавить их!
    reloadTableView()
  }
  
  private func reloadTableView() {
    self.tableView.reloadData()
//    UIView.transition(with: tableView, duration: 0.2, options: [.curveEaseOut,.transitionCrossDissolve], animations: {
//      self.tableView.reloadData()
//    }, completion: nil)
  }
  
  // MARK: Display Methods
  private func saveNewProduct(success: Bool) {
    
    if success {
      let successString = updateProductId == nil ? "Продукт сохранен!" : "Продукт обновленн!"
      didCancelNewProduct()
      ProgressHUD.showSuccess(successString)
    } else {
      ProgressHUD.showError("Такое имя уже есть, Отредактируйте продукт или создайте новый!")
    }
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: Set Up And Configure Views

extension FoodViewController {
  
  // MARK: Set Up View
  
  private func setUpView() {
    foodView = FoodView(frame: view.frame)
    view.addSubview(foodView)
    
    blurView = foodView.blurView
    
    
    configureNewPoriductView()
    
    configureCustomNavBar()
    
    configureSegmentController()
    
    confugureTableView()
    configurePickerView()
    
  }
  
  private func configureSegmentController() {
    foodView.headerTableView.didSegmentValueChange = {[weak self] segmentController in
      self?.didChangeSemenTableView(segmentController: segmentController)
      
    }
  }
  
  private func configurePickerView() {
    
    pickerView = foodView.pickerView
    pickerView.dataSource = self
    pickerView.delegate = self
  }
  
  private func configureCustomNavBar() {
    
    customNavBar = foodView.customNavBar
    
    customNavBar.addButton.addTarget(self, action: #selector(didTapAddNewProduct), for: .touchUpInside)
    
    
    customNavBar.didTapChangeSectionViewButton = {[weak self] in self?.didTapChangeSectionViewButton()}
    
    customNavBar.searchBar.delegate = self
  }
  
  private func confugureTableView() {
    
    tableView = foodView.tableView
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.cellID)
    
    tableView.tableFooterView = UIView()
  }
  
  private func configureNewPoriductView() {
    
    newProductView = foodView.newProductView
    
    newProductView.cancelButton.addTarget(self, action: #selector(didCancelNewProduct), for: .touchUpInside)
    
    newProductView.categoryWithButtonTextFiled.rightButton.addTarget(self, action: #selector(didTapShowListCategory), for: .touchUpInside)
    
    newProductView.didTapSaveButton = {[weak self] alertString, newFoodViewModel in self?.didSaveNewProduct(alertString: alertString, newProductViewModel: newFoodViewModel) }
    
    newProductView.foodValidator.isValidCallBack = {[weak self] isCanSave in self?.textFiledsValidateCanSave(isCanSave: isCanSave) }
    
    newProductView.newProductViewTextFieldBegintEditing = {[weak self] in self?.didBeginEditingNewProductTextFields() }
  }
  
}

// MARK: Set Clousers and Button Methods

extension FoodViewController {
  
  // MARK: Show New Product View
  
  // Add NewProduct Button
  @objc private func didTapAddNewProduct() {
    
    interactor?.makeRequest(request: .showNewProductView(productIdString: nil))
  }
  
  
  private func didTapChangeSectionViewButton() {
    
    headerInSectionWorker.changeIsDefaultlistByCategory(segment: currentSegment)
    
    let isDefaultBySegment = headerInSectionWorker.getIsDefaultListBySegment(segment: currentSegment)
    interactor?.makeRequest(request: .showListProductsBySection(isDefaultList: isDefaultBySegment))
    
    headerInSectionWorker.fillSectionExpandedArrayBySegment(viewModels: foodViewModel, segment: currentSegment)
  }
  
  
  
  // MARK: New Product Button Handle
  
  // Save Button
  private func didSaveNewProduct(alertString: String?, newProductViewModel: FoodCellViewModel) {
    
    if let alertString = alertString {
      // Ошибка в данных!
      ProgressHUD.showError(alertString)
    } else {
      // Если мы выбрали индекс и хотим обновить продукт то нужно обновить! Если нет индекса то создать новый!
      if let productId = updateProductId {
        var viewModel = newProductViewModel
        viewModel.id = productId
        interactor?.makeRequest(request: .updateCurrentProductInRealm(viewModel: viewModel))
      } else {
        // Создаем новый продукт!
        interactor?.makeRequest(request: .addNewProductInRealm(viewModel: newProductViewModel))
      }
      
    }
    
  }
  
  
  // Cancel Button
  @objc private func didCancelNewProduct() {
    
    AddNewElementViewAnimated.showOrDismissNewView(newElementView: newProductView, blurView: blurView, customNavBar: customNavBar, tabbarController: tabBarController!, isShow: false)
    
    newProductView.clearAllFieldsInView()
    
    pickerView.isHidden = true
    updateProductId = nil
    
    view.endEditing(true)
  }
  
  @objc private func didTapShowListCategory() {
    
    UIView.transition(with: pickerView, duration: 0.3, options: .transitionFlipFromBottom, animations: {
      self.pickerView.isHidden = !self.pickerView.isHidden
    }, completion: nil)
    
    view.endEditing(true)
  }
  
  // MARK: HeaderInSectionButtonTap
  
  func didTapButtonHeaderInSection(button: UIButton, currentExpand: Expand) {
    
    let section = button.tag
    let indexPaths = getIndexPaths(section: section)
    
    
    let isExpand = currentExpand == .expanded
    foodViewModel[section].isExpanded = !isExpand
    
    headerInSectionWorker.updateOneSection(section: section, currentSegment: currentSegment)
    
    if isExpand {
      tableView.deleteRows(at: indexPaths, with: .fade)
    } else {
      tableView.insertRows(at: indexPaths, with: .fade)
    }
    
  }
  
  private func getIndexPaths(section: Int) -> [IndexPath] {
    var indexPaths = [IndexPath]()
    
    for item in foodViewModel[section].items.indices {
      indexPaths.append(IndexPath(item: item, section: section))
    }
    return indexPaths
  }
  
  
  // MARK: Validate TextField
  private func textFiledsValidateCanSave(isCanSave: Bool) {
    
    let okButton = newProductView.okButton
    okButton.isEnabled = isCanSave
    
    if isCanSave {
      okButton.backgroundColor =  #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      okButton.setTitleColor(.white, for: .normal)
    } else {
      okButton.backgroundColor =  .lightGray
      okButton.setTitleColor(.black, for: .disabled)
    }
  }
  
  // MARK: Begind Editing NewProduct TextFields
  
  private func didBeginEditingNewProductTextFields() {
    
    pickerView.isHidden = true
  }
  
  // MARK: Cnahge SegmentController
  @objc private func didChangeSemenTableView(segmentController: UISegmentedControl) {
    
    guard let segment = Segment(rawValue: segmentController.selectedSegmentIndex) else {return}
    
    fetchProductBySegment(segment: segment)
    
  }
  
  // MARK: Go TO Meals
  
  private func fetchProductBySegment(segment: Segment) {
    
    switch segment {
      
    case .allProducts:
      // поидеии нужно заполнять массивы здесь! а дальше только по ним долбить когда приходит модель
      
      currentSegment = .allProducts
      interactor?.makeRequest(request: .fetchAllProducts)
      
      headerInSectionWorker.fillSectionExpandedArrayBySegment(viewModels: foodViewModel, segment: currentSegment)
      
    case .favorits:
      
      currentSegment = .favorits
      interactor?.makeRequest(request: .fetchProductByFavorits)
      
      headerInSectionWorker.fillSectionExpandedArrayBySegment(viewModels: foodViewModel, segment: currentSegment)
      
    case .meals:
      router?.pushMealController(headerInSectionWorker: headerInSectionWorker)
      
    }
    
    
  }
}


// MARK: Search Bar Delegate
extension FoodViewController: UISearchBarDelegate {
  
  // Сделаю фильтрацию по имени!
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    
    if searchText.isEmpty {
      fetchProductBySegment(segment: currentSegment)
    } else {
      interactor?.makeRequest(request: .filterProductByName(name: searchText))
    }

  }
  
}


// MARK: HeaderInSection

extension FoodViewController {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let isExpand = foodViewModel[section].isExpanded
    let isOnlyOneSection = foodViewModel.count > 1
    
    let category = foodViewModel[section].sectionCategory
    headerInSection = CustomHeaderInSectionView()
    
    headerInSection.setData(isExpanded: isExpand, isOnlyOneSection: isOnlyOneSection, sectionName:category,rightLabelName: "Углеводы на 100гр.", section: section, isFavoritSegment: currentSegment == .favorits)
    headerInSection.didTapHeaderSectionButton = didTapButtonHeaderInSection
    
    
    return headerInSection
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.TableView.heightForHeaderInSection
  }
}

// MARK: TableView DataSource

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    let isExpanded = foodViewModel[section].isExpanded
    return isExpanded ? foodViewModel[section].items.count : 0
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.cellID, for: indexPath) as! FoodCell
    
    let foodViewModleInSection = foodViewModel[indexPath.section].items[indexPath.row]
    
    // Простым решением будет передать здесь сегмент избранное и тогда щелкнуть в ячейке показывать еще и порцию но также потребуется изменить и хеадер
    
    cell.set(viewModel: foodViewModleInSection, isFavoritsSegment: currentSegment == .favorits)
    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return  foodViewModel.count
  }
  
  // MARK: Did Select Row
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    foodView.endEditing(true)
    
    let productId = foodViewModel[indexPath.section].items[indexPath.row].id
    // просто индекс тут не подходи наверно нужно его забирать отсюда и выпиливать продукт! или перезаписать items
    interactor?.makeRequest(request: .showNewProductView(productIdString: productId))
    updateProductId = productId
  }
  
  
  
  
}



// MARK: Swipes Row In TableView

extension FoodViewController {
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    //  В Избранном нет кнопки удалить продукт!
    switch  currentSegment {
      
    case .allProducts:
      
      let deleteAction = UIContextualAction(style: .destructive, title:  "Удалить", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        // Здесь нам нужно удалять по id и в избранное тоже по id
        let cell = tableView.cellForRow(at: indexPath) as! FoodCell
        let productID = cell.getProductID()
        self.interactor?.makeRequest(request: .deleteProduct(productId: productID))
        success(true)
      })
      return UISwipeActionsConfiguration(actions: [deleteAction])
    case .favorits:
      return UISwipeActionsConfiguration(actions: [])
    case .meals:
      return UISwipeActionsConfiguration(actions: [])
    }
    
  }
  
  // Вообщем тут нужно прописать условия Удаления ячейки из избранного!
  
  // To Favorits
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let cell = tableView.cellForRow(at: indexPath) as! FoodCell
    let favor = cell.isFavorit
    let title = favor ? "Убрать из избранного" : "В избранное"
    
    // Если мы во вкладке Избранное
    let addToFavorits = UIContextualAction(style: .normal, title:  title, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
      
      let cell = tableView.cellForRow(at: indexPath) as! FoodCell
      let productID = cell.getProductID()
      
      self.currentSection = indexPath.section
      
      self.interactor?.makeRequest(request: .updateFavoritsField(productId: productID))
      
      success(true)
    })
    addToFavorits.backgroundColor = #colorLiteral(red: 0.001269559842, green: 0.5905742049, blue: 1, alpha: 1)
    return UISwipeActionsConfiguration(actions: [addToFavorits])
  }
  
}

// MARK: Set Up Keyboard Notification
extension FoodViewController {

  private func setKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillUP), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  
  // Will UP Keyboard
  @objc private func handleKeyBoardWillUP(notification: Notification) {
    
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyBoardFrame = value.cgRectValue
    
    if addViewBottomY == nil {
      addViewBottomY = newProductView.frame.origin.y
    }
    let diff = keyBoardFrame.height + 10 - addViewBottomY
    UIView.animate(withDuration: 0.5) {
      self.newProductView.transform = CGAffineTransform(translationX: 0, y: -diff)
    }
    
  }
  // Will Hide
  @objc private func handleKeyboardDismiss(notification: Notification) {
    UIView.animate(withDuration: 0.5) {
      self.newProductView.transform = .identity
    }
  }
}

// MARK: Router Clouser

extension FoodViewController {
  // Meal update Header Worker After return from Meal
  func updateHeaderWorkerInSection(headerWorkerInSection: HeaderInSectionWorker) {
    self.headerInSectionWorker = headerWorkerInSection

  }
}



// MARK: Category Picker View

extension FoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 30
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    newProductView.setCategory(category: pickerData[row])

  }
  
  
}


