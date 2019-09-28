//
//  DinnerCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol DinnerViewModelCellable {

  var productListInDinnerViewModel: ProductListInDinnerViewModel {get set}
  var shugarTopViewModel: ShugarTopViewModelable {get set}
  var resultBottomViewModel: ProductListResultsViewModel {get set}
  

}


class DinnerCollectionViewCell: UICollectionViewCell {
  
  static let cellId = "DinnerCollectionViewCellId"
  
 
  
  let shugarSetView = ShugarSetView(frame: .init(x: 0, y: 0, width: 0, height: Constants.Main.DinnerCollectionView.shugarViewInCellHeight))
  
  let productListViewController = ProductListInDinnerViewController()
  let touchesPassView = TouchesPassView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)
    
    setUpShuagarView()
    setUpProductView()
    
  }
  
  
  // Set Up Shugar View
  private func setUpShuagarView() {
    
    addSubview(shugarSetView)
    shugarSetView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.shugarViewTopMargin, left: 8, bottom: 0, right: 8))
  }
  // Set Up ProductView
  
  private func setUpProductView() {

    
    addSubview(touchesPassView)
    touchesPassView.fillSuperview()
    
    touchesPassView.addSubview(productListViewController.view)
    productListViewController.view.anchor(top: shugarSetView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding:.init(top: 5, left: 8, bottom: Constants.Main.DinnerCollectionView.productListViewBottomMargin, right: 8))
    
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
    
    let heightProductListView = Calculator.calculateProductListViewheight(countRow: productListViewController.tableViewData.count,isPreviosDinner: isPreviosDinner)
    
    productListViewController.view.constrainHeight(constant: heightProductListView)
    
    // Не знаю почему но Здесь подходит только такой размер
    let height = isPreviosDinner ? 30 : Constants.ProductList.TableFooterView.footerHeight
    
    productListViewController.footerView.frame = .init(x: 0, y: 0, width: 0, height: height)
    productListViewController.footerView.addNewProductInMealButton.isHidden = isPreviosDinner
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


