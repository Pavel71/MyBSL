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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("View Will Appear Main Screeen")
    navigationController?.navigationBar.isHidden = true
    
    // Сделаем запрос в реалм чтобы получить новые данные по ViewModel
    interactor?.makeRequest(request: .getViewModel)
  }
  
  func displayData(viewModel: MainScreen.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .setViewModel(let viewModel):
      mainScreenViewModel = viewModel
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
    
  }
  // ChartVC Clousers
  private func setChartVCClousers() {
    chartVC.passMealIdCLouser = { [weak self] mealId in
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
  }
  
  // NewSugarView Clousers
  
  private func setNewSugarDataViewClousers() {
    newSugarDataView.didTapSaveButtonClouser = { [weak self] in
      self?.catchTapedSaveButton()
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
    let rowMealById = mealCollectionVC.dinners.firstIndex{$0.mealId == mealId}
    guard let indexRow = rowMealById else {return}
    
    mealCollectionVC.collectionView.scrollToItem(at: IndexPath(item: indexRow, section: 0), at: .centeredHorizontally, animated: true)
    
  }
  
  // CatchMealVC CLousers
  
  private func catchMealIDFromMealVCThanScrolled(mealId: String) {
    // теперь мне нужно подсветить entry по mealId
    chartVC.highlitedEntryByMealId(mealId: mealId)
  }
  
 
  
  // Catch NavBarClousers
  
  // MARK: Show NewSugarDataView And Go to New Screen
  
  private func addNewData() {
    showSheetControllerAddSugarOrMeal(title: "Добавить данные!",
     sugarCallBack: { action in
      
      AddNewElementViewAnimated.showOrDismissNewView(newElementView: self.newSugarDataView, blurView: self.mainScreenView.blurView, customNavBar: self.navBarView, tabbarController: self.tabBarController!, isShow: true)
      
      // Запускаю Анимацию Sugar View
      
      // Также мне нужно прокинуть сюда сигналы от нажатия на кнопки!
      
      // Вообщем здесь нужно запускать анимацию появления newSugarDataView! - Все должно соответсвовать тому же как я добавляю новые продукты! Дизайн и анимация должны быть такими же
      // View - содержит Title
      // Сахар сейчас - TextField с точкой
      // Если сахар вне норм то анимированно показать еще текствилд
      // Компенсация - текстфилд - Тут нужно подумать что если мы у нижней границе то нам желательно показать картинкой конфетку! в числах же юзера нужно попрасить ввести данные эквивалентные инсулину- Это конечно тяжело объяснить но проще наверно будет написать углеводы! а самомоу потом подсчитать насколько нужно было бы уменьшить дозировку! Пока я делаю так чтобы юзер все понял! Дальше уже девелопер пускай разбирается!
      
      print("Sugar Callback")
    },mealCallback: { action in
      print("MealCallback")
    })
    
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


// MARK: Catch NewSugarVew Clousers

extension MainScreenViewController {
  
  private func catchTapedSaveButton() {
    
  }
  
  private func catchTapedCancelButton() {
    
    AddNewElementViewAnimated.showOrDismissNewView(newElementView: self.newSugarDataView, blurView: self.mainScreenView.blurView, customNavBar: self.navBarView, tabbarController: self.tabBarController!, isShow: false)
    
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
        let mealDataAction = UIAlertAction(title: "Добавить обед", style: .default, handler: mealCallback)
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alertController.addAction(sugarAction)
        alertController.addAction(mealDataAction)
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
  }
}







