//
//  BaseProductList.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



// Посути класс объеденяте всебе ТОлько ТО как будут отображатся элементы на экране и какие общие свойства содержит класс

// Здесь я лучше буду отображать общие данные расположение UI Element

class BaseProductList: UIViewController,BaseProductListViewControllerable {
  

  
  var footerView = ProductsTableViewInMealCellFooterView(frame: .init(x: 0, y: 0, width: 0, height: Constants.ProductList.TableFooterView.footerHeight))

  var tableView = UITableView(frame: .zero, style: .plain)
  
  var headerView = ProductListTableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: ProductListTableHeaderView.height))

  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    
    setUpTableView()
  }
  
  // Set UP View
  
  
  func setUpTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    
    tableView.delegate = self
    tableView.isScrollEnabled = false
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


