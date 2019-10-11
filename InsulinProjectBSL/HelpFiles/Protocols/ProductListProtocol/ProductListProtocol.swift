//
//  ProductListProtocol.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

protocol BaseProductListViewControllerable: UIViewController {
  
  var footerView: ProductsTableViewInMealCellFooterView {get set}
  var tableView: UITableView{get set}
  var headerView: ProductListTableHeaderView {get set}
  
//  var didSelectTextFieldCellClouser: TextFieldPassClouser? {get set}
  
  func setUpTableView()
  
}
