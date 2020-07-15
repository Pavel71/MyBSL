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
  case injectionPlaceCell
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
  
  // KeyBoardNotification
  
  var textFieldSelectedPoint: CGPoint!
  
  // VIews
  
  var mainView                 : CompansationObjectView!
  var navBar                   : CompObjScreenNavBar!
  var tableView                : UITableView!
  var choosePlaceInjectionView : ChoosePlaceInjectionView!
  var resultFooterView         : ResultFooterView!
  var saveButton               : UIButton!
  
  // ViewModel
  
  var viewModel: NewCompObjViewModel!
  var compansationObjectRealm: CompansationObjectRelam?
  
  //Clousers
  
  
  var didPassSignalToReloadMainScreen     : EmptyClouser?
  // MARK: Object lifecycle
  
  
  init(compansationObjectRealm: CompansationObjectRelam? = nil) {
    super.init(nibName: nil, bundle: nil)
    self.compansationObjectRealm = compansationObjectRealm
    setup()
    
  }
  
  deinit {
    print("Deinit New Screeen VC")
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
    
    
    // Если объект пришел то зпусти заполнение модели данными
    if let compObjRealm = compansationObjectRealm {
      
      interactor?.makeRequest(request: .updateCompansationObject(compObjRealm: compObjRealm))

    } else {
      // если объекта нет то запусти пустой экран
      interactor?.makeRequest(request: .getBlankViewModel)
    }
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setKeyboardNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: Display Data
  
  func displayData(viewModel: NewCompansationObjectScreen.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .setViewModel(let viewModel):
      
      setViewModel(viewModel: viewModel)
      
    case .passSignalToReloadMainScreen:
      didPassSignalToReloadMainScreen!()

    
    }
  }
  
  // MARK: Set View Model
  
  private func setViewModel(viewModel: NewCompObjViewModel) {
    self.viewModel = viewModel
    resultFooterView.setViewModel(viewModel: viewModel.resultFooterVM)
    saveButton.isEnabled = viewModel.isValidData
  }
  
}

// MARK: SetpUpViews

extension NewCompansationObjectScreenViewController {
  
  private func setUpViews() {
    
    mainView                 = CompansationObjectView(frame: view.frame)
    navBar                   = mainView.navBar
    tableView                = mainView.tableView
    choosePlaceInjectionView = mainView.choosePlaceInjectionsView
    resultFooterView         = mainView.resultFooterView
    saveButton               = mainView.navBar.saveButton
    
    confugireTableView()
    
    view.addSubview(mainView)

    
    setViewClousers()
  }
  
  
  
  private func confugireTableView() {
    
    tableView.allowsSelection      = false
    tableView.keyboardDismissMode  = .interactive
    tableView.delegate             = self
    tableView.dataSource           = self
    tableView.tableFooterView      = UIView()
    tableView.separatorStyle       = .none

    
    registerCell()
  }
  
  private func registerCell() {
    tableView.register(SugarCell.self, forCellReuseIdentifier: SugarCell.cellId)
    tableView.register(AddMealCell.self, forCellReuseIdentifier: AddMealCell.cellId)
    tableView.register(InjectionPlaceCell.self, forCellReuseIdentifier: InjectionPlaceCell.cellId)
    tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.cellID)
  }
  
  private func updateSugarCell() {
    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    // Заодно проверим не нужна ли нам 3 ячейка
    updateUnjectionPlaceCell()
  }
  
  private func updateMealCell() {
    tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    // Заодно проверим не нужна ли нам 3 ячейка
    updateUnjectionPlaceCell()
  }
  
  private func updateUnjectionPlaceCell() {
    tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
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
    choosePlaceInjectionView.didTapCloseButton = {[weak self] in
      
      self?.didShowChooseInjectionPlaceView(isShow: false)
    }
    
    choosePlaceInjectionView.didChooseInjectionsPlace = {[weak self] place in
      self?.interactor?.makeRequest(request: .updatePlaceInjection(place: place))
      self?.updateUnjectionPlaceCell()
      self?.didShowChooseInjectionPlaceView(isShow: false)
    }
    
    
    
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
      case .injectionPlaceCell:
        return configureInjectionPlaceCell(indexPath: indexPath)
      
      case .none: return UITableViewCell()
    }
    
  }
  
 
  
}

