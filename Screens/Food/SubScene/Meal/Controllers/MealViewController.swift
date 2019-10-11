//
//  MealViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 29/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift
import ProgressHUD

protocol MealDisplayLogic: class {
  func displayData(viewModel: Meal.Model.ViewModel.ViewModelData)
}

class MealViewController: UIViewController, MealDisplayLogic {
  
  var interactor: MealBusinessLogic?
  var router: (NSObjectProtocol & MealRoutingLogic)?
  // Может быть проблема в токене хотя я его выключаю в диссапиар!
  var realmObserverTokken: NotificationToken!
  
  
  // TableView Vie Model
  var sectionViewModelList: [SectionMealViewModel] = [] {
    
    didSet {
      if sectionViewModelList.count == 1 {
        // Если мы хотим просто список то раскрой его сразу
        sectionViewModelList[0].isExpanded = true
      }
    }
  }
  
  // Это нужно для анимации
  var addViewBottomY: CGFloat!
  var isShowingNewMealViewNow = false
  
  // Animate Slide Menu
  //  var isShowSlideMenuProductsList = false
  
  var menuState: State = .closed
  
  var textFieldSelectedPoint: CGPoint?
  
  // MealIdThanAddProduct
  var mealIdByAddPorduct: String?
  
  var mealView: MealView!
  var customNavBar: CustomNavBar!
  var newMealView: NewMealView!
  var blurView: UIVisualEffectView!
  var tableView: UITableView!
  
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
  
  var pickerView: UIPickerView!
  
  var pickerData:[String] = [] {
    didSet {
      pickerView.reloadAllComponents()
    }
  }
  
  // Header in Section
//  var headerInSectionView: CustomHeaderInSectionView!
  //  weak var headerInSectionWorker: HeaderInSectionWorker?
  
  var headerInSectionWorker: HeaderInSectionWorker // пока попробую просто этот обЪект
  
  // CLousers
  
  // передаем информацию о том какие секции открыты в обедах
  var didUpdateHeaderWorkerInFoodViewController:((HeaderInSectionWorker) -> Void)?
  // Просим ContainerViewController добавить другой контроллер
  var didShowMenuProductsListViewControllerClouser: ((CGFloat) -> Void)?
  // Menu ANimated
  var didPanGestureValueChange: ((UIPanGestureRecognizer) -> Void)?
  
  // MARK: Object lifecycle
  
  init(headerInSectionWorker: HeaderInSectionWorker) {
    
    self.headerInSectionWorker = headerInSectionWorker
    super.init(nibName: nil, bundle: nil)
    setup()
    
  }
  
  deinit {
    print("Deinit Meal Controller")
  }
  
  // MARK: Setup
  
