//
//  ProductListViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 16/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//



import UIKit
import ProgressHUD



class ProductListInMealViewController: UIViewController {
  
  var footerView = ProductsTableViewInMealCellFooterView(frame: .init(x: 0, y: 0, width: 0, height: Constants.ProductList.TableFooterView.footerHeight))
  
  var tableView = UITableView(frame: .zero, style: .plain)
  var headerView = ProductListTableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: ProductListTableHeaderView.height))
  
  
  // View Model ProductList
  
  
  var mealId: String = ""
  var tableViewData: [ProductListViewModel] = []
  
  
  
  init() {
    
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    print("Deinit Product controlelr")
  }
  
  // Clousers
  
  var didChangePortionTextFieldClouser: ((Int,Int,String) -> Void)?
  var didSelectTextFieldCellClouser: ((UITextField) -> Void)?
  var didDeleteProductFromMealClouser: ((Int,String) -> Void)?
  var didAddProductInMealClouser: ((String) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    
    setUpTableView()
  }
  
  private func setUpTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    
    tableView.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.cellID)
    
//    footerView.addNewProductInMealButton.addTarget(self, action: #selector(handleAddProductInMeal), for: .touchUpInside)
    tableView.tableFooterView = footerView // footerView
    

 
  }
  
 
  
  func setViewModel(viewModel: ProductListInMealViewModel) {
    
    
    if let mealId = viewModel.mealId  {
      self.mealId = mealId
    }
    tableViewData = viewModel.productsData
    
    let productListResultViewModel = ConfirmProductListResultViewModel.calculateProductListResultViewModel(data: tableViewData)
    
    footerView.resultsView.setViewModel(viewModel: productListResultViewModel,withInsulin: false)

    tableView.tableHeaderView = tableViewData.count == 0 ? headerView : nil
    tableView.reloadData()
  }
  
  // MARK: Add Product In Meal TableViewFooter
  
  @objc private func handleAddProductInMeal() {
    didAddProductInMealClouser!(mealId)
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
 
}

extension ProductListInMealViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  // Здесь вот уже мне понадобится Custom ячейка с name и зщкешщт
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.cellID, for: indexPath) as! ProductListCell
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row], withInsulinTextFields: false)
    setClousers(cell: cell)
   
    
    return cell
  }
  
  private func setClousers(cell:ProductListCell) {
    
    cell.didBeginEditingTextField = {[weak self] textField in
      self?.handleTextFieldDidBeginEditing(textField)
    }
    
    // PortionTextField Delegate
    cell.portionTextField.addTarget(self, action: #selector(handlePortionTextFieldDidChange), for: .editingChanged)
    cell.didPortionTextFieldEditing = {[weak self] textField in
      self?.handlePortionTextFieldEndEditing(textField: textField)
    }
    // AddNewProductInMeal
    


    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.ProductList.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell
    cell.portionTextField.becomeFirstResponder()
    
  }
  
  
  
}

// Похоже что нужн овешать кейбоард натификацию!

// MARK: TextField Delegate
extension ProductListInMealViewController: UITextFieldDelegate {
  
  func handleTextFieldDidBeginEditing(_ textField: UITextField) {
    didSelectTextFieldCellClouser!(textField)
  }

  // MARK: Carbo In Portion Change
  // Этот метод интересен если мы будем сразу же изменять колво углеводов в порции
  @objc private func handlePortionTextFieldDidChange(textField: UITextField) {
    
    changeCarboInPortionFromPortionSize(textField: textField)
  }
  
  
  private func changeCarboInPortionFromPortionSize(textField: UITextField) {
    
    guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return}
    let cell = tableView.cellForRow(at: indexPath) as! ProductListCell

    let portion: Int = (textField.text! as NSString).integerValue

    let sumPortion = CalculateValueTextField.calculateSumPortion(portion: portion, indexPath: indexPath, tableViewData: &tableViewData)
    
    cell.carboInPortionLabel.text = String(tableViewData[indexPath.row].carboInPortion)
    
    let sumCarbo = CalculateValueTextField.calculateSumCarbo(indexPath: indexPath, tableViewData: &tableViewData)
    
    footerView.resultsView.carboResultLabel.text = String(sumCarbo)
    footerView.resultsView.portionResultLabel.text = String(sumPortion)
  }
  

  
  private func getIndexPathIntableViewForTextFiedl(textField: UITextField) -> IndexPath? {
    
    let point = tableView.convert(textField.center, from: textField.superview)
    guard let indexPath = tableView.indexPathForRow(at: point) else {return nil}
    
    return indexPath
  }

  
  func handlePortionTextFieldEndEditing(textField: UITextField) {

    guard let text = textField.text else {return}
    
    if text.isEmpty {
      textField.text = "0"
      ProgressHUD.showError("Продукт не будет учтен при расчете так как вы оставили поле пустым!")

    } else {
      guard let row = getRowProductThanChangePortion(textField: textField) else {return}
      let portionInt = Int(text)!
      
      // Отправляем результат на MealController и в Реалм
      didChangePortionTextFieldClouser!(portionInt,row,mealId)
    }
    
  }

  
  private func getRowProductThanChangePortion(textField: UITextField) -> Int? {
    guard let indexPath = getIndexPathIntableViewForTextFiedl(textField: textField) else {return nil}
    return indexPath.row
  }
  
  
}


// MARK: Header in Section
extension ProductListInMealViewController {
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let header = ProductListHeaderInSection(frame: .zero, withInsulinLabel: false)
    // Если продуктов нет то скрой хеадер
    header.isHidden = tableViewData.isEmpty
    
    return header
  }
  // Sections
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constants.ProductList.headerInSectionHeight
  }
}

// MARK: Swiping Delete

extension ProductListInMealViewController {
  
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


