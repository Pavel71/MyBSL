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


// MARK: Product Netwoek Model



struct ProductNetworkModel : Codable {
  
  
   var id                    : String
   var name                  : String
   var category              : String
   var carboIn100grm         : Int
   var portion               : Int
  
   var percantageCarboInMeal : Double

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
