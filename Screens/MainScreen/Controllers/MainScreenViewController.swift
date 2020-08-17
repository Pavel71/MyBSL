//
//  MainScreenViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import JGProgressHUD

enum TableViewLayer: Int {
  
  case topLayer
  case insulinInjectionLayer
}



protocol MainScreenDisplayLogic: class {
  func displayData(viewModel: MainScreen.Model.ViewModel.ViewModelData)
}

class MainScreenViewController: UIViewController, MainScreenDisplayLogic {

  var interactor: MainScreenBusinessLogic?
  var router: (NSObjectProtocol & MainScreenRoutingLogic)?
  
  var loadDataHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Loading data..."
    return hud
  }()
  
  // Properties
  
//  var tableView = UITableView(frame: .zero, style: .plain)
  var mainScreenView          : MainScreenView!
  var navBarView              : MainCustomNavBar!
  var chartVC                 : ChartViewController!
  var mealCollectionVC        : MealCollectionVC!
  var insulinSupplyView       : InsulinSupplyView!
  var newSugarDataView        : NewSugarDataView!
  var addNewInsulinSupplyView : AddNewInsulinSupplyView!
//  var calendarView      : CalendarView!
  
  // For KeyboardNotification
  var newSugarViewPointY: CGFloat!
  
  
  var mainScreenViewModel: MainScreenViewModelable! {
    
    didSet {
      mainScreenView.setViewModel(viewModel: mainScreenViewModel)
      
      mainScreenView.setNeedsDisplay()
    }
  }

  // MARK: Object lifecycle
  
   init() {
     super.init(nibName: nil, bundle: nil)
     setup()
   }
  deinit {
    print("DeinitMainScreenController")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = MainScreenInteractor()
    let presenter             = MainScreenPresenter()
    let router                = MainScreenRouter()
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
    
    setViews()
    print("View DId Load Main Screen")

    interactor?.makeRequest(request: .setFireStoreDayListner)
  }

  
//  // MARK: Activate Application
//  func activateApplication() {
//    
//    print("Activate application Main Screen")
    
    // На старте мы просто перезапишим балнк модель и все! в остальное время будет все норм!
//    interactor?.makeRequest(request: .checkLastDayInDB)checkLastDayInDB


//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("Main Screen View Will Appear")
    
//    interactor?.makeRequest(request: .checkLastDayInDB)
    
    
    navigationController?.navigationBar.isHidden = true
    setKeyboardNotification()
    // Сделаем запрос в реалм чтобы получить новые данные по ViewModel
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: Display Data
  
  func displayData(viewModel: MainScreen.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
      
    case .setViewModel(let viewModel):
      
      mainScreenViewModel = viewModel
      
      
    case .throwCompansationObjectToUpdate(let compObj):
      
      self.router!.goToNewCompansationObjectScreen(compansationObjectRealm: compObj)
      
      
    case .showLoadingMessage(let message):
      
      loadDataHUD.textLabel.text = message
      loadDataHUD.show(in: self.view)
    case .showOffLoadingMessage:
      loadDataHUD.dismiss()
      
    case .showAlertMessage(let title, let message):
      showAlert(title: title, message: message)
      
      
    }

  }
  
  
  
}

//MARK: Set Views
extension MainScreenViewController {
  
  
   private func setViews() {
    
    mainScreenView          = MainScreenView()
    navBarView              = mainScreenView.navBar
    chartVC                 = mainScreenView.chartView.chartVC
    mealCollectionVC        = mainScreenView.mealCollectionView.collectionVC
    insulinSupplyView       = mainScreenView.insulinSupplyView
    newSugarDataView        = mainScreenView.newSugarView
    addNewInsulinSupplyView = mainScreenView.addNewInsulinSupplyView
//    calendarView      = mainScreenView.calendareView
    
    
    view.addSubview(mainScreenView)
    mainScreenView.fillSuperview()

    
    setClousers()
  }
  
  // MARK: Set Clousers From Views
  
  private func setClousers() {
    
    setChartVCClousers()
    
    setMealVCClousers()
    
    setInsulinSupplyClousers()
    
    setNavBarClousers()
    
    setNewSugarDataViewClousers()
    
    setCompansationObjectCellTopButtons()
    
    setAddNewInsulinSupplyViewClousers()
    
  }
  
  
  //MARK: AddNewInsulinSupplyClousers
  private func setAddNewInsulinSupplyViewClousers() {
    
    addNewInsulinSupplyView.didTapCancelButton = { [weak self] in
      
      self?.hideAddNewInsulinSupplyValue()
      
    }
    
    addNewInsulinSupplyView.didTapSaveButton = { [weak self] in
      
      guard let supplyUserSet = self?.addNewInsulinSupplyView.insulinSupplyValue else {return}
      // теперь нам нужно прокинуть это значение в модель! и работать с ней! А что если мы скипаем приложение эти данные не доолжны исчезнуть!
      // Значит нам надо сохранить их в памяти
      self?.interactor?.makeRequest(request: .setInsulinSupplyValue(insulinSupplyValue: supplyUserSet))
      
      self?.hideAddNewInsulinSupplyValue()
    }
    

  }
  
