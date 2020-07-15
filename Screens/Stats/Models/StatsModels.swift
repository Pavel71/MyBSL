//
//  StatsModels.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

enum Stats {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getStatsModel
      }
    }
    struct Response {
      enum ResponseType {
        case passStatsModelToVC(crudeStatsData: CrudeStatsData)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case passStatsModelToVC(statsModel: StatsModel)
      }
    }
  }
  
}


// MARK: Crude Models From Realm


struct CrudeStatsData {
  
  var allCompObj       : [CompansationObjectRelam]
  var sugarFor10Days   : [SugarRealm]
  
  var goodCompObjCount : Double
  var badCompObjCount  : Double
  
}

// MARK: Models TO View


struct StatsModel {
  
  var meanInsulinOnCarbo : Double
  var meanSugarFor10Days : Double
  var pieChartModel      : PieChartModel
  var robotViewModel     : RobotModel
  
}

struct RobotModel : RobotViewModalable {
  var allCompObjCount: Int
}

struct PieChartModel : PieChartModalable {
  
  var goodCompObjCount: Double
  
  var badCompObjCount: Double
  
}
