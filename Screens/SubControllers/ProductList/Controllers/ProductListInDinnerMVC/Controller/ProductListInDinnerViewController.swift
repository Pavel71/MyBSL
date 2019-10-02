//
//  ProductListInDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol ProductListInDinnerViewModalable {
  
  var dinnerItemResultsViewModel: ProductListResultsViewModel {get set}
  var productsData: [ProductListViewModel] {get set}
  var isPreviosDinner: Bool {get set}
}


class ProductListInDinnerViewController: BaseProductList {
  

  
  var viewModel: ProductListInDinnerViewModel! {
    
    didSet {
      self.dinnerItemResultsViewModel = viewModel.dinnerItemResultsViewModel

      self.tableViewData = viewModel.productsData
    }
  }
  
  var dinnerItemResultsViewModel: ProductListResultsViewModel! {
    didSet {
      footerView.resultsView.setViewModel(viewModel: dinnerItemResultsViewModel)
    }
  }
  
  var tableViewData: [ProductListViewModel] = []
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  
  override func setUpTableView() {
    super.setUpTableView()
    
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.cellID)
    tableView.keyboardDismissMode = .interactive
    
    
    
//    footerView.addNewProductInMealButton.addTarget(self, action: #selector(handleAddProductInMeal), for: .touchUpInside)
  }
  
  func setViewModel(viewModel: ProductListInDinnerViewModel) {
    self.viewModel = viewModel
    
    setResultViewModel()
  }
  
  private func setResultViewModel() {
    
    let productListResultViewModel = ConfirmProductListResultViewModel.calculateProductListResultViewModel(data: tableViewData)
    
    footerView.resultsView.setViewModel(viewModel: productListResultViewModel)
    
    tableView.reloadData()
  }


  
}


// MARK: TAP SOME BUTTONS
//extension ProductListInDinnerViewController {
//
//  @objc private func handleAddProductInMeal() {
//    print("Add New Product")
//  }
//
//}

extension ProductListInDinnerViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  // Здесь вот уже мне понадобится Custom ячейка с name и зщкешщт
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.cellID, for: indexPath) as! ProductListCell
    
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row], withInsulinTextFields: true, isPreviosDinner: viewModel.isPreviosDinner)
    
    setCellClousers(cell: cell)
    
    return cell
  }
  
  private func setCellClousers(cell:ProductListCell) {
    
    cell.didBeginEditingTextField = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField) // SuperClass
    }
    
    // PortionTextField Delegate
    
    cell.portionTextField.addTarget(self, action: #selector(didChangePortionTextField), for: .editingChanged)
    
    cell.insulinTextField.addTarget(self, action: #selector(didChangeInsulinTextField), for: .editingChanged)
    
    
//    cell.didPortionTextFieldEditing = {[weak self] textField in
//      self?.handlePortionTextFieldEndEditing(textField: textField)
//    }
//
//    cell.didInsulinTextFieldEditing = {[weak self] textField in
//      self?.handleInsulinTextFiedlEndEditing(textField: textField)}
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}


// MARK: TextFiedl Methods

extension ProductListInDinnerViewController {
  
  
  @objc private func didChangePortionTextField(textField: UITextField) {
    
    guard let indexPath = ComputedValueThanChangeOne.getIndexPathIntableViewForTextFiedl(textField: textField, tableView: tableView) else {return}
    
    let portion: Int = (textField.text! as NSString).integerValue
    
    let carboIn100GrmPoroduct = tableViewData[indexPath.row].carboIn100Grm
    
    // Изменит значение лейбла в зависимости от порции котрую мы вводим
    let carboInPortion = ComputedValueThanChangeOne.changeCarboInlabel(tableView: tableView, carboOn100Grm: carboIn100GrmPoroduct, portion: portion, indexPath: indexPath)
    
    
    // Подумать как приукрасит
    let sumPortion = CalculateValueTextField.calculateSumPortion(portion: portion,indexPath:indexPath, tableViewData: &tableViewData)
    let sumCarbo = CalculateValueTextField.calculateSumCarbo(carboInPortion:carboInPortion, indexPath: indexPath, tableViewData: &tableViewData)
    
    footerView.resultsView.portionResultLabel.text = String(sumPortion)
    footerView.resultsView.carboResultLabel.text = String(sumCarbo)

  }
  
  // MARK: DidChange InsulinFiedl
  @objc private func didChangeInsulinTextField(textField: UITextField) {
    guard let indexPath = ComputedValueThanChangeOne.getIndexPathIntableViewForTextFiedl(textField: textField, tableView: tableView) else {return}
    
    
    let sum = CalculateValueTextField.calculateSumInsulin(insulin: textField.text ?? "", indexPath: indexPath, tableViewData: &tableViewData)
    footerView.resultsView.insulinResultLabel.text = String(sum)
  }
  
  
  // здесь мне нужно ловаить данные приходящие с текстфилдов и сохранять их оперативке как минимум!
  
  private func handlePortionTextFieldEndEditing(textField: UITextField) {
    print("Portion End Editing")
    
    // Это все довольно катсыльно! Потомучто будет идти работа с реалмом!
    
    guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return}
    tableViewData[indexPath.row].portion = textField.text ?? "0"
    setResultViewModel()
    
  }
  
  private func handleInsulinTextFiedlEndEditing(textField: UITextField) {
    print("Insulin End Editing")
    
    guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return}
    tableViewData[indexPath.row].insulinValue = textField.text
    setResultViewModel()
    

  }
  
  private func getIndexPathIntableViewForTextFiedl(textField: UITextField) -> IndexPath? {
    
    let point = tableView.convert(textField.center, from: textField.superview)
    guard let indexPath = tableView.indexPathForRow(at: point) else {return nil}
    
    return indexPath
    
  }
  
  
}




// MARK: Header in Section
extension ProductListInDinnerViewController {
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = ProductListHeaderInSection(frame: .zero, withInsulinLabel: true)
    // Если продуктов нет то скрой хеадер
    header.isHidden = tableViewData.isEmpty
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return ProductListHeaderInSection.height
  }
  
}

// MARK: Swipe write to Delete

extension ProductListInDinnerViewController {

  // Delete Row
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить продукт") { (action, view, succsess) in
      
//      let productRow = indexPath.row
//
//      self.didDeleteProductFromMealClouser!(productRow, self.mealId)
      print("удалить продукт")
      
      succsess(true)
    }
    // Удаляет сам по индексу и не андо парится!
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  
}