  private func setup() {
    
    let viewController        = self
    let interactor            = MealInteractor()
    let presenter             = MealPresenter()
    let router                = MealRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()


    setUpView()
    interactor?.makeRequest(request: .showListMealsBySection(isDefaultList: headerInSectionWorker.isDefaultListMeal))

  }
  // Set Observer Tokken
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    interactor?.makeRequest(request: .setRealmObserver)
    setKeyboardNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    realmObserverTokken.invalidate()
    NotificationCenter.default.removeObserver(self)
  }
  
 
  
  //  MARK: Display Data
  func displayData(viewModel: Meal.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
      
    case .setViewModel(let viewModel):
      
      let updateBySectionsViewModel = headerInSectionWorker.updateViewModelByExpandSection(newViewModel: viewModel, with: .meals) as! [SectionMealViewModel]
      
      self.sectionViewModelList = updateBySectionsViewModel
      
      reloadTable()
      
    case .passRealmObserverTokken(let realmTokken):
      
      realmObserverTokken = realmTokken
      
    // Пришла моделька для Нового Обеда!
    case .setNewMealViewModel(let viewModel):
      
      pickerData = viewModel.listTypeOfMeal
      newMealView.setViewModel(viewModel: viewModel)
      
      isShowingNewMealViewNow = true
      AddNewElementViewAnimated.showOrDismissNewView(newElementView: newMealView, blurView: blurView, customNavBar: customNavBar, tabbarController: tabBarController!, isShow: isShowingNewMealViewNow)
      
    // Show Allerts
    case .showAlertAfterAddMeal(let isSuccessAdd, let isUpdateMeal):
      
      // Значит мы обновляли обед
      if isUpdateMeal {
        showUpdateMealAlertString(success: isSuccessAdd)
      } else {
        showAddNewMealAlertString(success: isSuccessAdd)
      }
      
    }
    
  }
  
  private func reloadTable() {
    
    UIView.transition(with: tableView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
      self.tableView.reloadData()
    }, completion: nil)
  }
  
  // MARK: Get Alert String
  
  private func showUpdateMealAlertString(success: Bool) {
    
    if success {
      cancelNewMealView()
      ProgressHUD.showSuccess("Обед обновленн!")
    } else {
      ProgressHUD.showError("Ошибка которая никогда не произойдет")
    }
  }
  
  private func showAddNewMealAlertString(success: Bool) {
    
    if success {
      cancelNewMealView()
      ProgressHUD.showSuccess("Новый обед созданн!")
    } else {
      ProgressHUD.showError("Такое имя обеда уже есть!")
    }
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set UP Views

extension MealViewController {
  
  private func setUpView() {
    
    //    view.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    
    mealView = MealView(frame: view.frame)
    view.addSubview(mealView)
    
    configureCustomNavBar()
    configureNewMealView()
    configurePickerView()
    configureBlurView()
    confirmTableView()
    
  }
  
  // Custom Nav Bar
  
  private func configureCustomNavBar() {
    
    customNavBar = mealView.customNavBar
    
    customNavBar.backButton.addTarget(self, action: #selector(didTapNavBackButton), for: .touchUpInside)
    
    
    customNavBar.addButton.addTarget(self,action: #selector(didTapAddNewMealButton), for: .touchUpInside)
    
    customNavBar.didTapChangeSectionViewButton = {[weak self] in self?.didTapShowSectionTypeMealButton()}
    
    
    customNavBar.searchBar.delegate = self
    
  }
  
  // New Meal View
  private func configureNewMealView() {
    
    newMealView = mealView.newMealView
    
    // либо тут вешать тарегты либо открывать клоузеры тут и сейвить их
    
    newMealView.cancelButton.addTarget(self, action: #selector(didTapCancelButtonInNewMealView), for: .touchUpInside)
    
    newMealView.okButton.addTarget(self, action: #selector(didTapSaveNewMealButton), for: .touchUpInside)
    
    newMealView.categoryWithButtonTextFiled.listButton.addTarget(self, action: #selector(didTapShowTypeOfMealsButton), for: .touchUpInside)
    
    newMealView.mealValidator.isValidCallBack = { [weak self] (isSave) in
      self?.textFiledsValidateCanSave(isCanSave: isSave)
    }
    
  }
  
  // Picker View
  private func configurePickerView() {
    
    pickerView = mealView.pickerView
    pickerView.dataSource = self
    pickerView.delegate = self
    
  }
  // Blur
  private func configureBlurView() {
    
    blurView = mealView.blurView
    mealView.didTapBlurViewClouser = { [weak self] in self?.didTapOnBlur() }
  }
  
  // TableView
  private func confirmTableView() {
    
    tableView = mealView.tableView
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.cellId)
    
    tableView.keyboardDismissMode = .interactive
    tableView.tableFooterView = UIView()
    
    tableView.separatorStyle = .none
    
  }
}




// MARK: DID Tap Some Buttons

extension MealViewController {
  
  // Tap On Blur
  private func didTapOnBlur() {
    cancelNewMealView()
  }
  
  // NewMealView
  
  @objc private func didTapCancelButtonInNewMealView() {
    
    cancelNewMealView()
  }
 
  private func cancelNewMealView() {
    
    isShowingNewMealViewNow = false
    AddNewElementViewAnimated.showOrDismissNewView(newElementView: newMealView, blurView: blurView, customNavBar: customNavBar, tabbarController: tabBarController!, isShow: isShowingNewMealViewNow)
    
    newMealView.clearAllFieldsInView()
    if !pickerView.isHidden {
      pickerView.isHidden = true
    }
    view.endEditing(true)
  }
  
  @objc private func didTapSaveNewMealButton() {
    
    let newMealViewModel = newMealView.getViewModel()
    interactor?.makeRequest(request: .addOrUpdateNewMeal(viewModel: newMealViewModel))
  }
  
  @objc private func didTapShowTypeOfMealsButton() {
    
    hiddenPickerView()
    
    view.endEditing(true)
  }
  
  private func hiddenPickerView() {
    
    UIView.transition(with: pickerView, duration: 0.3, options: .transitionFlipFromBottom, animations: {
      self.pickerView.isHidden = !self.pickerView.isHidden
    }, completion: nil)
  }
  
  
  
  // Validate TextField
  private func textFiledsValidateCanSave(isCanSave: Bool) {
    
    let okButton = newMealView.okButton
    okButton.isEnabled = isCanSave
    
    if isCanSave {
      okButton.backgroundColor =  #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      okButton.setTitleColor(.white, for: .normal)
    } else {
      okButton.backgroundColor =  .lightGray
      okButton.setTitleColor(.black, for: .disabled)
    }
  }
  
  
  // Custom Nav Bar Add New Meal
  
  @objc private func didTapAddNewMealButton() {
    
    interactor?.makeRequest(request: .showNewMealView(mealId: nil))
    
  }
  
  // Back Button
  @objc private func didTapNavBackButton() {
    
    didUpdateHeaderWorkerInFoodViewController!(headerInSectionWorker)
    navigationController?.popViewController(animated: true)
    
  }
  
  // Show List Category CustomNavBar
  
  private func didTapShowSectionTypeMealButton() {
    
    self.headerInSectionWorker.changeIsDefaultlistByCategory(segment: .meals)
    
    let getIsDefaultList = headerInSectionWorker.getIsDefaultListBySegment(segment: .meals)
    self.interactor?.makeRequest(request: .showListMealsBySection(isDefaultList: getIsDefaultList))
    

    self.headerInSectionWorker.fillSectionExpandedArrayBySegment(viewModels: sectionViewModelList, segment: .meals) // Запомнил кол-во секций
    
    
  }
  
  // Expanded Button in Cell
  
  @objc private func didTapExpandedButton(button: UIButton) {
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: button) else {return}

    let mealID = sectionViewModelList[indexPath.section].meals[indexPath.row].mealId!
    interactor?.makeRequest(request: .expandedMeal(mealId: mealID))
    
  }
  
  
  
  // HHeader in Section Button
  
  func didTapHeaderSectionButton(button: UIButton, currentExpand: Expand) {
    
    let section = button.tag
    let indexPaths = getIndexPaths(section: section)
    
    let isExpand = currentExpand == .expanded
    
    self.sectionViewModelList[section].isExpanded = !isExpand
    
    headerInSectionWorker.updateOneSection(section: section, currentSegment: .meals)
    
    if isExpand {
      tableView.deleteRows(at: indexPaths, with: .fade)
    } else {
      tableView.insertRows(at: indexPaths, with: .fade)
    }
    
  }
  
  private func getIndexPaths(section: Int) -> [IndexPath] {
    var indexPaths = [IndexPath]()
    
    for item in sectionViewModelList[section].meals.indices {
      indexPaths.append(IndexPath(item: item, section: section))
    }
    return indexPaths
  }
  
  
  
}



// MARK: Product List Add Delete Update Show Menu ProductListController

extension MealViewController {
  
  private func didChangePortionSizeProductListCell(portion: Int,row: Int,mealId: String) {
    
    interactor?.makeRequest(request: .updateProductPortionFromMeal(mealId: mealId, rowProduct: row, portion: portion))
    
  }
  
  // Delete product From Meal
  private func deleteProductFromMeal(rowProduct: Int, mealId: String) {
    interactor?.makeRequest(request: .deleteProductFromMeal(mealId: mealId, rowProduct: rowProduct))
  }
  
  // MARK: Show MenuView And Calculate Distance
  
  private func addNewproductInMeal(mealId: String, button: UIButton) {
    
    // Мне нужно получить координаты ячейки где эта кнопка
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: button) else {return}
    
    let cell = tableView.cellForRow(at: indexPath)!
    
    let mealViewOffsetY = CalculateDistance.calculateDistanceMealCellToMenuController(cellY: cell.frame.origin.y)
    
    mealIdByAddPorduct = mealId
    
    // теперь здесь мне нужно прокинуть координаты
    didShowMenuProductsListViewControllerClouser!(mealViewOffsetY)
    
  }
  
  
}

// MARK: Catch Product From Menu FoodList

extension MealViewController {
  
  func addProductInMeal(productId: String) {
    
    guard let mealId = mealIdByAddPorduct else {return}
    interactor?.makeRequest(request: .addProductInMeal(mealId: mealId, productId: productId))
  }
  
}

// MARK: Set Up Keyboard Notification
extension MealViewController {
  
  private func setKeyboardNotification() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillUP), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  
  // Will UP Keyboard
  @objc private func handleKeyBoardWillUP(notification: Notification) {
    
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyBoardFrame = value.cgRectValue
    
    // Теперь мне нужно сорвать все mealView! из за того что мы выбираем только portionTextField для редактирования
    
    if isShowingNewMealViewNow {
      
      animateNewMealViewOnKeyabordShow(isMove: true, keyBoardFrame: keyBoardFrame)
    } else {
      animateMealViewThanSelectTextFieldOnTableView(isMove: true, keyBoardFrame: keyBoardFrame)
    }
    
    
    
  }
  // Will Hide
  @objc private func handleKeyboardDismiss(notification: Notification) {
    
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyBoardFrame = value.cgRectValue
    
    if isShowingNewMealViewNow {
      animateNewMealViewOnKeyabordShow(isMove: false, keyBoardFrame: keyBoardFrame)
    } else {
      animateMealViewThanSelectTextFieldOnTableView(isMove: false, keyBoardFrame: keyBoardFrame)
    }
    
  }
  
  // Than select TextFiedl on TableView KeyBoardFrame
  
  private func setTextFiedlPoint(textField: UITextField) {
    
    let point = mealView.convert(textField.center, from: textField.superview!)
    
    textFieldSelectedPoint = point
  }
  
  private func animateMealViewThanSelectTextFieldOnTableView(isMove: Bool, keyBoardFrame: CGRect) {
    
    guard let textFieldPointY = textFieldSelectedPoint?.y else {return}
    

    let saveDistance = view.frame.height - keyBoardFrame.height - Constants.KeyBoard.doneToolBarHeight
    
    
    let diff:CGFloat =  textFieldPointY > saveDistance ? textFieldPointY - saveDistance : 0

    UIView.animate(withDuration: 0.3) {
      self.mealView.transform = isMove ? CGAffineTransform(translationX: 0, y: -diff) : .identity
    }
    
    
  }
  
  
  // NewMeal View Animated Keyaboard show
  private func animateNewMealViewOnKeyabordShow(isMove: Bool, keyBoardFrame: CGRect) {
    
    if addViewBottomY == nil {
      addViewBottomY = newMealView.frame.origin.y
    }
    let diff = keyBoardFrame.height + 10 - addViewBottomY // нижняя гранциа newMealView
    
    UIView.animate(withDuration: 0.5) {
      self.newMealView.transform = isMove ? CGAffineTransform(translationX: 0, y: -diff) : .identity
    }
    
  }
}


// MARK: TableView Delegate,DataSource

extension MealViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return sectionViewModelList.count
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    let isSectionExpand = sectionViewModelList[section].isExpanded
    return isSectionExpand ? sectionViewModelList[section].meals.count : 0
    
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.cellId, for:  indexPath) as! MealCell
    
    setTargetExpandButton(cell: cell, indexPath:indexPath)
    setProductListCLousers(cell: cell)
    
    let meal = sectionViewModelList[indexPath.section].meals[indexPath.row]
    cell.setViewModel(viewModel: meal)
    
    return cell
  }
  
  // MealCellExpandButton
  private func setTargetExpandButton(cell:MealCell,indexPath: IndexPath) {
    cell.expandedButton.addTarget(self, action: #selector(didTapExpandedButton), for: .touchUpInside)
    cell.expandedButton.tag = indexPath.row
  }
  
  // Product List Clousers
  private func setProductListCLousers(cell:MealCell) {
    
    cell.productListViewController.didSelectTextFieldCellClouser = { [weak self] textField in self?.setTextFiedlPoint(textField: textField) }
    
    cell.productListViewController.didChangePortionTextFieldClouser = {[weak self] portion,row,mealId in
      self?.didChangePortionSizeProductListCell(portion: portion, row: row, mealId: mealId) }
  
    cell.productListViewController.didDeleteProductFromMealClouser = {[weak self] rowProduct, mealId in self?.deleteProductFromMeal(rowProduct: rowProduct, mealId: mealId) }
    
    cell.didAddNewProductInmeal = {[weak self] mealId,button in self?.addNewproductInMeal(mealId: mealId,button:button) }
    

    
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    let cell = tableView.cellForRow(at: indexPath) as! MealCell
    
    interactor?.makeRequest(request: .showNewMealView(mealId: cell.getMealId()))
    
  }
  
  
  // Попробую расчитать здесь размер яейки чтобы не было проблем с констрайнтами!
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    // Как юы здесь получить размер label в ячейки!
    
    let isExpanded = sectionViewModelList[indexPath.section].meals[indexPath.row].isExpanded
    let countProductInMeal = sectionViewModelList[indexPath.section].meals[indexPath.row].products.count
    let mealName = sectionViewModelList[indexPath.section].meals[indexPath.row].name
    
    let cellHeight = CalculateHeightView.calculateMealCellHeight(isExpanded: isExpanded, countRow: countProductInMeal, mealName: mealName)
    
    return cellHeight
    
    
  }
  
}

