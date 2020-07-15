//
//  StatsPresenter.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit

protocol StatsPresentationLogic {
  func presentData(response: Stats.Model.Response.ResponseType)
}

class StatsPresenter: StatsPresentationLogic {
  weak var viewController: StatsDisplayLogic?
  
  func presentData(response: Stats.Model.Response.ResponseType) {
    
    switch response {
    case .passStatsModelToVC(let crudeStatsData):
      let statsModel = prepareStatsModel(crudeStatsData: crudeStatsData)
      viewController?.displayData(viewModel: .passStatsModelToVC(statsModel: statsModel))
    default:break
    }
  }
  
}

// MARK: Prepare Stats VM
extension StatsPresenter {
  
  private func prepareStatsModel(crudeStatsData: CrudeStatsData) -> StatsModel {
    
    
    // Mean Insulin On the carbo
    
    let withoutLast = crudeStatsData.allCompObj.dropLast()
    
    let sumCarbo   = withoutLast.flatMap{$0.listProduct.map{$0.carboInPortion}}.sum()
    let sumInsulin = withoutLast.flatMap{$0.listProduct.map{$0.insulinOnCarboToML}}.sum()
   
    
    let meanInsulinOnCarbo = ((sumInsulin / sumCarbo) * 10 ).toDouble().roundToDecimal(2)
    
    // Mean Sugar For 10 days
    let sugarsFor10Days = crudeStatsData.sugarFor10Days.compactMap{$0.sugar}
    let meanSugarFor10Days = (sugarsFor10Days.sum() / Double(sugarsFor10Days.count)).roundToDecimal(2)
    
    // PieChart Model
    let pieChartModel =  PieChartModel(
      goodCompObjCount : crudeStatsData.goodCompObjCount,
      badCompObjCount  : crudeStatsData.badCompObjCount)
    
    // Robot Model
    
    let robotModel = RobotModel(allCompObjCount: crudeStatsData.allCompObj.count)
    
    return StatsModel(
      meanInsulinOnCarbo : meanInsulinOnCarbo,
      meanSugarFor10Days : meanSugarFor10Days,
      pieChartModel      : pieChartModel,
      robotViewModel     : robotModel)

  }
}
