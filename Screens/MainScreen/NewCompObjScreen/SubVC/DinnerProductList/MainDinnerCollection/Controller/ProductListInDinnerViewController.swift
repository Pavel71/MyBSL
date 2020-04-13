//
//  ProductListInDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductListInDinnerViewController: BaseProductList {
  
  
  
  // ToolBar
  
  var insulinTitleLabel: UILabel = {
    let l = UILabel()
    l.text = "Всего инсулина:"
    
    return l
  }()
  
  var insulinLabel: UILabel = {
    let l  = UILabel()
    l.text = ""

    return l
  }()
  
  var sugarCompansationInsulin: Float = 0
  
  // Try To Set Acsessuary View
  
  lazy var insulinLabelToolBar: UIToolbar = {
    
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.KeyBoard.doneToolBarHeight))
    doneToolbar.barStyle = .default
    
    let insulinTL = UIBarButtonItem(customView: insulinTitleLabel)
    let insulinValueLabel = UIBarButtonItem(customView: insulinLabel)
    
    let flexSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let flexSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(doneButtonAction))
    
    let items = [insulinTL,flexSpaceLeft,insulinValueLabel,flexSpaceRight, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    return doneToolbar
  }()
  

  var viewModel: ProductListInDinnerViewModel! {
    
    didSet {
      self.dinnerItemResultsViewModel = viewModel.resultsViewModel
      self.tableViewData = viewModel.productsData
    }
  }
  
  var dinnerItemResultsViewModel: ProductListResultsViewModel! {
    didSet {
      footerView.resultsView.setViewModel(viewModel: dinnerItemResultsViewModel)
    }
  }
  
  var tableViewData: [ProductListViewModel] = [] {
    
    didSet {
      tableView.tableFooterView = tableViewData.isEmpty ? nil : footerView
    }
  }
  
  // ML Worker For Fast Predict Insulin By Carbo
  private var mlWorkerByFood  = MLWorker(typeWeights: .correctCarboByInsulinWeights)
  
  // Clousers
  var didSelectTextFieldCellClouser: TextFieldPassClouser?
  var didDeleteProductClouser:(([ProductRealm]) -> Void)?
  
  
  
  
  
//  var didPortionTextFieldChangetToDinnerController: ((Int,Int) -> Void)?
//  var didInsulinTextFieldChangetToDinnerController: ((Float,Int) -> Void)?
  
  var didPortionTextFieldEndEditingToDinnerController: ((Int,Int) -> Void)?
  var didInsulinTextFieldEndEditingToDinnerController: ((Float,Int) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  override func setUpTableView() {
    
    super.setUpTableView()
    configureTableView()
    
    
  }
  
  


  
}

// MARK: Set UP Views

extension ProductListInDinnerViewController {
  
 
  
  private func configureTableView() {
    
    tableView.tableHeaderView = headerView
    tableView.dataSource      = self
    tableView.register(MainDinnerProductListCell.self, forCellReuseIdentifier: MainDinnerProductListCell.cellId)
    tableView.keyboardDismissMode = .interactive
  }
  
  func setViewModel(viewModel: ProductListInDinnerViewModel) {
    
    
    
    tableView.tableHeaderView = viewModel.productsData.count == 0 ? headerView : nil
    
    self.viewModel = viewModel
    self.sugarCompansationInsulin = viewModel.compansationSugarInsulin
    
    setResultViewModel(resultViewModel:viewModel.resultsViewModel)
    
    let sumCarboInsulin = self.viewModel.resultsViewModel.sumInsulinFloat.roundToDecimal(2)
    let sugarInsulin = self.sugarCompansationInsulin.roundToDecimal(2)
    
    let allInsulin = sumCarboInsulin + sugarInsulin
    self.updateInsulinLabelInToolBar(insulinValue: allInsulin)
    
    
  }
  
  private func setResultViewModel(resultViewModel:ProductListResultViewModelable ) {
    
    footerView.resultsView.setViewModel(viewModel: resultViewModel)
    
    tableView.reloadData()
    
  }
}

// MARK: Signals

extension ProductListInDinnerViewController {
  
  @objc private func doneButtonAction() {
    self.view.endEditing(true)
  }
  
  func setAllInsulinLabelValue(allInsulin: Float) {
    insulinLabel.text = "\(allInsulin)"
    insulinLabel.sizeToFit()
    
  }
  
}




// MARK: TableView Delegate Datasource

