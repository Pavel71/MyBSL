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
  
  // Место где выбран TextField
  var textFieldSelectedPoint: CGPoint!
  
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
    
    setUpMainView()
    
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
    
  }
  
  private func configureTableView() {
    
    tableView = mainView.tableView
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.showsVerticalScrollIndicator = false
    tableView.keyboardDismissMode = .interactive
    
    tableView.register(MainTableViewHeaderCell.self, forCellReuseIdentifier: MainTableViewHeaderCell.cellId)
    tableView.register(MainTableViewMiddleCell.self, forCellReuseIdentifier: MainTableViewMiddleCell.cellId)
    tableView.register(MainTableViewFooterCell.self, forCellReuseIdentifier: MainTableViewFooterCell.cellId)
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
    
    return cell
    
    
  }
  
  private func configureMiddleCell() -> MainTableViewMiddleCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewMiddleCell.cellId) as! MainTableViewMiddleCell
    
    cell.dinnerCollectionViewController.didSelectTextField = {[weak self] textField in
      self?.didSelectTextField(textField: textField)
    }
    
    return cell
  }
  
  private func configureFooterCell() -> MainTableViewFooterCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewFooterCell.cellId) as! MainTableViewFooterCell
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
      
    case 0:
      return 200
      
    case 1:
      
      return Constants.Main.Cell.mainMiddleCellHeight
      
    case 2:
      return 200
      
    default:break
      
    }
    
    return 0
  }
  
  
}


// MARK: Catch All Clousers Or Buttons Target

extension MainViewController {
  
  private func didSelectTextField(textField: UITextField) {
    setTextFiedlPoint(textField: textField)
  }
  
  private func setTextFiedlPoint(textField: UITextField) {

    let point = mainView.convert(textField.center, from: textField.superview!)
    textFieldSelectedPoint = point
    
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
    
    
//    if textFieldPointY > keyBoardFrame.height {
//
//      let diff = textFieldPointY - keyBoardFrame.height  // где его нижняя граница!
//
//
//    }

  }
  
  
}
