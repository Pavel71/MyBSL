//
//  Constants.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



struct Constants {
  
  static let screenHeight = UIScreen.main.bounds.height
  static let screenWidth = UIScreen.main.bounds.height
  
  static let cornerRadiusForButtonAndTextField: CGFloat = 10
  
  struct Color {
    
    static let darKBlueBackgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    static let lightBlueBackgroundColor = #colorLiteral(red: 0.1911981702, green: 0.5567708611, blue: 0.771561563, alpha: 1)
    static let lightGrayBackgroundColor = UIColor(white: 0.6, alpha: 1)
  }
  
  
  static let numberValueTextFieldWidth: CGFloat = 50
  
  struct Text {
    
    static let textColorDarkGray = UIColor.darkGray
  }
  
  struct Font {
    static let textFont  = UIFont(name: "DINCondensed-Bold", size: 20)
    static let valueFont = UIFont(name: "DINCondensed-Bold", size: 16)
  }
  
  static let cellMargin = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
  static let customNavBarHeight: CGFloat = 60

  
  
  struct KeyBoard {
    static let doneToolBarHeight:CGFloat =  50
  }
  
  struct HeaderInSection {
    
    static let heightForHeaderInSection: CGFloat = 50
    static let cornerRadius: CGFloat = 10
  }
  
  struct TableView {
    static let tableViewTopPadding: CGFloat  = 6
    static let heightForHeaderInSection: CGFloat = 50
    static let tableViewHeaderHeight: CGFloat = 50
  }
  
  struct Food {

    static let foodMarginsInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    static let tableViewHeaderHeight: CGFloat = 50
    
    struct TableViewHeaderInSection {
      static let rightStackViewWidth: CGFloat = 180
      static let nameLabelWidth: CGFloat = 120
    }
    
  }
  
  struct Meal {
    
    static let heightRowMealTableViewCell: CGFloat = 58
    
    struct Cell {
      static let margin = UIEdgeInsets.init(top: 5, left: 8, bottom: 0, right: 8)
      static let typeMealLabelHeight: CGFloat = 12
      static let expandButtonWidth: CGFloat = 100
      
    }
    
    
  }
  
  
  struct ProductList {
    
//    static let valueAndTextColor: UIColor = .black
    
    
    
    static let labelValueWidth: CGFloat = 50
    static let marginCell = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
    static let cellHeight: CGFloat = 32
    
    static let headerInSectionHeight: CGFloat = 30
    
    struct TableFooterView {
      static let addButtonHeight: CGFloat = 45
      static let resultsViewHeight: CGFloat = 40
      
      static var footerHeight: CGFloat {
        return resultsViewHeight  // addButtonHeight +
      }
    }
    
  }
  
  struct Main {
    
    struct Cell {
      
      static let headerCellHeight:CGFloat = 150
      static let middleCellHeight: CGFloat = 400
      static let footerCellheight: CGFloat = 200
    }
    
    struct DinnerCollectionView {
      
      static let contentInsert: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
      static let shugarViewInCellHeight: CGFloat = 40
      
      static let choosePlaceInjectionsRowHeight: CGFloat = 40
      static let willActiveRowHeight: CGFloat = 40
      
      static let topMarginBetweenView: CGFloat = 10
      
    }
    
    
  }
  
  struct MenuController {
    
    struct TableView {
      static let headerInSectionHeight: CGFloat = 50
    }
  }
  
  struct MenudDinner {
    
    static let swipeViewHeight: CGFloat = 30
    
  }
  
  struct Animate {
    
    static let transformUpRightCorner: CGAffineTransform = CGAffineTransform(translationX: UIScreen.main.bounds.maxX, y: -UIScreen.main.bounds.maxY).concatenating(CGAffineTransform(scaleX: 0.3, y: 0.3))
    
    static let transformUpLeftCorner: CGAffineTransform = CGAffineTransform(translationX: UIScreen.main.bounds.minX, y: -UIScreen.main.bounds.maxY).concatenating(CGAffineTransform(scaleX: 0.3, y: 0.3))
    
     static let transformUnderBottomInCenter: CGAffineTransform = CGAffineTransform(translationX: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY + 200).concatenating(CGAffineTransform(scaleX: 0.3, y: 0.3))
  }
  
 
  
}