// MARK: Header In Section

extension MealViewController {
  
  // Header In Section
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerInSectionView = CustomHeaderInSectionView()
    
    let isExpand = sectionViewModelList[section].isExpanded
    let isOnlyOneSection = sectionViewModelList.count > 1
    let sectionName = sectionViewModelList[section].sectionName
    

    headerInSectionView.setData(isExpanded: isExpand, isOnlyOneSection: isOnlyOneSection, sectionName: sectionName,section: section)
    
    // Нужно правельно оформлять клоузер
    headerInSectionView.didTapHeaderSectionButton = { [weak self] button, expand in self?.didTapHeaderSectionButton(button: button, currentExpand: expand) }
    
    return headerInSectionView
    
  }
  
  // Height Header In Section
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.TableView.heightForHeaderInSection
  }
  
}

// MARK: Swipe Leadeing - Delete cell!
extension MealViewController {
  
  
  // Delete Row
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить обед") { (action, view, succsess) in
      
      let cell = tableView.cellForRow(at: indexPath) as! MealCell
      let mealId = cell.getMealId()
      
      self.interactor?.makeRequest(request: .deleteMeal(mealId: mealId))
      
      succsess(true)
    }
    // Удаляет сам по индексу и не андо парится!
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
}

// MARK: PickerView Delegate Add New Meal!

