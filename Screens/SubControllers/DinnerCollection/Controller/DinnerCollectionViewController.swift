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
//    collectionView.contentInset = Constants.Main.DinnerCollectionView.contentInsert
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.decelerationRate = .fast
    collectionView.backgroundColor = .white
    collectionView.allowsSelection = false // Убераем выбор ячейка
    
    return collectionView
    
  }()
  
  let listTrainsViewController = ListTrainsViewController(style: .plain)
  
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
  
  var didAddNewProductInDinner: EmptyClouser?
  var didShowChoosepalceIncjectionView: EmptyClouser?
  var didTapListButtonInActiveTextField: ((UIButton) -> Void)?
  
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
    
    // Select TextField
    cell.productListViewController.didSelectTextFieldCellClouser = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField)
    }
    
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
    
    cell.willActiveRow.selectTrainTextField.delegate = self
    cell.willActiveRow.selectTrainTextField.listButton.addTarget(self, action: #selector(handleTapListButtonInWillActiveTextField), for: .touchUpInside)
    
    
  }
  
  // По идеии эти сигналы нужно прокинуть на mainController
  
  @objc private func handleTapListButtonInWillActiveTextField(button: UIButton) {

    let textField = button.superview!
    
    
    
    
    let point  = view.convert(textField.center, to: textField.superview)
    print(point)
    
    let rect = CGRect(x: point.x + 25, y: -point.y + 55, width: textField.frame.width, height: 150)
    
    if view.subviews.contains(listTrainsViewController.view) {
      removeListTableView()
      collectionView.isScrollEnabled = true
    } else {
      setUpListTrainsView(rect: rect)
      collectionView.isScrollEnabled = false
    }
    
    
    
//    didTapListButtonInActiveTextField!(button)
  }
  
  
  // Тестим Здесь пока что
  
  private func setUpListTrainsView(rect: CGRect) {
    listTrainsViewController.view.frame = rect
    view.addSubview(listTrainsViewController.view)
    listTrainsViewController.view.alpha = 0
    
    UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.listTrainsViewController.view.alpha = 1
    }, completion: nil)
    
    //    mainView.addSubview(listTrainsViewController.view)
  }
  
  private func removeListTableView() {
    
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.listTrainsViewController.view.alpha = 0
    }) { (succes) in
      self.listTrainsViewController.view.removeFromSuperview()
    }
    
  }
  
  
  
  private func addNewProductInDinner() {
    didAddNewProductInDinner!()
  }
  
  private func choosePlaceInjections() {
    didShowChoosepalceIncjectionView!()
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

    let heightCell = CalculateHeightView.calculateMaxHeightDinnerCollectionView(dinnerData: dinnerViewModel)
    
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
