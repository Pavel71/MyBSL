//
//  CustomCalculate.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 18/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class Calculator {
  
  
  static func calculateCarboInPortion(carboIn100grm: Int, portionSize: Int) -> Int {
    let carbo100grm = Float(carboIn100grm)
    let portion = Float(portionSize)
    return Int(carbo100grm * (portion / 100))
  }
  
  
  
  
  
  
  // MARK: Calculate Meal Cell Height
  
  static func calculateMealCellHeight(isExpanded: Bool,countRow: Int, mealName: String) -> CGFloat {
    
    let labelStackViewHeight = calculateMealNameLabelHeight(mealName: mealName)
    let tableViewHeight = calculateProductListViewheight(countRow: countRow)
    
    return isExpanded ? tableViewHeight + labelStackViewHeight : labelStackViewHeight
    

  }
  
  static func calculateMaxHeightDinnerCollectionView(dinnerData: [DinnerViewModel]) -> CGFloat {
    
    
    var maxCount: Int = 0
    dinnerData.forEach { (dinner) in
      maxCount = max(dinner.productListViewModel.count,maxCount)
    }
    
    let maxHeightCollectionView = Calculator.calculateProductListViewheight(countRow:maxCount)
    
    let margins = Constants.DinnerCollectionView.ShugarViewTopMargin + Constants.DinnerCollectionView.ProductListViewBottomMargin
    
    let heightCell = maxHeightCollectionView + Constants.Main.DinnerCollectionView.shugarViewInCellHeight + margins
    
    return heightCell
  }
  
  static func calculateProductListViewheight(countRow: Int, isPreviosDinner: Bool = false) -> CGFloat {
    
    let cellPading = Constants.ProductList.marginCell.bottom * 2
    
    let footerHeight = isPreviosDinner ? 0 : ProductsTableViewInMealCellFooterView.footerHeight
    
    let headerInSection = ProductListHeaderInSection.height
    let headerTableViewHeight = ProductListTableHeaderView.height
    
    var tableVIewHeight: CGFloat
    
    if countRow == 0 {
      tableVIewHeight = footerHeight + headerInSection + cellPading + headerTableViewHeight
      
    } else {
      
      tableVIewHeight = (Constants.ProductList.cellHeight * CGFloat(countRow))  + footerHeight + cellPading + headerInSection
    }
    
    return tableVIewHeight
  }
  
  private static func calculateMealNameLabelHeight(mealName: String) -> CGFloat {
    
    let paddings = (Constants.Meal.Cell.margin.left * 2)
    let rightStackViewWidth: CGFloat = Constants.Meal.Cell.expandButtonWidth
    let widhtLabel = UIScreen.main.bounds.width - rightStackViewWidth - paddings 
    let dummyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widhtLabel, height: .greatestFiniteMagnitude))
    
    dummyLabel.font = UIFont.systemFont(ofSize: 17)
    dummyLabel.numberOfLines = 0
    dummyLabel.text = mealName
    dummyLabel.sizeToFit()
  
    let mealNameLabelHeight = dummyLabel.frame.height
    let typeMealLabelheight: CGFloat = Constants.Meal.Cell.typeMealLabelHeight
    
    return mealNameLabelHeight + typeMealLabelheight + Constants.Meal.Cell.margin.top
    
    
  }
}
