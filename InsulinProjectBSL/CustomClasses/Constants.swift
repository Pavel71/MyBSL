//
//  Constants.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



struct Constants {
  
  
  static let numberValueTextFieldWidth: CGFloat = 50
  
  
  
  static let cellMargin = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
  static let customNavBarHeight: CGFloat = 60

  static let textFont = UIFont(name: "DINCondensed-Bold", size: 20)
  
  struct HeaderInSection {
    
    static let heightForHeaderInSection: CGFloat = 50
    static let cornerRadius: CGFloat = 10
  }
  
  struct TableView {
    static let tableViewTopPadding: CGFloat  = 3
    static let heightForHeaderInSection: CGFloat = 50
    static let tableViewHeaderHeight: CGFloat = 50
  }
  
  struct Food {

    static let foodMarginsInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    static let tableViewHeaderHeight: CGFloat = 50
    
  }
  
  struct Meal {
    
    static let heightRowMealTableViewCell: CGFloat = 58
    
    struct Cell {
      static let margin = UIEdgeInsets.init(top: 5, left: 8, bottom: 0, right: 8)
      static let typeMealLabelHeight: CGFloat = 12
      static let expandButtonWidth: CGFloat = 100
      
    }
    
    struct ProductCell {
      
      static let margin = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
      static let cellHeight: CGFloat = 32
    }
  }
  
  struct Main {
    
    struct Cell {
      
      static let mainMiddleCellHeight: CGFloat = 400
    }
    
    struct DinnerCollectionView {
      static let contentInsert: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
    }
  }
  
  struct Animate {
    
    static let transformAddNewElementView: CGAffineTransform = CGAffineTransform(translationX: UIScreen.main.bounds.maxX, y: -UIScreen.main.bounds.maxY).concatenating(CGAffineTransform(scaleX: 0.3, y: 0.3))
  }
  
}
