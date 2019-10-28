//
//  MainViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol MainDisplayLogic: class {
  func displayData(viewModel: Main.Model.ViewModel.ViewModelData)
}






class MainViewController: UIViewController, MainDisplayLogic,MainControllerInContainerProtocol {
  

  
  var menuState: State = .closed
  
  
  var interactor: MainBusinessLogic?
//  var router: (NSObjectProtocol & MainRoutingLogic)?
  
  
  var mainView: MainView!
  var tableView: UITableView!
  var listTrainsViewController = ListTrainsViewController(style: .plain)
  
  // Место где выбран TextField
  var textFieldSelectedPoint: CGPoint?
  
  
  // Здесь должна быть VIewModel которая содержит в себе данные для первой ячейки так и для второй ячейки
  
  // PanGesture Recogniser
  // в Данном случае Distance у нас будет статичен
  let distanceTranslateMainController = (Constants.screenHeight / 2) - Constants.Main.Cell.headerCellHeight - Constants.customNavBarHeight - Constants.Main.DinnerCollectionView.shugarViewInCellHeight
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
  
  // CLousers
  
  // To ContainerController
  var didShowMenuProductsListViewControllerClouser: ((CGFloat) -> Void)?
  var didPanGestureValueChange: ((UIPanGestureRecognizer) -> Void)?
  
  // ViewModel
  var mainViewModel: MainViewModel!
  // Validator
  // Валидируем данные с ячейки dinnerCOllectionView
  
  let dinnerValidator = DinnerViewModelValidator()
  
  // MARK: Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  
  
  
  // MARK: Setup
  
  private func setup() {
    
    let viewController        = self
    let interactor            = MainInteractor()
    let presenter             = MainPresenter()
//    let router                = MainRouter()
    viewController.interactor = interactor
//    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
//    router.viewController     = viewController
  }
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("View Did Load")

    setValidatorClouser()
    
    setUpMainView()
    interactor?.makeRequest(request: .getViewModel)

  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setKeyboardNotification()
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  

  
  
  
  
  // MARK: Display
  
  func displayData(viewModel: Main.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .setViewModel(let viewModel):

      print("Set ViewModel")
      mainViewModel = viewModel
      
      tableView.reloadData()

    default:break
    }
    
    
    
  }
  
  private func reloadMiddleCell() {
    tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .none)
  }
  private func reloadFooterCell() {
    tableView.reloadRows(at: [IndexPath(item: 2, section: 0)], with: .none)
  }
  

  
  private func getFirstDinnerCell() -> DinnerCollectionViewCell {
    
    let cell = getMainMiddleCell()
    
    let indexNewDinner = mainViewModel.dinnerCollectionViewModel.count - 1
    
    let dinnerItem = cell.dinnerCollectionViewController.collectionView.cellForItem(at:  IndexPath(item: indexNewDinner, section: 0))  as! DinnerCollectionViewCell
    
    return dinnerItem
  }
  
  private func getMainFooterCell() -> MainTableViewFooterCell {
    let  cell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! MainTableViewFooterCell
    return cell
  }
  
  private func getMainMiddleCell() -> MainTableViewMiddleCell {
    return tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! MainTableViewMiddleCell
  }
  
  
  
  private func closeMenu() {
    if menuState == .open {
      didShowMenuProductsListViewControllerClouser!(distanceTranslateMainController)
    }
  }
  
  private func setValidatorClouser() {
    dinnerValidator.isValidCallBack = {[weak self] succes in
      
      
      let footerCell = self?.getMainFooterCell()
      footerCell?.saveButton.isEnabled = succes
      
    }
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}

// MARK: Configure Main View

extension MainViewController {
  
  // Нужен CustomNavBar но пока просто с title
  
  private func setUpMainView() {
    
    mainView = MainView(frame: view.frame)
    view.addSubview(mainView)
    
    configureTableView()
    
    setSomeViewClousers()
    
  }
  
  private func configureTableView() {
    
    tableView = mainView.tableView
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.showsVerticalScrollIndicator = false
    tableView.keyboardDismissMode = .interactive
    tableView.allowsSelection = false
    
    
    tableView.register(MainTableViewHeaderCell.self, forCellReuseIdentifier: MainTableViewHeaderCell.cellId)
    tableView.register(MainTableViewMiddleCell.self, forCellReuseIdentifier: MainTableViewMiddleCell.cellId)
    tableView.register(MainTableViewFooterCell.self, forCellReuseIdentifier: MainTableViewFooterCell.cellId)
  }
  
