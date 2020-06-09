//
//  NetworkModels.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 07.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation



// Этот класс будет содержать все бе моедльки которые будут транспортироватся из реалма и добавлятся в FIREBASE


protocol NetworkModelable: Codable {}

// MARK: DB Netwrok Model
// Идея в том чтобы сразу получить иерархию моделей в 1ой модели
struct FireStoreNetwrokModels : NetworkModelable {
  
  let days         : [DayNetworkModel]
  let compObjs     : [CompObjNetworkModel]
  let sugars       : [SugarNetworkModel]
  let products     : [ProductNetworkModel]
  let meals        : [MealNetworkModel]
  let userDefaults : [UserDefaultsNetworkModel]
  
  enum CodingKeys: String, CodingKey {
    case days         = "Days"
    case compObjs     = "CompObjs"
    case sugars       = "Sugars"
    case products     = "Products"
    case meals        = "Meals"
    case userDefaults = "UserDefaults"
  }
}


// MARK: UserDefaults Model

struct UserDefaultsNetworkModel:NetworkModelable {
  
  let carboCorrectTargetBaseData   : [Float]
  let carboCorrectTrainBaseData    : [Float]
  let correctCarboByInsulinWeights : [Float]
  let correctSugarByInsulinWeights : [Float]
  
  let lowSugarLevel              : Float
  let higherSugarLevel           : Float
  let insulinSupplyValue         : Int
  let sugarCorrectTargetBaseData : [Float]
  let sugarCorrectTrainBaseData  : [Float]
  
  
  enum CodingKeys: String, CodingKey {
    
    case carboCorrectTargetBaseData
    case carboCorrectTrainBaseData
    case correctCarboByInsulinWeights
    case correctSugarByInsulinWeights
    case lowSugarLevel
    case higherSugarLevel
    case insulinSupplyValue
    case sugarCorrectTargetBaseData
    case sugarCorrectTrainBaseData
  }
}

// MARK: Days Network Model

struct DayNetworkModel : NetworkModelable {
  
  let id            : String
  let date          : TimeInterval
  let listSugarID   : [String]
  let listCompObjID : [String]
  
  let listSugarObj  : [SugarNetworkModel]
  let listCompObj   : [CompObjNetworkModel]
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case date
    case listSugarID
    case listCompObjID
    
    case listSugarObj
    case listCompObj
    
  }
  
}


// MARK: CompObj Network Model

struct CompObjNetworkModel : NetworkModelable {
  
  
  let id                           : String
  let typeObject                   : Int
  let sugarBefore                  : Double
  let sugarAfter                   : Double
  let userSetInsulinToCorrectSugar : Double
  let sugarDiffToOptimaForMl       : Float
  let insulinToCorrectSugarML      : Float
  let timeCreate                   : TimeInterval
  let compansationFase             : Int
  let insulinOnTotalCarbo          : Double
  let totalCarbo                   : Double
  let placeInjections              : String
  
  let listProduct  : [ProductNetworkModel]
  
  
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case typeObject
    case sugarBefore
    case sugarAfter
    case userSetInsulinToCorrectSugar
    case sugarDiffToOptimaForMl
    case insulinToCorrectSugarML
    case timeCreate
    case compansationFase
    case insulinOnTotalCarbo
    case totalCarbo
    case placeInjections
    case listProduct
    
    
  }
  
}


// MARK: Sugar Netwoek Model

struct SugarNetworkModel : NetworkModelable {
  
  
  var id                   : String
  var sugar                : Double
  var time                 : TimeInterval
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



struct ProductNetworkModel : NetworkModelable {
  
  
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

struct MealNetworkModel: NetworkModelable {
  
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
