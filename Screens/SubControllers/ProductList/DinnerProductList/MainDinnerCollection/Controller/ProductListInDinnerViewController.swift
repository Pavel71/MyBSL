//
//  ProductListInDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductListInDinnerViewController: BaseProductList {
  

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
  
  var tableViewData: [ProductListViewModel] = []
  
  // Clousers
  var didSelectTextFieldCellClouser: ((UITextField) -> Void)?
  var didDeleteProductClouser:(([ProductRealm]) -> Void)?
  
  var didPortionTextFieldChangetToDinnerController: ((String,Int) -> Void)?
  var didInsulinTextFieldChangetToDinnerController: ((String,Int) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  override func setUpTableView() {
    
    super.setUpTableView()
    configureTableView()
    
    
  }
  
  
  // MARK: AddNewProduct
  
  func addNewProduct(products: [ProductRealm]) {
    
    tableViewData.append(contentsOf: products.map(getProductListViewModelFromProductReal))

    tableView.reloadData()
    
  }
  
  private func getProductListViewModelFromProductReal(product: ProductRealm) -> ProductListViewModel {
    let productListViewModel = ProductListViewModel(insulinValue: product.insulin, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
    return productListViewModel
  }


  
}

// MARK: Set UP Views

extension ProductListInDinnerViewController {
  
 
  
  private func configureTableView() {
    tableView.dataSource = self
    tableView.register(MainDinnerProductListCell.self, forCellReuseIdentifier: MainDinnerProductListCell.cellId)
    tableView.keyboardDismissMode = .interactive
  }
  
  func setViewModel(viewModel: ProductListInDinnerViewModel) {
    
    tableView.tableHeaderView = viewModel.productsData.count == 0 ? headerView : nil
    
    self.viewModel = viewModel
    setResultViewModel()
  }
  
  private func setResultViewModel() {
    
    let productListResultViewModel = ConfirmProductListResultViewModel.calculateProductListResultViewModel(data: tableViewData)
    
    footerView.resultsView.setViewModel(viewModel: productListResultViewModel)
    
    tableView.reloadData()
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
    
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row], withInsulinTextFields: true, isPreviosDinner: viewModel.isPreviosDinner)
    
    setCellClousers(cell: cell)
    
    return cell
  }
  
  private func setCellClousers(cell:MainDinnerProductListCell) {
    
    cell.didBeginEditingTextField = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField) // SuperClass
    }
    
    // PortionTextField Delegate
    
//    cell.portionTextField.addTarget(self, action: #selector(didChangePortionTextField), for: .editingChanged)
    cell.didChangePortionFromPickerView = {[weak self] textField in
      self?.didChangePortionTextField(textField: textField)
    }
    
    cell.didChangeInsulinFromPickerView = {[weak self] textField in
      self?.didChangeInsulinTextField(textField: textField)
    }

    cell.didPortionTextFieldEditing = {[weak self] textField in
      self?.handlePortionTextFieldEndEditing(textField: textField)
    }

    cell.didInsulinTextFieldEditing = {[weak self] textField in
      self?.handleInsulinTextFiedlEndEditing(textField: textField)}
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
}


// MARK: TextFiedl Methods



extension ProductListInDinnerViewController:UITextFieldDelegate {
  
  internal func textFieldDidBeginEditing(_ textField: UITextField) {
        didSelectTextFieldCellClouser!(textField)
      }
  
  
  // Обрабатываем изменения Порции в режиме ввода
  @objc private func didChangePortionTextField(textField: UITextField) {

    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: textField) else {return}
    guard let text = textField.text else {return}
    
    let cell = tableView.cellForRow(at: indexPath) as! MainDinnerProductListCell
    
    let portion: Int = (text as NSString).integerValue

    
    // Подумать как приукрасит
    let sumPortion = CalculateValueTextField.calculateSumPortion(portion: portion,indexPath:indexPath, tableViewData: &tableViewData)
    
    // Это Computed Property  и оно высчитывается после сета  Portion
    cell.carboInPortionLabel.text = String(tableViewData[indexPath.row].carboInPortion)
    
    
    
    let sumCarbo = CalculateValueTextField.calculateSumCarbo(indexPath: indexPath, tableViewData: &tableViewData)
    
    footerView.resultsView.portionResultLabel.text = String(sumPortion)
    footerView.resultsView.carboResultLabel.text = String(sumCarbo)
    
    
    // Вообщем я сделаю ввод порций picker
    // Потом если мы сохраняем а общий рещлуьтат по порциям или инсулинам 0 то выводить соответвующие сообщения
    // + сделать тоже самое по продуктам!
    // Это будет нормальным решением!
    
    // Здесь нам нужно передать какой именно продукт мы редактируем! Чтобы Main Controller  знал об этом!
    
    didPortionTextFieldChangetToDinnerController!(text,indexPath.row)

  }
  
  // MARK: DidChange InsulinFiedl
  @objc private func didChangeInsulinTextField(textField: UITextField) {
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: textField) else {return}
    guard let text = textField.text else {return}
    
    let insulin = (text as NSString).floatValue
    
    let sum = CalculateValueTextField.calculateSumInsulin(insulin: insulin, indexPath: indexPath, tableViewData: &tableViewData)
    footerView.resultsView.insulinResultLabel.text = String(sum)
    
    didInsulinTextFieldChangetToDinnerController!(text,indexPath.row)

  }
  
  
  // Эти методы нужны когда будем слать запросы в реалм
  
  // А может и нужно будет удалить это нафиг!
  
  private func handlePortionTextFieldEndEditing(textField: UITextField) {
    print("Portion End Editing")


  }

  private func handleInsulinTextFiedlEndEditing(textField: UITextField) {
    print("Insulin End Editing")

//    guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return}



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
      let dummyRealmProduct = ProductRealm(name: productViewModel.name, category: "", carbo: productViewModel.carboIn100Grm, isFavorits: false)
      
      
      print("Удаление продукта")
      self.didDeleteProductClouser!([dummyRealmProduct])
      
      succsess(true)
    }
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  
}
