//
//  DinnerCollectionViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class DinnerCollectionViewController: UIViewController {
  
  let collectionView: UICollectionView = {
    
    let layout = BetterSnapingLayout()
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.semanticContentAttribute = .forceRightToLeft
    collectionView.contentInset = Constants.Main.DinnerCollectionView.contentInsert
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.decelerationRate = .fast
    collectionView.backgroundColor = .white
    collectionView.allowsSelection = false // Убераем выбор ячейка
    
    return collectionView
    
  }()
  
  // Здесь не простая ProductView Model а с инмулином!
  
  var dinnerViewModel: [DinnerViewModel] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  

  // Clousers Pass to MainController
  
  var didSelectTextField: TextFieldPassClouser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    
  }
  
  private func setUpCollectionView() {
    view.addSubview(collectionView)
    collectionView.fillSuperview()
    registerCell()
  }
  
  private func registerCell() {
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(DinnerCollectionViewCell.self, forCellWithReuseIdentifier: DinnerCollectionViewCell.cellId)
  }
  
  func setViewModel(viewModel: [DinnerViewModel]) {

    dinnerViewModel = viewModel
  }
  

  
}





// MARK: Collection View Delegate DataSource

extension DinnerCollectionViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dinnerViewModel.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: DinnerCollectionViewCell.cellId, for: indexPath) as! DinnerCollectionViewCell

    item.setViewModel(viewModel: dinnerViewModel[indexPath.row])
    setCellClousers(cell: item)
    return item
    
  }
  
  // в этом методе я расставлю  clouser чтобы только этот контроллер отвечал за все действия происходящие на его территории!
  private func setCellClousers(cell: DinnerCollectionViewCell) {
    
    // TextFiedl
    cell.shugarSetView.shugarBeforeValueTextField.delegate = self
    cell.shugarSetView.shugarAfterValueTextField.delegate = self
    
    cell.productListViewController.didSelectTextFieldCellClouser = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField)
    }
    
    cell.touchesPassView.didHitTestProductListViewControllerClouser = {[weak self] isItScrollProductList in
      self?.scrollingProductListView(isItScrollProductList: isItScrollProductList)
    }
    
    cell.didTapAddNewProductInDinnerClouser = {[weak self] in
      self?.addNewProductInDinner()
    }
    
    
  }
  
  private func addNewProductInDinner() {
    
    print("add New product in Dinner")
  }
  
  private func scrollingProductListView(isItScrollProductList: Bool) {
    collectionView.isScrollEnabled = isItScrollProductList
  }
  
  private func getMaxCountProductInProductList() -> Int {
    var maxCount: Int = 0
    dinnerViewModel.forEach { (dinner) in
      
      maxCount = max(dinner.productListInDinnerViewModel.productsData.count,maxCount)
    }
    return maxCount
  }
  
  // MARK: Height Items
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let heightCell = Calculator.calculateMaxHeightDinnerCollectionView(dinnerData: dinnerViewModel)
    
    return .init(width: UIScreen.main.bounds.width - 40, height: heightCell + 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Constants.Main.DinnerCollectionView.contentInsert
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  

}

extension DinnerCollectionViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didSelectTextField!(textField)
    
  }
  
  
}
