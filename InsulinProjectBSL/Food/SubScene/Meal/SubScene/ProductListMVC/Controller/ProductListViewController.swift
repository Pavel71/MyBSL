//
//  ProductListViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 16/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


//
//  ProductsTableViewInMealCell.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 12/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit
import ProgressHUD



class ProductListViewController: UIViewController {
  
  var footerView = ProductsTableViewInMealCellFooterView(frame: .init(x: 0, y: 0, width: 0, height: ProductsTableViewInMealCellFooterView.footerHeight))
  
  var tableView = UITableView(frame: .zero, style: .plain)
  var headerView = ProductListTableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: ProductListTableHeaderView.height))
  
  var mealId: String = ""
  
  var tableViewData: [MealViewModel.ProductCell] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  init() {
    print("Init Product Controller")
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    print("Deinit Product controlelr")
  }
  
  // Clousers
  
  var didChangePortionSizeClouser: ((Int,Int,String) -> Void)?
  var didSelectTextFieldInMealCellClouser: ((UITextField) -> Void)?
  var didDeleteProductFromMealClouser: ((Int,String) -> Void)?
  var didAddProductInMealClouser: ((String) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
  }
  
  private func setUpTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.cellID)
    
    footerView.addNewProductInMealButton.addTarget(self, action: #selector(handleAddProductInMeal), for: .touchUpInside)
    tableView.tableFooterView = footerView // footerView
    

 
  }
 
  
  func setViewModel(viewModel: ProductListViewModelable) {
    
    mealId = viewModel.mealId
    tableViewData = viewModel.productsData
    
    tableView.tableHeaderView = tableViewData.count == 0 ? headerView : nil
  }
  
  // MARK: Add Product In Meal TableViewFooter
  
  @objc private func handleAddProductInMeal() {
    didAddProductInMealClouser!(mealId)
  }
  
  
  
  // MARK: Carbo In Portion Change
  // Этот метод интересен если мы будем сразу же изменять колво углеводов в порции
  @objc private func handleTextFieldDidChange(textField: UITextField) {
    
    changeCarboInPortionFromPortionSize(textField: textField)
  }

  
  private func changeCarboInPortionFromPortionSize(textField: UITextField) {
    
    guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return}
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell
    
    // Этот коэффициент нужно сохранять в ячейке! или модели данных!
    let carboIn100GrmPoroduct = tableViewData[indexPath.row].carboIn100Grm
    
    let portion: Int = (textField.text! as NSString).integerValue
    
    let carboInPortion: Int = Calculator.calculateCarboInPortion(carboIn100grm: carboIn100GrmPoroduct, portionSize: portion)

    cell.carboInPortionLabel.text = String(carboInPortion)
  }
  
  private func getIndexPathIntableViewForTextFiedl(textField: UITextField) -> IndexPath? {
    
    let point = tableView.convert(textField.center, from: textField.superview)
    guard let indexPath = tableView.indexPathForRow(at: point) else {return nil}
    
    return indexPath
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
 
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  // Здесь вот уже мне понадобится Custom ячейка с name и зщкешщт
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.cellID, for: indexPath) as! ProductListCell
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row])
    
    // PortionTextField Delegate
    cell.portionTextField.addTarget(self, action: #selector(handleTextFieldDidChange), for: .editingChanged)
    cell.portionTextField.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.Meal.ProductCell.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell
    cell.portionTextField.becomeFirstResponder()
    print("cell in meal")
  }
  
  
  
}

// Похоже что нужн овешать кейбоард натификацию!

// MARK: TextField Delegate
extension ProductListViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("Первая активация")
    didSelectTextFieldInMealCellClouser!(textField)
    
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let text = textField.text else {return}
    if text.isEmpty {
      ProgressHUD.showError("Продукт не будет учтен при расчете так как вы оставили поле пустым!")
      // Можно отправить запрос на удаление продукта! Типа нафига он тогда нужен!
    } else {
      
      // Также нужен row и mealID
      guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return}
      let row = indexPath.row
      let portionInt = Int(text)!
      didChangePortionSizeClouser!(portionInt,row,mealId)
    }
    
    print("Конец работы с textFieldom")
    
    
  }
  
  
}


// MARK: Header in Section
extension ProductListViewController {
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = ProductListHeaderInSection()
    // Если продуктов нет то скрой хеадер
    header.isHidden = tableViewData.isEmpty
    return header
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return ProductListHeaderInSection.height
  }
}

// MARK: Swiping Delete

extension ProductListViewController {
  
  // Delete Row
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить продукт") { (action, view, succsess) in
      
      let productRow = indexPath.row
      
      self.didDeleteProductFromMealClouser!(productRow, self.mealId)

      succsess(true)
    }
    // Удаляет сам по индексу и не андо парится!
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
}