  private func hideAddNewInsulinSupplyValue() {
    AddNewElementViewAnimated.showOrDismissToTheUpRightCornerNewView(
    newElementView: self.addNewInsulinSupplyView,
    blurView:self.mainScreenView.blurView ,
    customNavBar: self.navBarView,
    tabbarController: self.tabBarController!,
    isShow: false)
  }
  

  
  //MARK:  Top Buttons Clouser
  private func setCompansationObjectCellTopButtons() {
    
    mealCollectionVC.didDeleteCompasationObject = {[weak self] id in
      
      // Покажи алерт и если будет подтверждение то удали объект!
      
      self?.showAlertControllerWithCancel(title: "Удалить обед", confirmDelete: { (_) in
        self?.interactor?.makeRequest(request: .deleteCompansationObj(compObjId: id))
      })
      
      
    }

    mealCollectionVC.didUpdateCompansationObject = {[weak self] id in
      self?.interactor?.makeRequest(request: .getCompansationObj(compObjId: id))
    }
    
    
    mealCollectionVC.didShowSugarBeforeCLouser = {[weak self] sugarBefore in
      self?.showAlertController(title: "Сахар до еды", message: sugarBefore)
    }
    
    mealCollectionVC.didShowSugarAfterCLouser =  {[weak self] sugarAfter in
         self?.showAlertController(title: "Сахар после еды", message: sugarAfter)
    }
    
    mealCollectionVC.didSHowTotalInsulinClouser =  {[weak self] totalInsulin in
         self?.showAlertController(title: "Инсулина сделанно", message: totalInsulin)
    }
    
    mealCollectionVC.didShowTotalCarboClouser =  {[weak self] totalCarbo in
         self?.showAlertController(title: "Всего Углеводов", message: totalCarbo)
    }
    
    
  }
  
  
  
  //MARK: ChartVC Clousers
  private func setChartVCClousers() {
    chartVC.passCompansationObjectId = { [weak self] mealId in
      self?.catchMealIdFromChart(mealId: mealId)
    }
  }
  // MealVC Clousers
  private func setMealVCClousers() {
    mealCollectionVC.passMealIdItemThanContinueScroll = {[weak self] mealId in
      self?.catchMealIDFromMealVCThanScrolled(mealId: mealId)
    }
  }
  //MARK:  InsulinSupplyView Clousers
  
  
  private func setInsulinSupplyClousers() {
    
    insulinSupplyView.passSiganlLowSupplyLevel  = {[weak self] in
      self?.catchInsulinViewSupplyLevelLow()
    }
    
    insulinSupplyView.passSignalShowSupplyLevel = {[weak self] in
      self?.catchInsulinViewShowSupplyLevel()
    }
    
    insulinSupplyView.didTapReloadInsulinSupplyButtons = {[weak self] in
      // Нужно показать AddNewInsulinSupplyView
      AddNewElementViewAnimated.showOrDismissToTheUpRightCornerNewView(
        newElementView: self!.addNewInsulinSupplyView,
        blurView:self!.mainScreenView.blurView ,
        customNavBar: self!.navBarView,
        tabbarController: self!.tabBarController!,
        isShow: true)
    }
    
    
    
  }
  //MARK: NavBarClousers
  private func setNavBarClousers() {
    navBarView.didTapAddNewDataClouser = {[weak self] in
      self?.addNewData()
    }
    navBarView.didTapRobotMenuClouser = {[weak self] in
      self?.showRobotMenu()
    }
    
    navBarView.didTapNextDateClouser = {[weak self] nextDate in
      
      self?.interactor?.makeRequest(request: .selectDayByCalendar(date: nextDate))
    
    }
    
    navBarView.didTapPreviosDateClouser = {[weak self] prevDate in
      
      self?.interactor?.makeRequest(request: .selectDayByCalendar(date: prevDate))
    }
  }
  
  //MARK: NewSugarView Clousers
  
  private func setNewSugarDataViewClousers() {
    newSugarDataView.didTapSaveButtonClouser = { [weak self] sugarVM in
      self?.catchTapedSaveButton(sugarViewModel: sugarVM)
    }
    
    newSugarDataView.didTapCancelButtonCLouser = { [weak self] in
      self?.catchTapedCancelButton()
    }
  }
  
}


// MARK: Catch Clousers From Views

extension MainScreenViewController {
  
  // Catch Meal Id Than Selected in Chart
  
