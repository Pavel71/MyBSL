//
//  NetworkModels.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation



// Этот класс будет содержать все бе моедльки которые будут транспортироватся из реалма и добавлятся в FIREBASE

public struct City: Codable {

    let name: String
    let state: String?
    let country: String?
    let isCapital: Bool?
    let population: Int64?

    enum CodingKeys: String, CodingKey {
        case name
        case state
        case country
        case isCapital = "capital"
        case population
    }

}


// MARK: Sugar Netwoek Model

struct SugarNetworkModel : Codable {
  
  
  var id                   : String
  var sugar                : Double
  var time                 : Date
  var dataCase             : Int
  var compansationObjectId : String
  
  enum CodingKeys: String, CodingKey {
    
      case id
      case sugar
      case time
      case dataCase
      case compansationObjectId

  }
  
}


// MARK: Product Netwoek Model



struct ProductNetworkModel : Codable {
  
  
   var id                    : String
   var name                  : String
   var category              : String
   var carboIn100grm         : Int
   var portion               : Int
  
   var percantageCarboInMeal : Float

   var userSetInsulinOnCarbo : Float
   var insulinOnCarboToML    : Float
  
   var isFavorits            : Bool
  
  enum CodingKeys: String, CodingKey {
    
      case id
      case name
      case category
      case carboIn100grm
      case portion
      case percantageCarboInMeal
      case userSetInsulinOnCarbo
      case insulinOnCarboToML
      case isFavorits
  }
  
}

// MARK: Meal


// Самое интересное как

struct MealNetworkModel: Codable {
  
  var id           : String
  var isExpandMeal : Bool
  var name         : String
  var typeMeal     : String

  
  let listProduct  : [ProductNetworkModel]
  
  enum CodingKeys: String, CodingKey {
    
      case id
      case isExpandMeal
      case name
      case typeMeal
      
      case listProduct

  }
  
}
