//
//  DinnerCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class DinnerCollectionViewCell: UICollectionViewCell {
  
  static let cellId = "DinnerCollectionViewCellId"
  
  // Теперь у меня задача сделать функционал мне нужно принимать данные
  
  // 1. Введите ваш текущий сахар - ТекстФилд
  
  // 2. Выберите продукты - Кнопка
  // Тут нужна логика появление Контроллера с списком продуктов или обедов
  // по такому же принципу как и menu View
  
  
  // 3. Введите дозировку инсулина - текстфилд и добавить кнопку расчет дозировки!
  
  // 4. Должен появлятся поле сахар после еды! чтобы понимать Правильно ли у нас прошла компенсация предыдущего обеда или нет- Соответсвенно сделать подсветку Ячейки!
  // При вводе текущего сахара передавать эту информацию в предыдущий обед! и только потом обучатся!
  
  // Получается что здесь должен лежать контроллер со своим функционалом
  

  
  let shugarSetView = ShugarSetView(frame: .init(x: 0, y: 0, width: 0, height: 50))
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    addSubview(shugarSetView)
    shugarSetView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 10, left: 8, bottom: 0, right: 8))
    
  }
  
  
  
  
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    clipsToBounds = true
    layer.cornerRadius = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
}
