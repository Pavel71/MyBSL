//
//  InsulinInjectionsCollectionViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealCollectionVC: UIViewController {
  
  
  let collectionView: UICollectionView = {
      
      let layout = BetterSnapingLayout()
      layout.scrollDirection = .horizontal
      
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      
      collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.decelerationRate = .fast
      collectionView.backgroundColor = .white
//      collectionView.allowsSelection = false // Убераем выбор ячейка
      
      return collectionView
      
    }()
  
  
  var dinners : [MainScreenMealViewModel] = [] {
    
    didSet {collectionView.reloadData()}
  }
  
  // CLousers
  
  var passMealIdItemThanContinueScroll: StringPassClouser?
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpCollectionView()
  }
  
}

// MARK: Set View Models

extension MealCollectionVC {
  
  func setViewModel(viewModel: MealCollectionVCViewModel) {
    
    dinners = viewModel.cells
    
  }
  
  
}

// MARK: Set Up Views

extension MealCollectionVC {
  
  private func setUpCollectionView() {
     view.addSubview(collectionView)
     collectionView.fillSuperview()
     registerCell()
     
   }
   
   private func registerCell() {
     
     collectionView.delegate = self
     collectionView.dataSource = self
     
     collectionView.register(MealCollectionCell.self, forCellWithReuseIdentifier: MealCollectionCell.cellId)
   }
}

// MARK: CollectionView Delegate

extension MealCollectionVC:  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dinners.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionCell.cellId, for: indexPath) as! MealCollectionCell
    
    cell.setViewModel(viewModel: dinners[indexPath.item])
    
    return cell
  }
  
  // Select
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Select Item",indexPath.row)
  }
  
  
  // Size
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let collectionViewHeight = collectionView.frame.height
    
    return .init(width: UIScreen.main.bounds.width - 20, height: collectionViewHeight - 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 0, right: 10)
  }
  
  
}


// MARK: Scroll Delegate
extension MealCollectionVC: UIScrollViewDelegate {
  
  // Задача определять какая ячейка сейчас на экране у пользователя
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    print("End Decelarating")
    let indexPathfirst = collectionView.indexPathsForVisibleItems.first
    guard let indextPath = indexPathfirst else {return}
    let mealId = dinners[indextPath.row].mealId
    
    passMealIdItemThanContinueScroll!(mealId)
    
    
  }

}
