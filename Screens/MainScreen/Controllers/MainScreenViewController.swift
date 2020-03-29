//
//  MainScreenViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit


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
  
  
  
  // Properties
  
//  var tableView = UITableView(frame: .zero, style: .plain)
  var mainScreenView    : MainScreenView!
  var navBarView        : MainCustomNavBar!
  var chartVC           : ChartViewController!
  var mealCollectionVC  : MealCollectionVC!
  var insulinSupplyView : InsulinSupplyView!
  var newSugarDataView  : NewSugarDataView!
  var calendarView      : CalendarView!
  
  // For KeyboardNotification
  var newSugarViewPointY: CGFloat!
  
  
  var mainScreenViewModel: MainScreenViewModelable! {
    
    didSet {
      mainScreenView.setViewModel(viewModel: mainScreenViewModel)
    }
  }

  // MARK: Object lifecycle
  
   init() {
     super.init(nibName: nil, bundle: nil)
     setup()
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
    getBlankDay()
  }
  
  private func getBlankDay() {
    interactor?.makeRequest(request: .getBlankViewModel)
  }
  
  // MARK: Activate Application
  func activateApplication() {
    print("Шо за херня")
    
    // Здесь мне нужно достать последний день из базы и его уже проверить с текущей датой!
    interactor?.makeRequest(request: .checkLastDayInDB)
//    if mainScreenViewModel.dayVM.curentDate.onlyDate() != Date().onlyDate() {
//      getBlankDay()
//    }
  }
  

  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("Main Screen View Will Appear")
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
      
    }

  }
  
  
  
}

//MARK: Set Views
extension MainScreenViewController {
  
  
   private func setViews() {
    
    mainScreenView    = MainScreenView()
    navBarView        = mainScreenView.navBar
    chartVC           = mainScreenView.chartView.chartVC
    mealCollectionVC  = mainScreenView.mealCollectionView.collectionVC
    insulinSupplyView = mainScreenView.insulinSupplyView
    newSugarDataView  = mainScreenView.newSugarView
    calendarView      = mainScreenView.calendareView
    
    
    view.addSubview(mainScreenView)
    mainScreenView.fillSuperview()

    
    setClousers()
  }
  
  // MARK: Set Clousers From Views
  
  private func setClousers() {
    
    
    
    setCalendarViewClousers()
    
    setChartVCClousers()
    
    setMealVCClousers()
    
    setInsulinSupplyClousers()
    
    setNavBarClousers()
    
    setNewSugarDataViewClousers()
    
    setCompansationObjectCellTopButtons()
    
  }
  
  //Calenar CLousers
  
  private func setCalendarViewClousers() {
    
    calendarView.didTapCLoseCalendar = {[weak self] in
      self?.closeCalendar()
    }
  }
  
  // Top Buttons Clouser
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
  
  
  
  // ChartVC Clousers
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
  // InsulinSupplyView Clousers
  private func setInsulinSupplyClousers() {
    insulinSupplyView.passSiganlLowSupplyLevel  = {[weak self] in
      self?.catchInsulinViewSupplyLevelLow()
    }
    
    insulinSupplyView.passSignalShowSupplyLevel = {[weak self] in
      self?.catchInsulinViewShowSupplyLevel()
    }
  }
  // NavBarClousers
  private func setNavBarClousers() {
    navBarView.didTapAddNewDataClouser = {[weak self] in
      self?.addNewData()
    }
    navBarView.didTapRobotMenuClouser = {[weak self] in
      self?.showRobotMenu()
    }
    navBarView.didTapCalendarClouser = {[weak self] in
      
      self?.showCalendar()
      
    }
  }
  
  // NewSugarView Clousers
  
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
  
 
  
  // Catch NavBarClousers
  
  // MARK: Show NewSugarDataView
  
  private func addNewData() {
    showSheetControllerAddSugarOrMeal(title: "Добавить данные!",
     sugarCallBack: { action in
      
      AddNewElementViewAnimated.showOrDismissToTheUpRightCornerNewView(newElementView: self.newSugarDataView, blurView: self.mainScreenView.blurView, customNavBar: self.navBarView, tabbarController: self.tabBarController!, isShow: true)
      
      
    },mealCallback: { action in
      
      // MARK: Go to New ComObj Screen
      
      self.router!.goToNewCompansationObjectScreen(compansationObjectRealm: nil)
    })
    
  }
  // MARK: Show Calendar
  
  private func showCalendar() {
    
    AddNewElementViewAnimated.showOrDismissToTheUpLeftCornerNewView(
      newElementView: self.calendarView,
          blurView: self.mainScreenView.blurView,
          customNavBar: self.navBarView,
          tabbarController: self.tabBarController!,
          isShow: true)
  }
  
  private func closeCalendar() {
    AddNewElementViewAnimated.showOrDismissToTheUpLeftCornerNewView(
    newElementView: self.calendarView,
        blurView: self.mainScreenView.blurView,
        customNavBar: self.navBarView,
        tabbarController: self.tabBarController!,
        isShow: false)
  }
  
  
  
  
  
  private func showRobotMenu() {
    
  }
  
}

// MARK: Catch InsulinSupplyView

extension MainScreenViewController {
  
   
   private func catchInsulinViewSupplyLevelLow() {
     self.showAlertController(title: "Низкий запас инсулина!", message: "Замените картридж с инсулином!")
   }
   
   private func catchInsulinViewShowSupplyLevel() {
     
     let supplyLevel = mainScreenViewModel.insulinSupplyVM.insulinSupply
     self.showAlertController(title: "Инсулина в картридже.", message: "\(supplyLevel)ед.")
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


// MARK: Catch Clousers from NewCompansationController

extension MainScreenViewController {
  
  func passCompansationObjVMtoIntercator(viewModel: CompansationObjectRelam) {
    
    interactor?.makeRequest(request: .setCompansationObjRealm(compObjRealm: viewModel))
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
    title         : String,
    sugarCallBack : ((UIAlertAction) -> Void)?,
    mealCallback  : ((UIAlertAction) -> Void)?
  ){
    
    // Нужно подумать как бы мне сюда впихнуть CallBack
    
     let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
        let sugarAction    = UIAlertAction(title: "Передать сахар", style: .default, handler: sugarCallBack)
        let mealDataAction = UIAlertAction(title: "Компенсация сахара", style: .default, handler: mealCallback)
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alertController.addAction(sugarAction)
        alertController.addAction(mealDataAction)
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
  }
}










