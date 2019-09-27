//
//  DinnerCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


protocol DinnerViewModelCellable {
  
  var isPreviosDinner: Bool {get}
  var shugarBeforeEat: String {get}
  var productListViewModel: [ProductListViewModel] {get}
  var shugarAfterMeal: String? {get}
}


class DinnerCollectionViewCell: UICollectionViewCell {
  
  static let cellId = "DinnerCollectionViewCellId"
  
  // Нужно разделение Этой ячейки на предыдущий обед и текущий
  
  // Previos Dinner
  
  // 1. Сахар до еды - label
  // 2. Кнопка добавить  продукт - Должна быть скрыта
  // 3. Добавить label Сахар после обеда- который засетится с новыми данными
  // 4.
  
  // Теперь у меня задача сделать функционал мне нужно принимать данные
  
  // 1. Введите ваш текущий сахар - ТекстФилд
  
  // 2. Выберите продукты - Кнопка
  // Тут нужна логика появление Контроллера с списком продуктов или обедов
  // по такому же принципу как и menu View
  
  
  // 3. Введите дозировку инсулина - текстфилд и добавить кнопку расчет дозировки!
  
  // 4. Должен появлятся поле сахар после еды! чтобы понимать Правильно ли у нас прошла компенсация предыдущего обеда или нет- Соответсвенно сделать подсветку Ячейки!
  // При вводе текущего сахара передавать эту информацию в предыдущий обед! и только потом обучатся!
  
  // Получается что здесь должен лежать контроллер со своим функционалом
  
//  var isPreviosDinner = false

  
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
    shugarSetView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.DinnerCollectionView.ShugarViewTopMargin, left: 8, bottom: 0, right: 8))
  }
  // Set Up ProductView
  
  private func setUpProductView() {

    
    addSubview(touchesPassView)
    touchesPassView.fillSuperview()
    
    touchesPassView.addSubview(productListViewController.view)
    productListViewController.view.anchor(top: shugarSetView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding:.init(top: 5, left: 8, bottom: Constants.DinnerCollectionView.ProductListViewBottomMargin, right: 8))
    

    
  }
  
  
  
  func setViewModel(viewModel: DinnerViewModel) {
    
    productListViewController.setViewModel(viewModel: viewModel.productListViewModel,isPreviosDinner: viewModel.isPreviosDinner)
    
    setProductListViewHeight(isPreviosDinner: viewModel.isPreviosDinner)
    
    confirmIfPreviosDinner(shugarBeforeEat: viewModel.shugarBeforeEat, isPreviosDinner: viewModel.isPreviosDinner)
    
    
  }
  
  private func confirmIfPreviosDinner(shugarBeforeEat: String, isPreviosDinner: Bool) {
    
    shugarSetView.setShugarValueAndEnableTextField(shugarValue: shugarBeforeEat,isPreviosDinner: isPreviosDinner)
    isHiddenAddButton(isPreviosDinner: isPreviosDinner)
    
    
  }
  
  private func isHiddenAddButton(isPreviosDinner: Bool) {
    
    productListViewController.footerView.isHidden = isPreviosDinner
    
  }
  
  // Height Product List
  
  private func setProductListViewHeight(isPreviosDinner: Bool) {
    
    let heightProductListView = Calculator.calculateProductListViewheight(countRow: productListViewController.tableViewData.count,isPreviosDinner: isPreviosDinner)
    
    productListViewController.view.constrainHeight(constant: heightProductListView)
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


