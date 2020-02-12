//
//  LearnByFoodVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Итак на этом экранне я должен отобразить 5 продуктов питания

// Как бы это сделать поудачнее! возможно добавить коллекцию и человек будет листать только картинки а название и текстфилд я буду держать в 1ом месте! где он будет вводить данные

// Когда картинка приходит мы выводим название массу и сколько углеводов
// дальше предлагаем человеку заполнить поле дозировка инсулина на этот продукт

// Нам уже нужна модель данных с именим каритнкой углеводами 

class LearnByFoodVC: UITableViewController {
  
  
  
  var tableViewData: [LearnByFoodModel] =  LearnByFoodModel.getData()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    configureTableView()
    
    
  }
  
  private func configureTableView() {
    
    // Тут нужен высота статус бара и навигатони бара
    let topPadding    =  UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
//    let bottomPadding = self.tabBarController!.tabBar.frame.size.height
//    tableView.contentInset = .init(top: topPadding, left: 0, bottom: 0, right: 0)
    // Без скроллинга
    tableView.allowsSelection      = false
    tableView.alwaysBounceVertical = true
    tableView.keyboardDismissMode  = .interactive
    registerCell()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print(tableViewData)
    
    print("On Board View WIll AppeR")
    tableView.reloadData()
  }
  
  private func registerCell() {
    
    tableView.register(LearnByFoodCell.self, forCellReuseIdentifier: LearnByFoodCell.cellID)
  }
  
}


// MARK: TableView Deleagate DataSource

extension LearnByFoodVC {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: LearnByFoodCell.cellID, for: indexPath) as! LearnByFoodCell
    
    cell.setViewModel(viewModel: tableViewData[indexPath.row])
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    let topPadding    =  UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!

    return (tableView.frame.height - topPadding) / CGFloat(tableViewData.count)
  }
}
