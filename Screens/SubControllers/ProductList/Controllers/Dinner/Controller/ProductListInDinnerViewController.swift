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
  
  // Clousers
  var didSelectTextFieldCellClouser: ((UITextField) -> Void)?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  
  override func setUpTableView() {
    
    super.setUpTableView()
    configureTableView()
    

  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.cellID)
    tableView.keyboardDismissMode = .interactive
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
  
  // MARK: AddNewProduct
  
  func addNewProduct(products: [ProductRealm]) {
    
    products.forEach { (product) in
      let productListViewModel = ProductListViewModel(insulinValue: product.insulin, carboIn100Grm: product.carbo, name: product.name, portion: product.portion)
      
      tableViewData.append(productListViewModel)
    }
    // Короче нужно пересчитывать размер ячейки до какого то кол-ва
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

// MARK: TableView Delegate Datasource

extension ProductListInDinnerViewController: UITableViewDataSource,UITableViewDelegate {
  
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
    
    cell.didChangeInsulinFromPickerView = {[weak self] textField in
      self?.didChangeInsulinTextField(textField: textField)
    }
    
//    cell.insulinTextField.addTarget(self, action: #selector(didChangeInsulinTextField), for: .editingChanged)
    
    
    cell.didPortionTextFieldEditing = {[weak self] textField in
      self?.handlePortionTextFieldEndEditing(textField: textField)
    }

    cell.didInsulinTextFieldEditing = {[weak self] textField in
      self?.handleInsulinTextFiedlEndEditing(textField: textField)}
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  // Высота Может стоит вынести это в Base я посмотрю
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.ProductList.cellHeight
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
    
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell
    
    let portion: Int = (textField.text! as NSString).integerValue
    
//    let carboIn100GrmPoroduct = tableViewData[indexPath.row].carboIn100Grm
    
    // Изменит значение лейбла в зависимости от порции котрую мы вводим
//    let carboInPortion = ComputedValueThanChangeOne.changeCarboInlabel(tableView: tableView, carboOn100Grm: carboIn100GrmPoroduct, portion: portion, indexPath: indexPath)
    
    // Этот коэффициент нужно сохранять в ячейке! или модели данных!
//    let carboIn100GrmPoroduct = tableViewData[indexPath.row].carboIn100Grm
//
//    let carboInPortion: Int = CalculateValueTextField.calculateCarboInPortion(carboIn100grm: carboIn100GrmPoroduct, portionSize: portion)
//
//
//
//
//
    
    // Подумать как приукрасит
    let sumPortion = CalculateValueTextField.calculateSumPortion(portion: portion,indexPath:indexPath, tableViewData: &tableViewData)
    
    // Это Computed Property  и оно высчитывается после сета  Portion
    cell.carboInPortionLabel.text = String(tableViewData[indexPath.row].carboInPortion)
    
    
    
    let sumCarbo = CalculateValueTextField.calculateSumCarbo(indexPath: indexPath, tableViewData: &tableViewData)
    
    footerView.resultsView.portionResultLabel.text = String(sumPortion)
    footerView.resultsView.carboResultLabel.text = String(sumCarbo)

  }
  
  // MARK: DidChange InsulinFiedl
  @objc private func didChangeInsulinTextField(textField: UITextField) {
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: textField) else {return}
    
    let insulin = (textField.text! as NSString).floatValue
    
    let sum = CalculateValueTextField.calculateSumInsulin(insulin: insulin, indexPath: indexPath, tableViewData: &tableViewData)
    footerView.resultsView.insulinResultLabel.text = String(sum)
  }
  
  
  // Эти методы нужны когда будем слать запросы в реалм
  
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
    let header = ProductListHeaderInSection(frame: .zero, withInsulinLabel: true)
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