extension MealViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
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
    newMealView.setCategory(typeOfMeal: pickerData[row])
    
  }
  
  
}

// MARK: SearchBar Delegate

extension MealViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText.isEmpty {
      
      interactor?.makeRequest(request: .showListMealsBySection(isDefaultList: headerInSectionWorker.isDefaultListMeal))
    } else {
      interactor?.makeRequest(request: .searchMealByname(character: searchText))
    }
    
    print(searchText)
  }
}

// MARK: Show Menu Animatable

extension MealViewController: ShowMenuAnimatable {

  
  

  func setUppanGestureRecogniser() {
    slideMenuPanGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeMenu))
//    slideMenuPanGestureRecogniser.delegate = self
    view.addGestureRecognizer(slideMenuPanGestureRecogniser)
  }
  
  @objc private func handleSwipeMenu(gesture: UIPanGestureRecognizer) {
    didPanGestureValueChange!(gesture)
  }
  
  func removeGestureRecogniser() {
    view.removeGestureRecognizer(slideMenuPanGestureRecogniser)
  }
  
  // Отключаем Горизонтальное листание
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return abs((slideMenuPanGestureRecogniser.velocity(in: slideMenuPanGestureRecogniser.view)).y) > abs((slideMenuPanGestureRecogniser.velocity(in: slideMenuPanGestureRecogniser.view)).x)

  }
  
  
}