  private func setSomeViewClousers() {
    setMainViewClousers()
    setListTrainsViewControllerClouser()
  }
  
  private func setMainViewClousers() {
    mainView.choosePlaceInjectionsView.didTapCloseButton = {[weak self] in
      self?.didTapClouseChoosePlaceInjectionView()
    }
    
    mainView.choosePlaceInjectionsView.didChooseInjectionsPlace = {[weak self] title in
      self?.didChooseNewPlaceInjections(namePlace: title)
    }
  }
  
  private func setListTrainsViewControllerClouser() {
    
    listTrainsViewController.didSelectCell = {[weak self] nameTrain in
      self?.didSelectListTrainViewControllerCell(name: nameTrain)
    }
  }
  
  
  
  
}


// MARK: TableView Delegate DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
      
    case 0:
      return configureHeaderCell()
      
    case 1:
      
      return configureMiddleCell()
      
    case 2:
      return configureFooterCell()
      
    default:break
      
    }
    
    return UITableViewCell()
  }
  
  private func configureHeaderCell() -> MainTableViewHeaderCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewHeaderCell.cellId) as! MainTableViewHeaderCell
    
    cell.setViewModel(viewModel: mainViewModel.headerViewModelCell)
    return cell
    
    
  }
  

  
  private func configureMiddleCell() -> MainTableViewMiddleCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewMiddleCell.cellId) as! MainTableViewMiddleCell
    
    cell.setViewModel(viewModel: mainViewModel.dinnerCollectionViewModel)
    
    setMiddleCellClouser(cell: cell)

    return cell
  }
  
  // MARK: Set Clousers By Dinner
  
  private func setMiddleCellClouser(cell: MainTableViewMiddleCell) {
    
    
    setShugarSetViewClousers(cell)
    setWillActivityClousers(cell)
    setChoosePlaceInjectiosnClousers(cell)
    setProductListInDinnerClousers(cell)
   

    
  }
  
  
  private func configureFooterCell() -> MainTableViewFooterCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewFooterCell.cellId) as! MainTableViewFooterCell
    
    cell.setViewModel(viewModel: mainViewModel.footerViewModel)
    setClousersByFooterCell(cell)
    return cell
  }
  
  private func setClousersByFooterCell(_ cell:MainTableViewFooterCell) {
    cell.didTapSaveButtonClouser = {[weak self] in
      print("Tap Save button")
      self?.tapFooterSaveButton()
    }
  }
  
  
  // Height Cells
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
      
    case 0:
  
      return Constants.Main.Cell.headerCellHeight
      
    case 1:
      
      let heightCell = CalculateHeightView.calculateMaxHeightDinnerCollectionView(dinnerData: mainViewModel.dinnerCollectionViewModel)

      return heightCell + 30 // Pad
      
    case 2:
      
      return 200
      
    default:break
      
    }
    
    return 0
  }
  
  
}


// MARK: Work with SetShugarView CLousers


extension MainViewController {
  // Shugar Set View
  private func setShugarSetViewClousers(_ cell:MainTableViewMiddleCell) {
    
    // Correction Insulin
    cell.dinnerCollectionViewController.didSetCorrectionShugarByInsulinClouserToMain = {[weak dinnerValidator,weak self] correctInsulin in
      
      print("End COrrection Insulin")

      self?.interactor?.makeRequest(request: .setCorrectionInsulinBySHugar(correctionValue: correctInsulin))
      
      // Теперь корректировку надо обновить в модели!
      dinnerValidator?.correctionInsulin = correctInsulin

    }
    
    // Shugar Before TextField Change
    cell.dinnerCollectionViewController.didShugarBeforeTextFieldChangeToMain = {[weak dinnerValidator] shugarBefore in

      dinnerValidator?.shugarBeforeValue = String(shugarBefore)

      dinnerValidator?.correctionInsulin = ShugarCorrectorWorker.shared.getInsulinCorrectionByShugar(shugarValue: shugarBefore)
   
    }
    // End Editing Shugar Before and Time

    cell.dinnerCollectionViewController.didSetShugarBeforeValueAndTimeClouserToMain = {[weak self] time,shugar in

      self?.interactor?.makeRequest(request: .setShugarBeforeValueAndTime(time: time, shugar: shugar))

    }
    
    
  }
}


// MARK: Work With Product List Clousers

extension MainViewController {
  
