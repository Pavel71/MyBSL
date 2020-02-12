//
//  LearnByFoodModel.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



struct LearnByFoodModel:LearnVyFoodCellable {
  
  var carbo   : Double
  var name    : String
  var portion : Double
  var image   : UIImage
  var insulin : Double?
  
  
  
  
  // Нужно вернуть данные
  static func getData() -> [LearnByFoodModel] {
    
    let apple = LearnByFoodModel(
      carbo: 16,
      name: "Яблоко",
      portion: 150,
      image: #imageLiteral(resourceName: "apple"),
      insulin: nil)
    
    let pasta = LearnByFoodModel(
      carbo: 25,
      name: "Макаронны",
      portion: 50,
      image: #imageLiteral(resourceName: "spaghetti"),
      insulin: nil)
    
    let chocolate = LearnByFoodModel(
      carbo: 10,
      name: "Шоколад",
      portion: 20,
      image: #imageLiteral(resourceName: "chocolate"),
      insulin: nil)
    
    let rice = LearnByFoodModel(
      carbo: 30,
      name: "Рис",
      portion: 40,
      image: #imageLiteral(resourceName: "rice"),
      insulin: nil)
    
    let beard = LearnByFoodModel(
      carbo: 20,
      name: "Хлеб белый",
      portion: 40,
      image: #imageLiteral(resourceName: "bread"),
      insulin: nil)
    
    return [apple,pasta,chocolate,rice,beard]
    
  }
  
}
