//
//  DinnerCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol DinnerViewModelCellable {

  var shugarTopViewModel: ShugarTopViewModelable {get set}
  var productListInDinnerViewModel: ProductListInDinnerViewModel {get set}
  var placeInjection: String {get set}
  var train: String? {get set}
  var isPreviosDinner: Bool {get set}
}


class DinnerCollectionViewCell: UICollectionViewCell {
  
  static let cellId = "DinnerCollectionViewCellId"
  
  
  // Shugar View
  let shugarSetView = ShugarSetView()
  
  // ProductController
  let productListViewController = ProductListInDinnerViewController()
  let touchesPassView = TouchesPassView()
  
  // Add New Product Button
  
  let addNewProductInMealButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor.white
    button.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
    
    return button
  }()
  
  // Choose InjectionsPlace
  
  let chooseRowView = ChoosePlaceInjectionsRowView()
  
  //  Will be Activity
  let willActiveRow = WillActiveView()
  let listTrainsViewController = ListTrainsViewController(style: .plain)
  
  // Constraint Property
  var choosePlaceInjectionViewTopConstraint: NSLayoutConstraint!
  var heightProductListConstraint: NSLayoutConstraint!
  
  
  // CLousers
  var didTapAddNewProductInDinnerClouser: EmptyClouser?
  
  // Pass Clousers
  var didShugarBeforeTextFieldChangeToDinnerViewController: StringPassClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    setUpShuagarView()
    setUpProductView()
    setUpAddButton()
    setUpChoosePlaceInjectionsRowView()
    setUpWillActiveRow()
  }

  // Height Product List
  
  private func setProductListViewHeight(countProducts: Int,isPreviosDinner: Bool) {
    
    
    let heightProductListView = CalculateHeightView.calculateProductListViewheight(countRow: countProducts,isPreviosDinner: isPreviosDinner)

    heightProductListConstraint.constant = heightProductListView
 
    addNewProductInMealButton.isHidden = isPreviosDinner
    
    choosePlaceInjectionViewTopConstraint.constant = isPreviosDinner ? Constants.Main.DinnerCollectionView.topMarginBetweenView : 30
    
    

  }
  
  
  
  
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    clipsToBounds = true
    layer.cornerRadius = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set CLousers Or Functions

extension DinnerCollectionViewCell {
  
 // Add New Product Button
  @objc private func handleAddNewProduct() {
    
    didTapAddNewProductInDinnerClouser!()
  }
  
  
  
}

// MARK: Set UP Views

extension DinnerCollectionViewCell {
  
  
  // Set Up Shugar View
  private func setUpShuagarView() {
    
    addSubview(shugarSetView)
    shugarSetView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom: 0, right: 8))
    
    shugarSetView.constrainHeight(constant: Constants.Main.DinnerCollectionView.shugarViewInCellHeight)
    
    // CLousers
    shugarSetView.didChangeShugarBeforeTextFieldToDinnerCellClouser = {[weak self] text in
      self?.didShugarBeforeTextFieldChangeToDinnerViewController!(text)
    }
    
  }
  // Set Up ProductView
  
  private func setUpProductView() {
    
    addSubview(touchesPassView)
    touchesPassView.fillSuperview()
    
    touchesPassView.addSubview(productListViewController.view)
    productListViewController.view.anchor(top: shugarSetView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding:.init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:0, right: 8))
    
    heightProductListConstraint = productListViewController.view.heightAnchor.constraint(equalToConstant: 0)
    heightProductListConstraint.isActive = true
  }
  
  private func setUpAddButton() {
    
    addNewProductInMealButton.addTarget(self, action: #selector(handleAddNewProduct), for: .touchUpInside)
    
    addNewProductInMealButton.clipsToBounds = true
    addNewProductInMealButton.layer.cornerRadius = Constants.ProductList.TableFooterView.addButtonHeight / 2
    
    addSubview(addNewProductInMealButton)
    addNewProductInMealButton.anchor(top: productListViewController.view.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -25, left: 0, bottom: 0, right: 0))
    addNewProductInMealButton.centerXAnchor.constraint(equalTo: productListViewController.view.centerXAnchor).isActive = true
    
    
    addNewProductInMealButton.constrainHeight(constant: Constants.ProductList.TableFooterView.addButtonHeight)
    addNewProductInMealButton.constrainWidth(constant: Constants.ProductList.TableFooterView.addButtonHeight)
  }
  
  
  
  private func setUpChoosePlaceInjectionsRowView() {
    
    // выводим врехний constraint  и регулируем его в зависимости от ситуацыии
    choosePlaceInjectionViewTopConstraint = chooseRowView.topAnchor.constraint(equalTo: productListViewController.view.bottomAnchor, constant: Constants.Main.DinnerCollectionView.topMarginBetweenView)
    
    addSubview(chooseRowView)
    chooseRowView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 8, bottom:0, right: 8))
    
    choosePlaceInjectionViewTopConstraint.isActive = true
    
    chooseRowView.constrainHeight(constant: Constants.Main.DinnerCollectionView.choosePlaceInjectionsRowHeight)
    
  }
  
  
  private func setUpWillActiveRow() {
    
    addSubview(willActiveRow)
    willActiveRow.anchor(top: chooseRowView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:0, right: 8))
    willActiveRow.constrainHeight(constant: Constants.Main.DinnerCollectionView.willActiveRowHeight)
    
    
    
  }
  

}

// MARK: Set View Models

extension DinnerCollectionViewCell {
  

  func setViewModel(viewModel: DinnerViewModel) {
    
    setShugarViewModel(shugarTopViewModel: viewModel.shugarTopViewModel)
    setProductListViewModel(productListViewModel: viewModel.productListInDinnerViewModel)
    
    setChoosePlaceViewModel(placeInjections: viewModel.placeInjection)
    
    // Здесь мне нужно будет учесть что если обед переходит в разряд прошлых то мы блокиреум ввод всего кроме скорректированного инсулина
    
    
  }
  
  private func setChoosePlaceViewModel(placeInjections: String) {
    
    if placeInjections.isEmpty == false {
      chooseRowView.chooseButton.setTitle(placeInjections, for: .normal)
    }
    
  }
  
  // Shugar ViewModle
  private func setShugarViewModel(shugarTopViewModel: ShugarTopViewModelable) {
    
    shugarSetView.setViewModel(viewModel: shugarTopViewModel)
    
    
  }
  
  // ProductListViewModel
  private func setProductListViewModel(productListViewModel: ProductListInDinnerViewModel) {
    
    
    productListViewController.setViewModel(viewModel: productListViewModel)
    
    
    let isPreviosDinner = productListViewModel.isPreviosDinner
    
    setProductListViewHeight(countProducts:productListViewModel.productsData.count, isPreviosDinner: isPreviosDinner)
    
  }
  
  
}

