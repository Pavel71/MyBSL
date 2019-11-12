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
    
//    collectionView.semanticContentAttribute = .forceRightToLeft
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
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
  
  // TextField
  var didSelectTextField: TextFieldPassClouser?
  
  var didShugarBeforeTextFieldChangeToMain: FloatPassClouser?
  
//  var didSetShugarBeforeInTimeClouserToMain: DatePassClouser?
  var didSetShugarBeforeValueAndTimeClouserToMain:((Date,Float) -> Void)?
  
  var didSetCorrectionShugarByInsulinClouserToMain: FloatPassClouser?
  
  
  
  var didPortionTextFieldEndEditingToMain: ((Int,Int) -> Void)?
  var didInsulinTextFieldEndEditingToMain : ((Float,Int) -> Void)?
  
  // WillActiveTextField
  var didEndEditingWillActiveTextField: TextFieldPassClouser?
  
  // Delete product
  var didDeleteProductFromDinner: (([ProductRealm]) -> Void)?
  
  // Button
  var didAddNewProductInDinner: EmptyClouser?
  var didShowChoosepalceIncjectionView: EmptyClouser?
  var didTapListButtonInActiveTextField: TextFieldPassClouser?
  var didScrollDinnerCollectionView: EmptyClouser?
  var didSwitchActiveViewToMainView: EmptyClouser?
  
  
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
  
  func scrollCollectionToNewDinner() {
    collectionView.scrollToItem(at: IndexPath(item: dinnerViewModel.count - 1, section: 0), at: .right, animated: true)
  }
  
  func scrollCollectionToPreviosDinner() {
    collectionView.scrollToItem(at: IndexPath(item: dinnerViewModel.count - 3, section: 0), at: .left, animated: true)
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
    setCellClousers(cell: item,indexPath: indexPath)
    return item
    
  }
  
  // в этом методе я расставлю  clouser чтобы только этот контроллер отвечал за все действия происходящие на его территории!
  private func setCellClousers(cell: DinnerCollectionViewCell,indexPath: IndexPath) {
    
    // Это Конечно не особо правельно! Нужно будет исправить это!
    cell.shugarSetView.shugarAfterValueTextField.delegate = self
    
    // ShugarSetView
    
    setShugarSetViewClousers(cell: cell)
    
    
    // ProductListInDinner
    
    setProductListInDinnerClousers(cell: cell)

    // Touches Pass View
    
    cell.touchesPassView.didHitTestProductListViewControllerClouser = {[weak self] isItScrollProductList in
      self?.scrollingProductListView(isItScrollProductList: isItScrollProductList)
    }
    
    // Add New Product
    cell.didTapAddNewProductInDinnerClouser = {[weak self] in
      self?.addNewProductInDinner()
    }
  
    
    // ChoosePlaceInjections
    cell.chooseRowView.didTapChoosePlaceInjections = {[weak self] in
      self?.choosePlaceInjections()
    }
    
    // ActivityTecxtField
    
    
    cell.willActiveRow.trainTextField.listButton.addTarget(self, action: #selector(handleTapListButtonInWillActiveTextField), for: .touchUpInside)
    
    cell.willActiveRow.didSwitchActiveView = {[weak self] in
      self?.didSwitchActiveView()
    }
    cell.willActiveRow.didBeginEditingTrainTextField = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField)
    }
    // Здесь еще нужен о конце редактирвоания
    cell.willActiveRow.didEndEditingTrainTextField = {[weak self] textField in
      self?.didEndEditingWillActiveTextField!(textField)
    }

    
    
  }
  
  private func setShugarSetViewClousers(cell:DinnerCollectionViewCell) {
    
    // Begin Editing
    cell.shugarSetView.didBeginEditingShugarBeforeTextField = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField)
    }
    cell.shugarSetView.didSetCorrectionShugarByInsulinClouser = {[weak self] correctInsulin in
      self?.didSetCorrectionShugarByInsulinClouserToMain!(correctInsulin)
    }
    // Changet
    cell.didShugarBeforeTextFieldChangeToDinnerViewController = {[weak self] shugatBefore in
      self?.didShugarBeforeTextFieldChangeToMain!(shugatBefore)
      
    }
    
    cell.shugarSetView.didSetShugarBeforeValueAndTimeClouser = {[weak self] time,shugar in
      self?.didSetShugarBeforeValueAndTimeClouserToMain!(time,shugar)
    }


  }
  
  private func setProductListInDinnerClousers(cell:DinnerCollectionViewCell) {
    
    // InsulinField End Editing
    
    cell.productListViewController.didInsulinTextFieldEndEditingToDinnerController = {[weak self] insulin,row in
      self?.didInsulinTextFieldEndEditingToMain!(insulin,row)
    }
    
    // Portion End Editing
    
    cell.productListViewController.didPortionTextFieldEndEditingToDinnerController = {[weak self] portion,row in
      self?.didPortionTextFieldEndEditingToMain!(portion,row)
      
    }

    
    // Begin TextField
    cell.productListViewController.didSelectTextFieldCellClouser = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField)
    }
    
    // Delete Product
    cell.productListViewController.didDeleteProductClouser = {[weak self] product in
      self?.didDeleteProductFromDinner!(product)
    }
  }
  
  // По идеии эти сигналы нужно прокинуть на mainController
  
  @objc private func handleTapListButtonInWillActiveTextField(button: UIButton) {

    guard let textField = button.superview  else {return}
    didTapListButtonInActiveTextField!(textField as! UITextField)

  }
  
  // Switch Active View
  private func didSwitchActiveView() {
    didSwitchActiveViewToMainView!()
  }

  // Add New Product
  private func addNewProductInDinner() {
    didAddNewProductInDinner!()
  }
  // CHoosePlace Injections
  private func choosePlaceInjections() {
    didShowChoosepalceIncjectionView!()
  }
  
  private func scrollingProductListView(isItScrollProductList: Bool) {
    collectionView.isScrollEnabled = isItScrollProductList
  }

}

// MARK: Height Dinner Cell

extension DinnerCollectionViewController {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//    if indexPath.row == 2 {
//      return .init(width: UIScreen.main.bounds.width - 40, height: 250)
//    }
    
//    let heightCell = CalculateHeightView.calculateMaxHeightDinnerCollectionView(dinnerData: dinnerViewModel)
    
    let heightCell = CalculateHeightView.calculateCurrentHeightDinnerCell(dinner: dinnerViewModel[indexPath.row])
    
    return .init(width: UIScreen.main.bounds.width - 40, height: heightCell + 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Constants.Main.DinnerCollectionView.contentInsert
  }
  
}

// MARK: TextField Delegate
extension DinnerCollectionViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didSelectTextField!(textField)
  }
  

}

// MARK: ScrollView Delegate
extension DinnerCollectionViewController: UIScrollViewDelegate {
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    didScrollDinnerCollectionView!()
  }
  
}