  // Set Clousers By Dinner
  
  private func setProductListInDinnerClousers(_ cell: MainTableViewMiddleCell) {
    
    // TextFiedl Begin Editing
    cell.dinnerCollectionViewController.didSelectTextField = {[weak self] textField in
      self?.didSelectTextField(textField: textField)
    }
    
    // Insulin TextField End Editing
    cell.dinnerCollectionViewController.didInsulinTextFieldEndEditingToMain =  {
          [weak dinnerValidator,weak self] insulin,row in
          
      // MARK: TODO here Bag!
          self?.interactor?.makeRequest(request: .setInsulinInProduct(insulin: insulin, rowProduct: row, isPreviosDInner: false))

          dinnerValidator?.insulinValue = String(insulin)
    }
    
    // Portion TextField End Editing
    
    cell.dinnerCollectionViewController.didPortionTextFieldEndEditingToMain = {
      [weak dinnerValidator,weak self] portion,row in
      
      
      self?.interactor?.makeRequest(request: .setPortionInProduct(portion: portion, rowProduct: row))
      
      // Тут нужно правельно записать в модель данные которые приходят сюда
      dinnerValidator?.portion = String(portion)
    }

    
    // Add New Product
    cell.dinnerCollectionViewController.didAddNewProductInDinner = {[weak self] in
      self?.addNewProductInDinner()
    }
    // Delete Product From Dinner
    cell.dinnerCollectionViewController.didDeleteProductFromDinner = {[weak self] product in
      self?.deleteProducts(products: product)
    }
    
  }

  
  // Этим должна заниматся View Model! Или хотябы запихнуть в  Worker чтобы можно было бы тестировать!
  
//  private func getFirstDinnerProductListViewModel() -> [ProductListViewModel] {
//    let newDinnerProducts = mainViewModel.dinnerCollectionViewModel.first!.productListInDinnerViewModel.productsData
//    return newDinnerProducts
//  }
  
  func addProducts(products: [ProductRealm]) {

    interactor?.makeRequest(request: .addProductInNewDinner(products: products))

    let somePortion = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData[0].portion
    let someInsulin = mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData[0].insulinValue
    
    dinnerValidator.portion = "\(somePortion)"
    dinnerValidator.insulinValue = "\(someInsulin)"
    
//    reloadMiddleCell()
//    reloadFooterCell()
  }

  
  func deleteProducts(products: [ProductRealm]) {

    interactor?.makeRequest(request: .deleteProductFromDinner(products: products))
    
//    reloadMiddleCell()
//    reloadFooterCell()
  }
  
  

  
  // Begin Editing TextField
  private func didSelectTextField(textField: UITextField) {
    
    // Если выбрали текст филд при открытом menu
    closeMenu()
    setTextFiedlPoint(textField: textField)
    // Можно тут вслепую просто запилить что если вбираешь текст филд то убери
    removeListTrainTableView()
  }
  
  private func setTextFiedlPoint(textField: UITextField) {

    let point = mainView.convert(textField.center, from: textField.superview!)
    textFieldSelectedPoint = point
    
  }
  
  
  // Dinner Cell View CLousers
  
  private func didScrollDinnerCollectionView() {
    removeListTrainTableView()
  }
  
  
  // MARK: To Menu ViewController

  // Add NEw Product in PorductListViewController
  private func addNewProductInDinner() {
    
    // Use COntainer COntroller
    didShowMenuProductsListViewControllerClouser!(distanceTranslateMainController)
  }
  
  
  
}

// MARK: Work With Train ListView Controller
extension MainViewController {
  
  private func setWillActivityClousers(_ cell: MainTableViewMiddleCell) {
    
    // List Button
    cell.dinnerCollectionViewController.didTapListButtonInActiveTextField = {[weak self] textField in
      self?.didTapListButtonInActiveTextField(textField: textField)
    }
    // When Scroll
    cell.dinnerCollectionViewController.didScrollDinnerCollectionView = {[weak self] in
      self?.didScrollDinnerCollectionView()
    }
    // Tap On Switch
    cell.dinnerCollectionViewController.didSwitchActiveViewToMainView = {[weak self] in
      
      self?.didSwitchTrainActivate()
      //      self?.removeListTrainTableView() // если листа нет то ниче не произойдет если есть то уберет
    }
    
    
    
    cell.dinnerCollectionViewController.didEndEditingWillActiveTextField = {[weak self] textField in
      self?.didEndEditingTrainTextField(textField: textField)
    }
  }
  
