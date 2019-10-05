//
//  BetterSnappingFlowLayout.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class BetterSnapingLayout: UICollectionViewFlowLayout {
  
  let cellHeight = Constants.Main.Cell.middleCellHeight
  
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    
    guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
    
    var offsetAdjustment = CGFloat.greatestFiniteMagnitude
    
    let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
    
    let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    
    let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
    
    layoutAttributesArray?.forEach({ (layoutAttributes) in
      let itemOffset = layoutAttributes.frame.origin.x
      if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
        offsetAdjustment = itemOffset - horizontalOffset
      }
    })
    
    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }
  
  
  
  // Пробую листать Справа на лево
  
//  override func prepare() {
//    super.prepare()
//  }
//  
//  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    var layoutAttrs = [UICollectionViewLayoutAttributes]()
//    
//    if let collectionView = self.collectionView {
//      for section in 0 ..< collectionView.numberOfSections {
//        if let numberOfSectionItems = numberOfItemsInSection(section) {
//          for item in 0 ..< numberOfSectionItems {
//            let indexPath = IndexPath(item: item, section: section)
//            let layoutAttr = layoutAttributesForItem(at: indexPath)
//            
//            if let layoutAttr = layoutAttr, layoutAttr.frame.intersects(rect) {
//              layoutAttrs.append(layoutAttr)
//            }
//          }
//        }
//      }
//    }
//    
//    return layoutAttrs
//  }
//  
//  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//    let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//    let contentSize = self.collectionViewContentSize
//    
//    layoutAttr.frame = CGRect(
//      x: 0, y: contentSize.height - CGFloat(indexPath.item + 1) * cellHeight,
//      width: contentSize.width, height: cellHeight)
//    
//    return layoutAttr
//  }
//  
//  func numberOfItemsInSection(_ section: Int) -> Int? {
//    if let collectionView = self.collectionView,
//      let numSectionItems = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section)
//    {
//      return numSectionItems
//    }
//    
//    return 0
//  }
//  
//  override var collectionViewContentSize: CGSize {
//    get {
//      var height: CGFloat = 0.0
//      var bounds = CGRect.zero
//      
//      if let collectionView = self.collectionView {
//        for section in 0 ..< collectionView.numberOfSections {
//          if let numItems = numberOfItemsInSection(section) {
//            height += CGFloat(numItems) * cellHeight
//          }
//        }
//        
//        bounds = collectionView.bounds
//      }
//      
//      return CGSize(width: bounds.width, height: max(height, bounds.height))
//    }
//  }
//  
//  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//    if let oldBounds = self.collectionView?.bounds,
//      oldBounds.width != newBounds.width || oldBounds.height != newBounds.height
//    {
//      return true
//    }
//    
//    return false
//  }
}