  private func catchMealIdFromChart(mealId: String) {
    
    // теперь мне нужно поймать ячейку с этим Id и показать ее юзеру
    let rowMealById = mealCollectionVC.dinners.firstIndex{$0.id == mealId}
    guard let indexRow = rowMealById else {return}
    
    mealCollectionVC.collectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: true)
    
  }
  
  // CatchMealVC CLousers
  
  private func catchMealIDFromMealVCThanScrolled(mealId: String) {
    // теперь мне нужно подсветить entry по mealId
    chartVC.highlitedEntryByMealId(mealId: mealId)
  }
  
 
  
  
  
  // MARK: - Alert Sheeft Signals
  
  private func addNewData() {
    showSheetControllerAddSugarOrMeal(title: "Добавить данные!",
     sugarCallBack: { action in
      
      AddNewElementViewAnimated.showOrDismissToTheUpRightCornerNewView(newElementView: self.newSugarDataView, blurView: self.mainScreenView.blurView, customNavBar: self.navBarView, tabbarController: self.tabBarController!, isShow: true)
      
      
    },mealCallback: { action in
      
      // идея запустить обучение здесь! Пускай покачто будет здесь!
      
      // MARK: Go to New ComObj Screen
      
      self.router!.goToNewCompansationObjectScreen(compansationObjectRealm: nil)
    }, addNewDayCallBack: { _ in
      
      self.interactor?.makeRequest(request: .addNewDay)
      
    })
    
  }
  

  
  
  
  
  private func showRobotMenu() {
    print("Show Robot Menu")
    // Пока буду использовать это в качетсве удаления сегодя из Реалма
    
  }
  
}

// MARK: Catch InsulinSupplyView

extension MainScreenViewController {
  
   
   private func catchInsulinViewSupplyLevelLow() {
     self.showAlertController(title: "Низкий запас инсулина!", message: "Замените картридж с инсулином!")
   }
   
   private func catchInsulinViewShowSupplyLevel() {
     
     let supplyLevel = mainScreenViewModel.insulinSupplyVM.insulinSupply
     self.showAlertController(title: "Инсулина в картридже. ", message: "\(supplyLevel) ед.")
   }
}


// MARK: Catch Save And Cancel Button From NewSugarView

extension MainScreenViewController {
  
  private func catchTapedSaveButton(sugarViewModel: SugarViewModel) {
  
    interactor?.makeRequest(request: .setSugarVM(sugarViewModel: sugarViewModel))
  }
  
  private func catchTapedCancelButton() {
    
    AddNewElementViewAnimated.showOrDismissToTheUpRightCornerNewView(newElementView: self.newSugarDataView, blurView: self.mainScreenView.blurView, customNavBar: self.navBarView, tabbarController: self.tabBarController!, isShow: false)
    
  }
  
}


// MARK: ViewController Clousers

extension MainScreenViewController {
  
  func reloadMainScreen() {
    interactor?.makeRequest(request: .reloadDay)
  }
  
}

// MARK: Keyboard Notififcation

extension MainScreenViewController {
  

  private func setKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillUP), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  
  // Will UP Keyboard
  @objc private func handleKeyBoardWillUP(notification: Notification) {
    
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyBoardFrame = value.cgRectValue
    
    // Нужно засетить точку 1 раз И потом она не будет изменятся!
    if newSugarViewPointY == nil {
      newSugarViewPointY = newSugarDataView.frame.origin.y
    }
    
    
    let diff = keyBoardFrame.height + 10 - newSugarViewPointY
    UIView.animate(withDuration: 0.5) {
      self.newSugarDataView.transform = CGAffineTransform(translationX: 0, y: -diff)
    }
    
  }
  // Will Hide
  @objc private func handleKeyboardDismiss(notification: Notification) {
    UIView.animate(withDuration: 0.5) {
      self.newSugarDataView.transform = .identity
    }
  }
  
  
}

// MARK: Show Sheet AlertController
extension MainScreenViewController {
  
  func showSheetControllerAddSugarOrMeal(
    title             : String,
    sugarCallBack     : ((UIAlertAction) -> Void)?,
    mealCallback      : ((UIAlertAction) -> Void)?,
    addNewDayCallBack : ((UIAlertAction) -> Void)?
  ){
    
    // Нужно подумать как бы мне сюда впихнуть CallBack
    
     let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
        let sugarAction    = UIAlertAction(title: "Передать сахар", style: .default, handler: sugarCallBack)
        let mealDataAction = UIAlertAction(title: "Компенсация углеводов", style: .default, handler: mealCallback)
        let addNewDay      = UIAlertAction(title: "Новый день", style: .default, handler: addNewDayCallBack)
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
    
        alertController.addAction(addNewDay)
        alertController.addAction(sugarAction)
        alertController.addAction(mealDataAction)
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
  }
}








