//
//  SettingsViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD


// 1. Теперь мне нужно продумать логику изменения измерения! Чтобы все считалось как положенно! Это будет в sugarWorkerre все будет конвертироватся всервано в ммоль просто нужно дать человеку выбирать!

// 2. Перейти на youtube канал - использовать webScreen - не помню как это делается
// 3. Срок действия подписки

// Для начала накину весь UI


enum SugarMetric: String {
  case mmoll = "mmol/ml (4.5-7.5)"
  case mgdl  = "mg/dl (72 - 140)"
}

protocol SettingsDisplayLogic: class {
  func displayData(viewModel: Settings.Model.ViewModel.ViewModelData)
}


enum SettingSections: Int,CaseIterable {
  case changeSugarMeuser
  case socialLinks
  case subscription
}

let socialNetwroksUrlString : [String] = [
  "https://www.youtube.com",
  "https://vk.com",
  "https://www.facebook.com"
]



class SettingsViewController: UIViewController, SettingsDisplayLogic {

  var interactor: SettingsBusinessLogic?
  var router: (NSObjectProtocol & SettingsRoutingLogic)?
  
  var loadDataHUD: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Log Out ..."
    return hud
  }()
  // MARK: Properties
  
  
  let settingView      = SettingsView()
  lazy var tableView   = settingView.tableView
  
  var viewModel : SettingsViewModel!

  
  // MARK: Object lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  

  deinit {
    print("Deinit Settings Controller")
  }
  

  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SettingsInteractor()
    let presenter             = SettingsPresenter()
    let router                = SettingsRouter()
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
    
     guard let userEamil = Auth.auth().currentUser?.email else {return}
     settingView.customNavBar.configureNavBar(useEmail: userEamil)
    configureTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Нужно установить логин аккаунта
    interactor?.makeRequest(request: .getViewModel)
   
    
    navigationController?.navigationBar.isHidden = true
  }
  
  
  
  // MARK: Display
  
  func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .logOut(let result):
      getAnswerLogOut(result: result)
      loadDataHUD.dismiss()
    
    case .displayViewModel(let viewModel):
      self.viewModel = viewModel
      tableView.reloadData()
    }

  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: SET UP VIEWS

extension SettingsViewController {
  
  func setUpViews() {
    
    view.addSubview(settingView)
    settingView.fillSuperview()
    
    setViewClousers()
  }
  
  // MARK: Configure Table View
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
  }
}

// MARK: Signals

extension SettingsViewController {
  
  private func setViewClousers() {
    
    setNavBarClousers()
    
  }
  
  // MARK: Update Sugar MEtric
  private func setSugarMesuerclouser(sugarCell:ChancgeSugarMeuserCell ) {
    sugarCell.didMetrticsChange = {[weak self] metric in
      print("New MEtrics")
      // Также нужно изменить не только View но и сохранить изменения в FireStore и UserDefaults
      self?.interactor?.makeRequest(request: .changeSugarMetric(metric: metric))
    }
  }
  
 
 // MARK: SOcial Icons Singals
  @objc private func handleSocialButtonSignals(button: UIButton) {
    
    let socialNetwrokUrlString = socialNetwroksUrlString[button.tag]
    
    let webController = WebController(urlString: socialNetwrokUrlString)
    
    navigationController?.pushViewController(webController, animated: true)

  }
  
  
  private func setNavBarClousers() {
    settingView.customNavBar.didTapLogOutButton = {[weak self] in
     
      self?.handlelogOutButton()
    }
  }
}

// MARK: TableView Delegate and DataSource
extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return SettingSections.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = SettingSections(rawValue: indexPath.section) else {return UITableViewCell()}
    
    switch section {
    case .changeSugarMeuser:
      let cell = ChancgeSugarMeuserCell()
      cell.configureCell(viewModel: viewModel.sugarMetricsViewModel)
      setSugarMesuerclouser(sugarCell: cell)
      return cell
    case .socialLinks:
      let cell = SocialLinckCell()
      cell.fbButton.addTarget(self, action: #selector(handleSocialButtonSignals), for: .touchUpInside)
      cell.vkButton.addTarget(self, action: #selector(handleSocialButtonSignals), for: .touchUpInside)
      cell.youtubeButton.addTarget(self, action: #selector(handleSocialButtonSignals), for: .touchUpInside)
      return cell
    case .subscription:
      let cell = SubscriptionCell()
      return cell
    
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let section = SettingSections(rawValue: section) else {return ""}
    switch section {
    case .changeSugarMeuser:
      return "Ед. измерения глюкозы в крови"
    case .socialLinks:
      return "Социальные сети"
    case .subscription:
      return "Подписка"
    }
  }
  

  
}



 // MARK: Log Out
extension SettingsViewController {
  
 
  
  private func handlelogOutButton() {
    loadDataHUD.show(in: view)
    removeAllFireStoreListners()
    interactor?.makeRequest(request: .logOut)
    // Также нужно снять все листнеры
    
   
    
  }
  
  private func removeAllFireStoreListners() {
    let listner: ListnerService! = ServiceLocator.shared.getService()
    listner.removeAllListners()
  }
  
  private func getAnswerLogOut(result: Result<Bool,NetworkFirebaseError>) {
    
    switch result {
    case .success(_):
      
      let appState = AppState.shared
      
      appState.toogleMinorWindow(minorWindow: appState.loginRegisterWindow)
      appState.removeMainWindowController()
      
      
    case .failure(let error):
      
      showErrorMessage(text: error.localizedDescription)
    }
  }
  
}
