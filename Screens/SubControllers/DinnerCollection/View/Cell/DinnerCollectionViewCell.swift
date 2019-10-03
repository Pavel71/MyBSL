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
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    setUpShuagarView()
    setUpProductView()
    setUpAddButton()
    setUpChoosePlaceInjectionsRowView()
    setUpWillActiveRow()
  }
  
  
  // Set Up Shugar View
  private func setUpShuagarView() {
    
    addSubview(shugarSetView)
    shugarSetView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom: 0, right: 8))
    
    shugarSetView.constrainHeight(constant: Constants.Main.DinnerCollectionView.shugarViewInCellHeight)
  }
  // Set Up ProductView
  
  private func setUpProductView() {

    addSubview(touchesPassView)
    touchesPassView.fillSuperview()
    
    touchesPassView.addSubview(productListViewController.view)
    productListViewController.view.anchor(top: shugarSetView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding:.init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:0, right: 8))
    
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
  
  
  var didTapAddNewProductInDinnerClouser: EmptyClouser?
  @objc private func handleAddNewProduct() {
    
    didTapAddNewProductInDinnerClouser!()
  }
  
  
  private func setUpChoosePlaceInjectionsRowView() {
    
    addSubview(chooseRowView)
    chooseRowView.anchor(top: addNewProductInMealButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:0, right: 8))
    chooseRowView.constrainHeight(constant: Constants.Main.DinnerCollectionView.choosePlaceInjectionsRowHeight)
    
  }
  
  private func setUpWillActiveRow() {
    
    addSubview(willActiveRow)
    willActiveRow.anchor(top: chooseRowView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:0, right: 8))
    willActiveRow.constrainHeight(constant: Constants.Main.DinnerCollectionView.willActiveRowHeight)
  }
  
  
  
  
  
  func setViewModel(viewModel: DinnerViewModel) {

    setShugarViewModel(shugarTopViewModel: viewModel.shugarTopViewModel)
    setProductListViewModel(viewModel: viewModel)

  }
  
  private func setShugarViewModel(shugarTopViewModel: ShugarTopViewModelable) {
    
    shugarSetView.setViewModel(viewModel: shugarTopViewModel)
    
 
  }
  
  private func setProductListViewModel(viewModel: DinnerViewModel) {
    
    
    productListViewController.setViewModel(viewModel: viewModel.productListInDinnerViewModel)
    

    let isPreviosDinner = viewModel.productListInDinnerViewModel.isPreviosDinner
    
    setProductListViewHeight(isPreviosDinner: isPreviosDinner)

  }
  

  
  // Height Product List
  
  private func setProductListViewHeight(isPreviosDinner: Bool) {
    
    let heightProductListView = CalculateHeightView.calculateProductListViewheight(countRow: productListViewController.tableViewData.count,isPreviosDinner: isPreviosDinner)
    
    productListViewController.view.constrainHeight(constant: heightProductListView)
    
    addNewProductInMealButton.isHidden = isPreviosDinner

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


