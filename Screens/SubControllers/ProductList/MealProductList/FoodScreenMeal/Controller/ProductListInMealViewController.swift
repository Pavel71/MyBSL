//
//  ProductListViewController.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 16/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//



import UIKit




class ProductListInMealViewController: BaseProductList {

  var valueColor: UIColor!
  
  
  var mealId: String = ""
  var tableViewData: [ProductListViewModel] = []
  
  
  // Здесь нужно ввести ряд настроек
  //1.Цвет лабел должен быть белый
  //2. тексфилды не нужны только Лаблы
  
  
  override init() {
    
    super.init()
  }
  
  deinit {
    print("Deinit Product controlelr")
  }
  
  // Clousers
  
  var didChangePortionTextFieldClouser: ((Int,String,String) -> Void)?
  var didSelectTextFieldCellClouser: ((UITextField) -> Void)?
  var didDeleteProductFromMealClouser: ((String,String) -> Void)?
  var didAddProductInMealClouser: ((String) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    super.setUpTableView()
    configureTableView()
  }
  
  private func configureTableView() {
    
    tableView.backgroundColor = .clear

    tableView.dataSource = self
    tableView.register(FoodMealProductListCell.self, forCellReuseIdentifier: FoodMealProductListCell.cellId)
  }

  
  func setViewModel(viewModel: ProductListInMealViewModel) {
    
    
    if let mealId = viewModel.mealId  {
      self.mealId = mealId
    }
    tableViewData = viewModel.productsData
    
//    let productListResultViewModel = ConfirmProductListResultViewModel.calculateProductListResultViewModel(data: tableViewData)
    
    let productListResultViewModel = ProductListResultWorker.shared.getRusultViewModelByProducts(data: tableViewData)
    
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

extension ProductListInMealViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  // Здесь вот уже мне понадобится Custom ячейка с name и зщкешщт
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FoodMealProductListCell.cellId, for: indexPath) as! FoodMealProductListCell
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row])
    setClousers(cell: cell)
   
    
    return cell
  }
  
  private func setClousers(cell:FoodMealProductListCell) {
    
    cell.didBeginEditingTextField = {[weak self] textField in
      self?.handleTextFieldDidBeginEditing(textField)
    }
    
    // PortionTextField Delegate
    cell.portionTextField.addTarget(self, action: #selector(handlePortionTextFieldDidChange), for: .editingChanged)
    cell.didPortionTextFieldEditing = {[weak self] textField in
      self?.handlePortionTextFieldEndEditing(textField: textField)
    }

    
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let cell = tableView.cellForRow(at: indexPath) as! FoodMealProductListCell
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
    
    guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: textField) else {return}
    let cell = tableView.cellForRow(at: indexPath) as! FoodMealProductListCell

    let portion: Int = (textField.text! as NSString).integerValue

    let sumPortion = CalculateValueTextField.calculateSumPortion(portion: portion, indexPath: indexPath, tableViewData: &tableViewData)
    
    cell.carboInPortionLabel.text = String(tableViewData[indexPath.row].carboInPortion)
    
    let sumCarbo = CalculateValueTextField.calculateSumCarbo(indexPath: indexPath, tableViewData: &tableViewData)
    
    footerView.resultsView.carboResultLabel.text = String(sumCarbo)
    footerView.resultsView.portionResultLabel.text = String(sumPortion)
  }
  


  
  func handlePortionTextFieldEndEditing(textField: UITextField) {

    guard let text = textField.text else {return}
    
    if text.isEmpty {
      textField.text = "0"
      
      showErrorMessage(text: "Продукт не будет учтен при расчете так как вы оставили поле пустым!")
//      ProgressHUD.showError("Продукт не будет учтен при расчете так как вы оставили поле пустым!")

    } else {
       guard let indexPath = PointSearcher.getIndexPathTableViewByViewInCell(tableView: tableView, view: textField) else {return }
      
      let productName = tableViewData[indexPath.row].name
      
      let portionInt = Int(text)!
      
      
//      tableViewData[0].
      // Отправляем результат на MealController и в Реалм
      didChangePortionTextFieldClouser!(portionInt,productName,mealId)
    }
    
  }

  
}


// MARK: Header in Section
extension ProductListInMealViewController {
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    
    let header = ProductListHeaderInSection(withInsulinLabel: false, temaColor: UIColor.black)
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
      
      let productName = self.tableViewData[indexPath.row].name
     
      
      
      self.didDeleteProductFromMealClouser!(productName, self.mealId)

      succsess(true)
    }
    // Удаляет сам по индексу и не андо парится!
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
}


