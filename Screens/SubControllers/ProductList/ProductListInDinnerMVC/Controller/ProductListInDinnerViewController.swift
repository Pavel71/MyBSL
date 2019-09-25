//
//  ProductListInDinnerViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class ProductListInDinnerViewController: BaseProductList {
  
  
  var tableViewData: [ProductViewModel] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  
  override func setUpTableView() {
    super.setUpTableView()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.cellID)
    
    footerView.addNewProductInMealButton.addTarget(self, action: #selector(handleAddProductInMeal), for: .touchUpInside)
  }
  
  func setViewModel(viewModel: ProductListInMealViewModel) {
    
    tableViewData = viewModel.productsData
    
    tableView.tableHeaderView = tableViewData.count == 0 ? headerView : nil
  }
  

  
  
}


// MARK: TAP SOME BUTTONS
extension ProductListInDinnerViewController {
  
  @objc private func handleAddProductInMeal() {
    print("Add New Product")
  }
}

extension ProductListInDinnerViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  // Здесь вот уже мне понадобится Custom ячейка с name и зщкешщт
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.cellID, for: indexPath) as! ProductListCell
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row], withInsulinTextFields: true)
    setClousers(cell: cell)
    
    return cell
  }
  
  private func setClousers(cell:ProductListCell) {
    
    cell.didBeginEditingTextField = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField) // SuperClass
    }
    
    // PortionTextField Delegate
    
    cell.portionTextField.addTarget(self, action: #selector(didChangePortionTextField), for: .editingChanged)
    cell.didPortionTextFieldEditing = {[weak self] textField in
      self?.handlePortionTextFieldEndEditing(textField: textField)
    }
    
    cell.didInsulinTextFieldEditing = {[weak self] textField in
      self?.handleInsulinTextFiedlEndEditing(textField: textField)}
  }
  
}


// MARK: TextFiedl Methods

extension ProductListInDinnerViewController {
  
  @objc private func didChangePortionTextField(textField: UITextField) {
    
    guard let indexPath = ChangeCarboInlabel.getIndexPathIntableViewForTextFiedl(textField: textField, tableView: tableView) else {return}
    
    let portion: Int = (textField.text! as NSString).integerValue
    
    let carboIn100GrmPoroduct = tableViewData[indexPath.row].carboIn100Grm
    
    // Изменит значение лейбла в зависимости от порции котрую мы вводим
    ChangeCarboInlabel.changeCarboInlabel(tableView: tableView, carboOn100Grm: carboIn100GrmPoroduct, portion: portion, indexPath: indexPath)
  }
  
  private func handlePortionTextFieldEndEditing(textField: UITextField) {
    print("Portion End Editing")
  }
  
  private func handleInsulinTextFiedlEndEditing(textField: UITextField) {
    print("Insulin End Editing")
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