extension ProductListInDinnerViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  // Здесь вот уже мне понадобится Custom ячейка с name и зщкешщт
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: MainDinnerProductListCell.cellId, for: indexPath) as! MainDinnerProductListCell
    
    cell.insulinTextField.inputAccessoryView = insulinLabelToolBar
    cell.portionTextField.inputAccessoryView = insulinLabelToolBar
    
    cell.setViewModel(
      viewModel: tableViewData[indexPath.row],
      withInsulinTextFields: true
    )
    
    setCellClousers(cell: cell)
    
    return cell
  }
  // MARK: Set Cell CLousers
  private func setCellClousers(cell:MainDinnerProductListCell) {
    
    cell.didBeginEditingTextField = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField) // Pass Signal to SuperClass
      
      // Здесь нужно запустить метод который посчитает значение insulinLabel
      
    }
    
    // PortionTextField Delegate
    
    

    cell.didChangePortionFromPickerView = {[weak self] textField in
      self?.didChangePortionTextField(textField: textField)
    }
    
    cell.didChangeInsulinFromPickerView = {[weak self] textField in
      self?.didChangeInsulinTextField(textField: textField)
    }

    cell.didPortionTextFieldEditing = {[weak self] textField in
      
      guard let (portion,indexpath) = self?.getValueAndRowTextField(textField: textField) else {return}
   self?.didPortionTextFieldEndEditingToDinnerController!(Int(portion),indexpath.row)
           
      
    }

    cell.didInsulinTextFieldEditing = {[weak self] textField in
      guard let (isnulinValue,indexpath) = self?.getValueAndRowTextField(textField: textField) else {return}
   self?.didInsulinTextFieldEndEditingToDinnerController!(isnulinValue,indexpath.row)
      
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
}


// MARK: TextFiedl Methods



extension ProductListInDinnerViewController: UITextFieldDelegate {
  
  internal func textFieldDidBeginEditing(_ textField: UITextField) {
        didSelectTextFieldCellClouser!(textField)
      }
  
  
  // Обрабатываем изменения Порции в режиме ввода
  @objc private func didChangePortionTextField(textField: UITextField) {

    
    guard let (portion,indexPath) = getValueAndRowTextField(textField: textField) else {return}
    let cell = tableView.cellForRow(at: indexPath) as! MainDinnerProductListCell
    
    tableViewData[indexPath.row].portion = Int(portion)
    let carboInPortion = tableViewData[indexPath.row].carboInPortion

    // Подумать как приукрасит
    let sumPortion = CalculateValueTextField.calculateSumPortion(portion: Int(portion),indexPath:indexPath, tableViewData: &tableViewData)
    
    cell.carboInPortionLabel.text = String(carboInPortion)

    let sumCarbo = CalculateValueTextField.calculateSumCarbo(indexPath: indexPath, tableViewData: &tableViewData)
    
    footerView.resultsView.portionResultLabel.text = String(sumPortion)
    footerView.resultsView.carboResultLabel.text = String(sumCarbo)
    
    // Set insulin To Visual

    
    guard let insulin  = getPredictInsulinByCarbo(carbo: Float(carboInPortion)) else {return}
    cell.insulinTextField.text = "\(insulin)"
    let sum = CalculateValueTextField.calculateSumInsulin(insulin: insulin, indexPath: indexPath, tableViewData: &tableViewData)
    footerView.resultsView.insulinResultLabel.text = "\(floatTwo: sum)"
    
    let allInsulin = sum.roundToDecimal(2) + sugarCompansationInsulin.roundToDecimal(2)
    updateInsulinLabelInToolBar(insulinValue: allInsulin)


  }
  
  private func updateInsulinLabelInToolBar(insulinValue: Float) {
    insulinLabel.text = "\(insulinValue)"
    insulinLabel.sizeToFit()
  }
  
  
  
  private func getPredictInsulinByCarbo(carbo: Float) -> Float? {
     let insulinByCarbo = mlWorkerByFood.getPredict(testData: [Float(carbo)])
    
    return insulinByCarbo.first?.roundToDecimal(2)
  }
  
  // MARK: DidChange InsulinFiedl
  @objc private func didChangeInsulinTextField(textField: UITextField) {

    
    guard let (insulin,indexPath) = getValueAndRowTextField(textField: textField) else {return}
    let cell = tableView.cellForRow(at: indexPath) as! MainDinnerProductListCell
    cell.insulinTextField.text = "\(insulin)"
    
    let sum = CalculateValueTextField.calculateSumInsulin(insulin: insulin, indexPath: indexPath, tableViewData: &tableViewData)
    footerView.resultsView.insulinResultLabel.text = "\(floatTwo: sum)"
    
    let allInsulin = sum.roundToDecimal(2) + sugarCompansationInsulin.roundToDecimal(2)
    updateInsulinLabelInToolBar(insulinValue: allInsulin)


  }
  
  
  
  
  private func getValueAndRowTextField(textField: UITextField) ->(Float,IndexPath)? {
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: textField) else {return nil}
    guard let text = textField.text else {return nil}
    
    let value = (text as NSString).floatValue
    
    return (value,indexPath)
  }
  

  
  
}




// MARK: Header in Section
extension ProductListInDinnerViewController {
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = ProductListHeaderInSection(withInsulinLabel: true,temaColor: .darkGray)
    // Если продуктов нет то скрой хеадер
    header.isHidden = tableViewData.isEmpty
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.ProductList.headerInSectionHeight
  }
  
}

// MARK: Swipe write to Delete

extension ProductListInDinnerViewController {

  // Delete Row
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить продукт") { (action, view, succsess) in
      
      let productViewModel = self.tableViewData[indexPath.row]
      let dummyRealmProduct = ProductRealm(
        name: productViewModel.name,
        category: "",
        carboIn100Grm: productViewModel.carboIn100Grm,
        isFavorits: false
      )
      
      
      self.didDeleteProductClouser!([dummyRealmProduct])
      
      succsess(true)
    }
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  
}
