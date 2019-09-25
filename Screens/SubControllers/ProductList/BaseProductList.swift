//
//  BaseProductList.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

class BaseProductList: UIViewController,BaseProductListViewControllerable {
  
  var footerView = ProductsTableViewInMealCellFooterView(frame: .init(x: 0, y: 0, width: 0, height: ProductsTableViewInMealCellFooterView.footerHeight))
  
  var tableView = UITableView(frame: .zero, style: .plain)
  var headerView = ProductListTableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: ProductListTableHeaderView.height))
  
  
  var didSelectTextFieldCellClouser: TextFieldPassClouser?
  
  
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    
    setUpTableView()
  }
  
  
  func setUpTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    
    tableView.tableFooterView = footerView // footerView

  }
  
  
  
 
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension BaseProductList: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.ProductList.cellHeight
  }
  
}







extension BaseProductList: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didSelectTextFieldCellClouser!(textField)
  }
  

}
