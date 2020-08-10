//
//  LearnByCorrectionVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// 1. Нужно добавить хедер с описанием какие у нас поля
// 2. Нужно добавить свитчер чтобы переключить моли в граммы
// 3. Добавить знак вопроса и показать алерт снова!
// 4. Добавить viewmodel и сделать функцию валидации по заполнению полей инсулина

class LearnByCorrectionVC: UIViewController,PagesViewControllerable {
  
  var didIsNextButtonValid: ((Bool) -> Void)?

  var nextButtonIsValid: Bool = false {
    
    didSet {
      didIsNextButtonValid!(nextButtonIsValid)
    }
    
  }
  
  var mainView : LearnByCorrectionView!
  
  var tableView: UITableView!
  
  var rangeSlider = RangeSlider(frame: .zero)
  
  
  
  var tableData: [LearnByCorrectionCellModal] = []
  
  var viewModel: LearnByCorrectionVM!
  
  // KeyBoard Notification
  
  var textFieldSelectedPoint: CGPoint!
  
  init(didIsNextButtonValid:@escaping ((Bool) -> Void),viewModel: LearnByCorrectionVM) {
    super.init(nibName: nil, bundle: nil)
    
    self.viewModel = viewModel
    self.didIsNextButtonValid = didIsNextButtonValid
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    configureVM()
    setUpViews()
    updateUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setKeyboardNotification()
    tableView.reloadData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    NotificationCenter.default.removeObserver(self)
  }
}

//MARK: Configure VM

extension  LearnByCorrectionVC {
  
  private func configureVM() {
    
    viewModel.didUpdateValidForm = {[weak self] isValid in
      self?.nextButtonIsValid = isValid
      
    }
  }
  
  // MARK: Update UI
  
  private func updateUI() {
    
    mainView.sugarLevelView.setViewModel(viewModel: viewModel.getSugarLevelModelToUpdateUI())
    tableData = viewModel.getTableData()
    tableView.reloadData()
  }
}

// MARK: Set Up Views

extension LearnByCorrectionVC {
  
  private func setUpViews() {
    
    mainView    = LearnByCorrectionView()
    tableView   = mainView.tableView

    
    
    
    configureTableView()
    setViewsClousers()

    
    view.addSubview(mainView)
    mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    
    view.addSubview(rangeSlider)
    
    
  }
  
  
  
  
  
  
  // MARK: Set Clousers
  private func setViewsClousers() {
    
    rangeSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
    mainView.sugarMetricView.cell.didMetrticsChange = {[weak self] metric in
      self?.didCnahgeMetric(metric: metric)
    }
  }
  
  
  
  private func configureTableView() {
    
    tableView.delegate            = self
    tableView.dataSource          = self
    tableView.allowsSelection     = false
    tableView.keyboardDismissMode = .interactive
    tableView.tableFooterView     = UIView()
    tableView.separatorStyle      = .none
    
    tableView.register(LearnByCorrectionSugarCell.self, forCellReuseIdentifier: LearnByCorrectionSugarCell.cellID)
    
    tableView.tableHeaderView = LearnByCorrectionHeader(frame: .init(x: 0, y: 0, width: 0, height: 50))
  }
  
  override func viewDidLayoutSubviews() {
    
    let margin: CGFloat = 20
    let width = view.bounds.width - 2 * margin
    let height: CGFloat = 30
    
    
    rangeSlider.frame = CGRect(x: 0, y: 0,
                               width: width, height: height)
    let x = mainView.sugarLevelView.rangeSliderContentView.center.x
    let y = mainView.sugarLevelView.rangeSliderContentView.center.y + 140
    rangeSlider.center = CGPoint(x: x, y: y)
    
  }
  
}
 
//MARK: Signals

extension LearnByCorrectionVC {
  
  // MARK: Slider Value
  
  @objc private  func  sliderValueChange(slider: RangeSlider) {
    
    let lowerSliderValue  = slider.lowerValue
    let higherSliderValue = slider.upperValue
    
    // Обнвои Модельку
    viewModel.updateSugarLevelVM(
      lowerSliderValue: lowerSliderValue, higherSliderValue: higherSliderValue)
    // Обнови UI
    updateUI()
    
  }
  
  
  // MARK: Change Metric
  
  private func didCnahgeMetric(metric: SugarMetric) {
    
   let lowerSliderValue  = rangeSlider.lowerValue
   let higherSliderValue = rangeSlider.upperValue
    viewModel.setMetric(
      metric            : metric,
      lowerSliderValue  : lowerSliderValue,
      higherSliderValue : higherSliderValue)
    
    updateUI()
    
  }
}

// MARK: TableView Delegate DataSource
extension LearnByCorrectionVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LearnByCorrectionSugarCell.cellID, for: indexPath) as! LearnByCorrectionSugarCell
    
    cell.setViewModel(viewModel: tableData[indexPath.row])
    setCellClouser(cell: cell)
    
    return cell
  }
  
  private func setCellClouser(cell: LearnByCorrectionSugarCell) {
    
    cell.passInsulinTextField = {[weak self] insulinTextField in
      
      guard let index = self?.tableView.indexPath(for: cell)!.row else {return}
      let insulin = (insulinTextField.text! as NSString).doubleValue
      self?.setTextFiedlPoint(textField: insulinTextField)
      self?.viewModel.addInsulinInObject(insulinValue: insulin, index: index)
    }
    
  }

}


// MARK: Work with Keyaboard Notification

extension LearnByCorrectionVC {
  
  
  
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
      self.rangeSlider.transform = isMove ? CGAffineTransform(translationX: 0, y: -diff) : .identity
      
     }
     

   }
  
}
