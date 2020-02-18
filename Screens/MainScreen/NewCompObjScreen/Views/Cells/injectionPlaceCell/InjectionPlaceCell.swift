//
//  InjectionPlaceCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 18.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Ячейка отвечает за отображение места укола
// Пока сделаю просто кнопку по нажатию на которую у нас появится дополнительная View с выбором места укола
// Потом возможно обновлю дизайн!


class InjectionPlaceCell: UITableViewCell {
  
  static let cellId = "InjectionPlaceCell"
  
  
  
  var chooseButton: UIButton = {
    let b = UIButton(type: .system)
    
    return b
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .purple
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
