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
    
    // Без скроллинга
    tableView.isScrollEnabled = false
    
    
    view.backgroundColor = .green
  }
  
}