//MARK: Set Cell Clousers

extension NewCompansationObjectScreenViewController {
  
  // Injection Cell Clouser
  
  private func setInjectionCellClousers(cell: InjectionPlaceCell) {
    
    cell.didTapChooseButton = {[weak self] in
      
      self?.didShowChooseInjectionPlaceView(isShow: true)
    }
  }
  
  // Shugar Cell Clouser
  
  private func setSugarCellClouser(cell:SugarCell ) {
    cell.passCurrentSugarClouser = {[weak self] text in
      self?.catchCurrentSugarString(text:text)
    }
    
    cell.didTapRobotInfoButton = {[weak self] in
      self?.showAlertController(title: "Расчет робота", message: "\(floatTwo: self?.viewModel.sugarCellVM.correctionSugarKoeff ?? 0) Дозировка на компенсацию сахара для вас!")
    }
    
    cell.didTapCurrentSugarButton = {[weak self] in
      self?.showAlertController(title: "Ваш сахар на данный момент", message: "Сделайте замер сахара в крови и заполните поле!")
    }
    
    cell.didTapCorrectionInsulinButton = {[weak self] in
      self?.showAlertController(title: "Коррекция инсулином", message: "Корректировка высокого сахар инсулином")
    }
    
    cell.didUserSetCopmansationInsulin = {[weak self] userInsuliData in
      self?.interactor?.makeRequest(request: .passCopmansationSugarInsulin(compInsulin: userInsuliData))
    }
    
  }
  
  // Meal Cell Clousers
  
  private func setAddMealCellClouser(cell: AddMealCell) {
    
    cell.didPassSwitcherValueClouser = { [weak self] isOn in
      self?.catchAddMealCellSwitcherValue(isOn: isOn)
    }
    
    cell.showMenuController = {[weak self] in
      self?.showMenuController()
    }
    cell.didTapMealButtonClouser = {[weak self] in
      self?.showAlertController(title: "Добавьте обед", message: "Ваши продукты")
    }
    
    
    setProductListControllerCLousers(productListVC: cell.productListViewController)
    
  }
  
  
  // Product List Clousers
  private func setProductListControllerCLousers(productListVC: ProductListInDinnerViewController) {
    
    productListVC.didSelectTextFieldCellClouser = {[weak self] textfield in
      self?.didSelectTextFieldInProductList(textField: textfield)
    }
    
    productListVC.didPortionTextFieldEndEditingToDinnerController = {[weak self] portion, index in

      self?.interactor?.makeRequest(request: .updatePortionInProduct(portion: portion,index: index))
//      self?.updateMealCell()
    }
      
    productListVC.didInsulinTextFieldEndEditingToDinnerController = {[weak self] insulin,index in
      // Мы делаем обновление ячейки! Что в целом не обязательно делать! ТОгда не будет слитать Клавиатура
      self?.interactor?.makeRequest(request: .updateInsulinByPerson(insulin: insulin, index: index))
//      self?.updateMealCell()
    }
    
    productListVC.didDeleteProductClouser = {[weak self] products in
      self?.deleteProducts(products: products)
    }
    productListVC.didTapDoneButton = {[weak self] in
      self?.updateMealCell()
    }
    
    
  }
}


// MARK: Catch  Clousers

extension NewCompansationObjectScreenViewController {
  
  private func didShowChooseInjectionPlaceView(isShow: Bool) {
    ChoosePlaceInjectionsAnimated.showView(
           blurView: (self.mainView.blurView),
           choosePlaceInjectionView: (self.mainView.choosePlaceInjectionsView),
           isShow: isShow)
  }
  
  // NAV Bar Clouser
  private func didTapNavBarBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Save Compansation Object VM
  
  private func didTapNavBarSaveButton() {
    
    // Или не липить тут херни а взять просто и создать в интеракторе DayRealmManager и сохранить
    
    interactor?.makeRequest(request: .saveCompansationObjectInRealm(viewModel: viewModel))
    
//    didPassViewModelToSaveInRealm!(viewModel)
    didTapNavBarBackButton()
    
  }
  
  // SUgarTextField RightButton
  
