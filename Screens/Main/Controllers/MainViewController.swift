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
  
  
  var mainViewModel: MainViewModel! {
    
    didSet {
      tableView.reloadData()
    }
  }
  
  
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
    
    
    // Set DummyViewModel
    
    let headerViewModel = MainHeaderViewModel.init(lastInjectionValue: "1.5", lastTimeInjectionValue: "13:30", lastShugarValueLabel: "7.5", insulinSupplyInPanValue: "156")
    
    let product1 = ProductListViewModel(insulinValue: "", carboIn100Grm: 5, carboInPortion: "12", name: "Макароны", portion: "200")
    let product2 = ProductListViewModel(insulinValue: nil, carboIn100Grm: 13, carboInPortion: "25", name: "Абрикосы", portion: "156")
    
    let shugarViewModel1 = ShugarTopViewModel(isPreviosDinner: false, shugarBeforeValue: "5.5", shugarAfterValue: "4", timeBefore: "11/09/19 12:30", timeAfter: "11/09/19 13:30")
    let shugarViewModel2 = ShugarTopViewModel(isPreviosDinner: true, shugarBeforeValue: "12.5", shugarAfterValue: "13", timeBefore: "11/09/19 12:30", timeAfter: "11/09/19 13:30")
    let shugarViewModel3 = ShugarTopViewModel(isPreviosDinner: true, shugarBeforeValue: "7.5", shugarAfterValue: "6", timeBefore: "11/09/19 12:30", timeAfter: "11/09/19 13:30")
    
    let result = ProductListResultsViewModel(sumCarboValue: "12", sumPortionValue: "25", sumInsulinValue: "33")
    
    let productListViewController1 = ProductListInDinnerViewModel(productsData: [product1,product2], dinnerItemResultsViewModel: result, isPreviosDinner: false)
    
    let productListViewController2 = ProductListInDinnerViewModel(productsData: [product2,product1,product2], dinnerItemResultsViewModel: result, isPreviosDinner: true)
    
    let productListViewController3 = ProductListInDinnerViewModel(productsData: [product1,product2,product1], dinnerItemResultsViewModel: result, isPreviosDinner: true)
    
    
    let dinner1 = DinnerViewModel(shugarTopViewModel: shugarViewModel1, productListInDinnerViewModel: productListViewController1)
    let dinner2 = DinnerViewModel(shugarTopViewModel: shugarViewModel2, productListInDinnerViewModel: productListViewController2)
    let dinner3 = DinnerViewModel(shugarTopViewModel: shugarViewModel3, productListInDinnerViewModel: productListViewController3)
    

    
    let dinnerViewModels = [
      dinner1,dinner2,dinner3
    ]
    mainViewModel = MainViewModel.init(headerViewModelCell: headerViewModel, dinnerCollectionViewModel: dinnerViewModels)
    
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
    
    setMainViewClousers()
    
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
  
  private func setMainViewClousers() {
    mainView.choosePlaceInjectionsView.didTapCloseButton = {[weak self] in
      self?.didTapClouseChoosePlaceInjectionView()
    }
    
    mainView.choosePlaceInjectionsView.didChooseInjectionsPlace = {[weak self] title in
      self?.didChooseNewPlaceInjections(namePlace: title)
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
    
    cell.dinnerCollectionViewController.didShowChoosepalceIncjectionView = {[weak self] in
      self?.choosePlaceInjections()
    }
    
    cell.dinnerCollectionViewController.didTapListButtonInActiveTextField = {[weak self] textField in
      self?.didTapListButtonInActiveTextField(textField: textField)
    }
    
    cell.dinnerCollectionViewController.didScrollDinnerCollectionView = {[weak self] in
      self?.didScrollDinnerCollectionView()
    }
    
    cell.dinnerCollectionViewController.didSwitchActiveViewToMainView = {[weak self] in
      self?.removeListTableView() // если листа нет то ниче не произойдет если есть то уберет
    }
    
  }

  
  private func configureFooterCell() -> MainTableViewFooterCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewFooterCell.cellId) as! MainTableViewFooterCell
    
    return cell
  }
  
  
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
      
    case 0:
      return 150
      
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
  
  // Begin Editing TextField
  private func didSelectTextField(textField: UITextField) {
    setTextFiedlPoint(textField: textField)
    
  }
  
  private func setTextFiedlPoint(textField: UITextField) {

    let point = mainView.convert(textField.center, from: textField.superview!)
    textFieldSelectedPoint = point
    
  }
  
  
  // Cell View CLousers
  
  private func didScrollDinnerCollectionView() {
    removeListTableView()
  }
  
  // Tap List Trains
  
  private func didTapListButtonInActiveTextField(textField: UITextField) {
    

    if mainView.subviews.contains(listTrainsViewController.view) {
      removeListTableView()
    } else {
      setUpListTrainsView(textField: textField)
    }
    
  }
  
  // Сейчас все работает только осталось подстраховать некоторые нюансы!
  
  private func setUpListTrainsView(textField: UITextField) {
    //     Жесткое дерьмо но работает останется только прокинуть в mainView
    mainView.addSubview(listTrainsViewController.view)
    listTrainsViewController.view.anchor(top: textField.bottomAnchor, leading: textField.leadingAnchor, bottom: nil, trailing: textField.trailingAnchor)
    listTrainsViewController.view.constrainHeight(constant: 200)
    
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.listTrainsViewController.view.alpha = 1
    }, completion: nil)
    
  }
  
  private func removeListTableView() {
    
    
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.listTrainsViewController.view.alpha = 0
    }) { (succes) in
        self.listTrainsViewController.view.removeFromSuperview()
    }
    
  }
  
  // Add NEw Product in PorductListViewController
  private func addNewProductInDinner() {
    print("Add New product Main")
  }
  
  // Stack Func Choose Place Injections
  
  // Показываем Человечка
  private func choosePlaceInjections() {
    // Так же нам понадобится анимация
    
    ChoosePlaceInjectionsAnimated.showView(blurView: mainView.blurView, choosePlaceInjectionView: mainView.choosePlaceInjectionsView, isShow: true)
    
    
  }
  
  private func didChooseNewPlaceInjections(namePlace: String) {
    
    // Вот такая цепь событий
    let  cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! MainTableViewMiddleCell
    
    let dinnerItem = cell.dinnerCollectionViewController.collectionView.cellForItem(at:  IndexPath(item: 0, section: 0))  as! DinnerCollectionViewCell
    
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
