//
//  DinnerCollectionViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class DinnerCollectionViewController: HorizontalSnappingController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
    registerCell()
  }
  
  private func registerCell() {
    
    collectionView.register(DinnerCollectionViewCell.self, forCellWithReuseIdentifier: DinnerCollectionViewCell.cellId)
  }
  
  private func configureCollectionView() {
    collectionView.semanticContentAttribute = .forceRightToLeft
    collectionView.contentInset = Constants.Main.DinnerCollectionView.contentInsert
    collectionView.showsHorizontalScrollIndicator = false
    
  }
  
}

// MARK: Collection View Delegate DataSource

extension DinnerCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: DinnerCollectionViewCell.cellId, for: indexPath) as! DinnerCollectionViewCell
    
    return item
  }
  
  // в этом методе я расставлю  clouser чтобы только этот контроллер отвечал за все действия происходящие на его территории!
  private func setCellClousers(cell: DinnerCollectionViewCell) {
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: UIScreen.main.bounds.width - 40, height: Constants.Main.Cell.mainMiddleCellHeight - 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Constants.Main.DinnerCollectionView.contentInsert
  }
  

}