  private func catchCurrentSugarString(text: String) {
    
    interactor?.makeRequest(request: .passCurrentSugar(sugar: text))
    
    updateSugarCell()
    updateMealCell()
    
  }
  // Meal cell Switcher
  private func catchAddMealCellSwitcherValue(isOn: Bool) {
    // Здесь я посылаю сигнал нужно ли мне показывать модель с продукт листом?
    
    interactor?.makeRequest(request: .passIsNeedProductList(isNeed: isOn))
    updateMealCell()
  }
  
  
  
}

// MARK: Configure Cells
extension NewCompansationObjectScreenViewController {
  
  private func configureResultCell(indexPath: IndexPath) -> ResultCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.cellID, for: indexPath) as! ResultCell
    
    return cell
    
  }
  
  // Injection Cell
  private func configureInjectionPlaceCell(indexPath: IndexPath) -> InjectionPlaceCell {
  
    let cell = tableView.dequeueReusableCell(withIdentifier: InjectionPlaceCell.cellId, for: indexPath) as! InjectionPlaceCell
    cell.setViewModel(viewModel: viewModel.injectionCellVM)
    setInjectionCellClousers(cell: cell)
    return cell
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
}




// MARK: Height
extension NewCompansationObjectScreenViewController {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch NewCompansationVCCellsCase(rawValue: indexPath.row) {
        
      case .sugarCell:
        
        return SugarCellHeightWorker.getSugarCellHeight(cellState: viewModel.sugarCellVM.cellState)
        
      case .addMealCell:
        
        let count = viewModel.addMealCellVM.dinnerProductListVM.productsData.count
        return ProductListCellHeightWorker.getAddmealCellHeight(
          cellState    : viewModel.addMealCellVM.cellState,
          productCount : count)
        
      case .injectionPlaceCell:
        return 100
        
      case .none: return 100
    }
    
  }
  
}


// MARK: ProductListTextField  Selected

extension NewCompansationObjectScreenViewController {
  
  private func didSelectTextFieldInProductList(textField: UITextField) {
    
    setTextFiedlPoint(textField: textField)
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
    updateMealCell()

    
  }
  // MARK: Delete
  func deleteProducts(products: [ProductRealm]) {
    
    interactor?.makeRequest(request: .deleteProductsFromProductList(products: products))
    updateMealCell()
    
  }
  
  
  
}

// MARK: Work with Keyaboard Notification

extension NewCompansationObjectScreenViewController {
  
  
  
  // Определим какой текстфилд выбран
  private func setTextFiedlPoint(textField: UITextField) {

    let point = mainView.convert(textField.center, from: textField.superview!)
    textFieldSelectedPoint = point
    
  }
  
  private func setKeyboardNotification() {
     
     NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillUP), name: UIResponder.keyboardWillShowNotification, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)

   }

   
   // Will UP Keyboard
   @objc private func handleKeyBoardWillUP(notification: Notification) {

     guard let keyBoardFrame = getKeyboardFrame(notification: notification) else {return}
     animateMealViewThanSelectTextField(isMove: true, keyBoardFrame: keyBoardFrame)

   }
   // Will Hide
   @objc private func handleKeyboardDismiss(notification: Notification) {
     
     guard let keyBoardFrame = getKeyboardFrame(notification: notification) else {return}
     
     animateMealViewThanSelectTextField(isMove: false, keyBoardFrame: keyBoardFrame)
     

   }
   
   private func getKeyboardFrame(notification: Notification) -> CGRect? {
     guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return nil}
     return value.cgRectValue
   }
   
   // Than select TextFiedl on TableView KeyBoardFrame
   
   private func animateMealViewThanSelectTextField(isMove: Bool, keyBoardFrame: CGRect) {

     guard let textFieldPointY = textFieldSelectedPoint?.y else {return}
     
     let saveDistance = view.frame.height - keyBoardFrame.height - Constants.KeyBoard.doneToolBarHeight
     
     let diff:CGFloat =  textFieldPointY > saveDistance ? textFieldPointY - saveDistance : 0
     
   
     UIView.animate(withDuration: 0.3) {
       self.mainView.transform = isMove ? CGAffineTransform(translationX: 0, y: -diff) : .identity
     }
     

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

