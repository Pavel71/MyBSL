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






class MainViewController: UIViewController, MainDisplayLogic {
  
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic)?
  
  
  var mainView: MainView!
  var tableView: UITableView!
  var listTrainsViewController = ListTrainsViewController(style: .plain)
  
  // Место где выбран TextField
  var textFieldSelectedPoint: CGPoint!
  
  
  // Здесь должна быть VIewModel которая содержит в себе данные для первой ячейки так и для второй ячейки
  
  // PanGesture Recogniser
  var slideMenuPanGestureRecogniser: UIPanGestureRecognizer!
  
  // CLousers
  
  // To ContainerController
  var didShowMenuProductsListViewControllerClouser: EmptyClouser?
  var didGestureRecognaserValueChange: ((UIPanGestureRecognizer) -> Void)?
  
  // ViewModel
  var mainViewModel: MainViewModel!
  
  
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
    let router                = MainRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("View Did Load")
    setUpMainView()
    
    let headerViewModel = MainHeaderViewModel.init(lastInjectionValue: "1.5", lastTimeInjectionValue: "13:30", lastShugarValueLabel: "7.5", insulinSupplyInPanValue: "156")
    let dinnerViewModels = DinnerData.getData()
    
    mainViewModel = MainViewModel.init(headerViewModelCell: headerViewModel, dinnerCollectionViewModel: dinnerViewModels)
    // После установки обновим всю таблицу
    tableView.reloadData()
    
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
    
  }
  
  
  private func setViewModel(viewModel: MainViewModel) {
    mainViewModel = viewModel
  }
  
  private func getFirstDinnerCell() -> DinnerCollectionViewCell {
    
    let  cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! MainTableViewMiddleCell
    
    let dinnerItem = cell.dinnerCollectionViewController.collectionView.cellForItem(at:  IndexPath(item: 0, section: 0))  as! DinnerCollectionViewCell
    
    return dinnerItem
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
  
  
//  var headerCell: MainTableViewHeaderCell!
  
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


// MARK: Configure TableView

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
    
    
    print(mainViewModel.dinnerCollectionViewModel)
    cell.setViewModel(viewModel: mainViewModel.dinnerCollectionViewModel)
    
    setMiddleCellClouser(cell: cell)
    
    
    
    return cell
  }
  
  private func setMiddleCellClouser(cell: MainTableViewMiddleCell) {
    
    // TextFiedl Begin Editing
    cell.dinnerCollectionViewController.didSelectTextField = {[weak self] textField in
      self?.didSelectTextField(textField: textField)
    }
    
    cell.dinnerCollectionViewController.didAddNewProductInDinner = {[weak self] in
      self?.addNewProductInDinner()
    }
    
    // Choose Place Incjections In Cell
    cell.dinnerCollectionViewController.didShowChoosepalceIncjectionView = {[weak self] in
      self?.choosePlaceInjections()
    }
    
    // Will Active Row in Cell
    
    cell.dinnerCollectionViewController.didTapListButtonInActiveTextField = {[weak self] textField in
      self?.didTapListButtonInActiveTextField(textField: textField)
    }
    
    cell.dinnerCollectionViewController.didScrollDinnerCollectionView = {[weak self] in
      self?.didScrollDinnerCollectionView()
    }
    
    cell.dinnerCollectionViewController.didSwitchActiveViewToMainView = {[weak self] in
      self?.removeListTrainTableView() // если листа нет то ниче не произойдет если есть то уберет
    }
    
    cell.dinnerCollectionViewController.didEndEditingWillActiveTextField = {[weak self] textField in
      self?.didEndEditingTrainTextField(textField: textField)
    }
    
  }
  private func configureFooterCell() -> MainTableViewFooterCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewFooterCell.cellId) as! MainTableViewFooterCell
    
    return cell
  }
  
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


// MARK: Catch All Clousers Or Buttons Target

extension MainViewController {
  
  
  // MARK: MenuDinnerViewController Cath Product
  
  func addProductInDinner(products: [ProductRealm]) {
    
    // Тут нужна проыерка на то есть ли такие продукты в базе это проще будет на реалме сделать потомучто возможно мы будем просто по id работать и все!
    
    products.forEach { (product) in
      let productListViewModel = ProductListViewModel(insulinValue: product.insulin, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
      
      mainViewModel.dinnerCollectionViewModel[0].productListInDinnerViewModel.productsData.insert(productListViewModel,at:0)
    }
    
    tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
    
  }
  
  

  
  // Begin Editing TextField
  private func didSelectTextField(textField: UITextField) {
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
  
  

  // Add NEw Product in PorductListViewController
  private func addNewProductInDinner() {
    print("Add New product Main")

    
    // Use COntainer COntroller
    didShowMenuProductsListViewControllerClouser!()
  }
  
  
  
}

// MARK: Work With Train ListView Controller
extension MainViewController {
  
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
  
  
  // Показываем Человечка
  private func choosePlaceInjections() {
    // Так же нам понадобится анимация
    
    ChoosePlaceInjectionsAnimated.showView(blurView: mainView.blurView, choosePlaceInjectionView: mainView.choosePlaceInjectionsView, isShow: true)
    
    
  }
  
  private func didChooseNewPlaceInjections(namePlace: String) {
    
    
    let dinnerItem = getFirstDinnerCell()
    
    dinnerItem.chooseRowView.chooseButton.setTitle(namePlace, for: .normal)
    // Теперь задача состоит в том что нужно транспортировать строку в row
    
    // Закрываем
    didTapClouseChoosePlaceInjectionView()
    
  }
  
  // Нажали закрыть View
  private func didTapClouseChoosePlaceInjectionView() {
    
    ChoosePlaceInjectionsAnimated.showView(blurView: mainView.blurView, choosePlaceInjectionView: mainView.choosePlaceInjectionsView, isShow: false)
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

    let textFieldPointY = textFieldSelectedPoint.y
    
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
    didGestureRecognaserValueChange!(gesture)
  }
  
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    // Вообщем если стоим на месте то отключи горизонтальное прокручивание
    return abs((slideMenuPanGestureRecogniser.velocity(in: slideMenuPanGestureRecogniser.view)).y) > abs((slideMenuPanGestureRecogniser.velocity(in: slideMenuPanGestureRecogniser.view)).x)
  }
}


