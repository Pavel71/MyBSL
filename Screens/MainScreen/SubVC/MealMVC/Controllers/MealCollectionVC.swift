//
//  InsulinInjectionsCollectionViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 15.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class MealCollectionVC: UIViewController {
  
  // MARK: Collection View
  
  let collectionView: UICollectionView = {
      
      let layout = BetterSnapingLayout()
      layout.scrollDirection = .horizontal
      
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.contentMode  = .top
      collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.decelerationRate = .fast
      collectionView.backgroundColor  = .white
      collectionView.allowsSelection = false // Убераем выбор ячейка
      
      return collectionView
      
    }()
  
  
  var dinners : [CompansationObjactable] = [] {
    
    didSet {collectionView.reloadData()}
  }
  
  // MARK: CLousers
  
  var passMealIdItemThanContinueScroll : StringPassClouser?
  var didDeleteCompasationObject       : StringPassClouser?
  var didUpdateCompansationObject      : StringPassClouser?
  
  var didShowSugarBeforeCLouser        : StringPassClouser?
  var didShowSugarAfterCLouser         : StringPassClouser?
  var didShowTotalCarboClouser         : StringPassClouser?
  var didSHowTotalInsulinClouser       : StringPassClouser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Init Collection View")
    setUpCollectionView()
  }
  
}

// MARK: Set View Models

extension MealCollectionVC {
  
  func setViewModel(viewModel: CollectionVCVM) {
    
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
    
    
     
     collectionView.register(CompansationByMealCell.self, forCellWithReuseIdentifier: CompansationByMealCell.cellId)
    collectionView.register(CompansationByInsulinCell.self, forCellWithReuseIdentifier: CompansationByInsulinCell.cellId)
    collectionView.register(CompansationByCarboCell.self, forCellWithReuseIdentifier: CompansationByCarboCell.cellId)
   }
}

// MARK: CollectionView Delegate

extension MealCollectionVC:  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dinners.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // Теперь мне нужно определится! Делать еще 2 ячейки для каждого типа объектов! Тогда будет все понятнее!
    
    switch dinners[indexPath.item].type {
      case .mealObject:
        return getMealCell(indexPath: indexPath)
      case .correctSugarByCarbo:
        return getCompansationByCarboCell(indexPath: indexPath)
      case .correctSugarByInsulin:
        return getCompansationByInsulinCell(indexPath: indexPath)
    }

  }
  

  
  
  // Select
  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    print("Select Item",indexPath.row)
//  }
  
  
  
  
  
}

// MARK: Size Cell

extension MealCollectionVC: UICollectionViewDelegate {
  
  // Size
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let collectionViewHeight = collectionView.frame.height
    let width                = UIScreen.main.bounds.width - 20
    
    
    return .init(width: width, height: collectionViewHeight - 20)
    
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 0, right: 10)
  }
}


// MARK: COnfigure  Cell
extension MealCollectionVC {
  
  // Compansation By Carbo Cell
  
  private func getCompansationByCarboCell(indexPath: IndexPath) -> CompansationByCarboCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompansationByCarboCell.cellId, for: indexPath) as! CompansationByCarboCell
       
       let carboCellVm = dinners[indexPath.item] as! ComapsnationByCarboVM
       cell.setViewModel(viewModel: carboCellVm)
       setCellClousers(cell: cell)
       return cell
    
  }
  
  // Meal Cell
  private func getMealCell(indexPath: IndexPath) -> CompansationByMealCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompansationByMealCell.cellId, for: indexPath) as! CompansationByMealCell
    
    let mealCellVM = dinners[indexPath.item] as! CompansationMealVM
    cell.setViewModel(viewModel: mealCellVM)
    setCellClousers(cell: cell)
    return cell
    
  }
  
  // Compansation By Insulin Cell
  private func getCompansationByInsulinCell(indexPath: IndexPath) ->
    CompansationByInsulinCell {
      
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompansationByInsulinCell.cellId, for: indexPath) as! CompansationByInsulinCell
    
    let compansationByInsulinVM = dinners[indexPath.item] as! CompansationByInsulinVM
    cell.setViewModel(viewModel: compansationByInsulinVM)
    setCellClousers(cell: cell)
    return cell
  }
  
  // MARK: Set Cell Clousers
  
  private func setCellClousers(cell: CompansationCVBaseCell) {
    
    // Delete Compansation Object
    cell.topButtonView.didTapDeleteButton = {[weak self] in
      self?.didDeleteCompasationObject!(cell.objectId)
    }
    
    cell.topButtonView.didTapUpdateButton = {[weak self] in
      self?.didUpdateCompansationObject!(cell.objectId)
    }
    
    cell.topButtonView.didTapShowSugarBefore = {[weak self] sugarBefore in
      self?.didShowSugarBeforeCLouser!(sugarBefore)
    }
    
    cell.topButtonView.didTapShowSugarAfter = {[weak self] sugarAfter in
      self?.didShowSugarAfterCLouser!(sugarAfter)
    }
    
    cell.topButtonView.didTapShowTotalCarbo = {[weak self] totalCarbo in
      self?.didShowTotalCarboClouser!(totalCarbo)
    }
    cell.topButtonView.didTapShowTotalInsulin = {[weak self] totalInsulin in
      self?.didSHowTotalInsulinClouser!(totalInsulin)
    }
    
    
  }
  
}


// MARK: Scroll Delegate
extension MealCollectionVC: UIScrollViewDelegate {
  
  // Задача определять какая ячейка сейчас на экране у пользователя
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    let indexPathfirst = collectionView.indexPathsForVisibleItems.first
    guard let indextPath = indexPathfirst else {return}
    let mealId = dinners[indextPath.row].id
    
    passMealIdItemThanContinueScroll!(mealId)
    
    
  }

}