  private func didSwitchTrainActivate() {
    closeMenu()
    removeListTrainTableView()
  }
  
  private func didEndEditingTrainTextField(textField: UITextField) {
    
    guard let train = textField.text else {return}
    // Или сдесь сделать запись в realm
    listTrainsViewController.addNewTrain(train: train)
    
  }
  
  // LIST Trains Closuer
  
  private func didSelectListTrainViewControllerCell(name: String) {
    
    let dinnerCell =  getFirstDinnerCell()
    dinnerCell.willActiveRow.trainTextField.text = name
    removeListTrainTableView()
    
  }
  
  private func didTapListButtonInActiveTextField(textField: UITextField) {
    
    
    
    if mainView.subviews.contains(listTrainsViewController.view) {
      removeListTrainTableView()
    } else {
      textField.resignFirstResponder()
      setUpListTrainsView(textField: textField)
    }
    
  }
  
  // Сейчас все работает только осталось подстраховать некоторые нюансы!
  
  private func setUpListTrainsView(textField: UITextField) {
    //     Жесткое дерьмо но работает останется только прокинуть в mainView
    mainView.addSubview(listTrainsViewController.view)
    
    listTrainsViewController.view.anchor(top: textField.bottomAnchor, leading: textField.leadingAnchor, bottom: nil, trailing: textField.trailingAnchor)
    listTrainsViewController.view.constrainHeight(constant: 150)
    
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.listTrainsViewController.view.alpha = 1
    }, completion: nil)
    
  }
  
  private func removeListTrainTableView() {
    
    
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.listTrainsViewController.view.alpha = 0
    }) { (succes) in
      self.listTrainsViewController.view.removeFromSuperview()
    }
    
  }
  
}


// MARK: Work With ChoosePlaceInjectionView

extension MainViewController {
  // Set Clousers
  private func setChoosePlaceInjectiosnClousers(_ cell: MainTableViewMiddleCell) {
    
    cell.dinnerCollectionViewController.didShowChoosepalceIncjectionView = {[weak self] in
      self?.choosePlaceInjections()
    }
  }
  
  // Показываем Человечка
  private func choosePlaceInjections() {
    // Так же нам понадобится анимация
    closeMenu()
    print("Choose Inkections")
    ChoosePlaceInjectionsAnimated.showView(blurView: mainView.blurView, choosePlaceInjectionView: mainView.choosePlaceInjectionsView, isShow: true)
    
    
  }
  
  private func didChooseNewPlaceInjections(namePlace: String) {

    let dinnerItem = getFirstDinnerCell()
    
    dinnerItem.chooseRowView.chooseButton.setTitle(namePlace, for: .normal)
    // Теперь задача состоит в том что нужно транспортировать строку в row
    
    
    // Добавляем в валидатор
    dinnerValidator.placeInjection = namePlace
    
    // это все должно идти через презентер наверно где то там модель с данными должна лежать!
    // Сохраняем в модель!
    interactor?.makeRequest(request: .setPlaceIngections(place: namePlace))
//    mainViewModel.dinnerCollectionViewModel[0].placeInjection = namePlace
    // Закрываем
    didTapClouseChoosePlaceInjectionView()
    
 
    
  }
  
  // Нажали закрыть View
  private func didTapClouseChoosePlaceInjectionView() {
    
    ChoosePlaceInjectionsAnimated.showView(blurView: mainView.blurView, choosePlaceInjectionView: mainView.choosePlaceInjectionsView, isShow: false)
  }
  
}


// MARK: Save Dinner

extension MainViewController {
  
  private func tapFooterSaveButton() {
    
    
    // Соотвественно это безобразие надо подрпавить
    
    // Запишу здесь Конечную дозировку инслуина на обед
//    mainViewModel.dinnerCollectionViewModel[0].totalInsulin = mainViewModel.footerViewModel.totalInsulinValue
    
    interactor?.makeRequest(request: .saveViewModel(viewModel: mainViewModel))
    
    let middleCell = getMainMiddleCell()
    middleCell.dinnerCollectionViewController.scrollCollectionToheRight()
    // Обнули валидацию
    dinnerValidator.setDefault()
//    tableView.reloadRows(at: [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0)], with: .automatic)
  }
}


// MARK: Set Keyboard Notification Animation

extension MainViewController {
  
  
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


// MARK: GestureRecogniserDelegate

extension MainViewController: UIGestureRecognizerDelegate {
  
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


