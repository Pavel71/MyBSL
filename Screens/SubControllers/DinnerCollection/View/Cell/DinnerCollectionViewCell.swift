//
//  DinnerCollectionViewCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


// MARK: Enums

enum CorrectInsulinPosition {
  case needCorrect
  case dontCorrect
  
  // Way Correct Position Need to Set Right Image
  
  case correctUp
  case correctDown
  
}


enum CompansationPosition: Int {
  case good
  case bad
  case progress
  case new
}

enum DinnerPosition {
  case newdinner
  case previosdinner
}


protocol DinnerViewModelCellable {

  var shugarTopViewModel: ShugarTopViewModelable {get set}
  var productListInDinnerViewModel: ProductListInDinnerViewModel {get set}
  var placeInjection: String {get set}
  var train: String? {get set}
  
  var isPreviosDinner: Bool {get set} // Deprecated
  
  
  // Enum States
  
  var correctInsulinByShugarPosition: CorrectInsulinPosition {get set}
  var dinnerPosition: DinnerPosition {get set}
  var compansationFase: CompansationPosition {get set}
  
}


class DinnerCollectionViewCell: UICollectionViewCell {
  
  static let cellId = "DinnerCollectionViewCellId"
  
  
  var compasationPosition: CompansationPosition              = .new
  var dinnerPosition: DinnerPosition                         = .newdinner
  var correctInsulinByShugarPosition: CorrectInsulinPosition = .dontCorrect
  
  // Shugar View
  let shugarSetView = ShugarSetView()
  
  // ProductController
  let productListViewController = ProductListInDinnerViewController()
  
  
  // Если у нас вертикальное меню то это решение не нужно!
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
  // Total Insulin View
  
  let totalInsulinView = TotalInsulinView()
  
  //  Will be Activity
  let willActiveRow = WillActiveView()
  let listTrainsViewController = ListTrainsViewController(style: .plain)
  
  // Constraint Property
  var choosePlaceInjectionViewTopConstraint: NSLayoutConstraint!
  var heightProductListConstraint: NSLayoutConstraint!
  
  
  // CLousers
  var didTapAddNewProductInDinnerClouser: EmptyClouser?
  
  // Pass Clousers
  var didShugarBeforeTextFieldChangeToDinnerViewController: FloatPassClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6196078431, blue: 0.8588235294, alpha: 1)

    setUpViews()

  }

  // Height Product List
  
  private func setProductListViewHeight(countProducts: Int,isPreviosDinner: Bool) {
    
    
    let heightProductListView = CalculateHeightView.calculateProductListViewheight(countRow: countProducts,isPreviosDinner: isPreviosDinner)

    heightProductListConstraint.constant = heightProductListView


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
  
  private func setUpViews() {
    
    setUpShuagarView()
    
    setUpWillActiveRow()
    setUpChoosePlaceInjectionsAndTotalInsulinView()
    //    setUpChoosePlaceInjectionsRowView()
    
    addSubview(touchesPassView)
    touchesPassView.fillSuperview()
    
    setUpProductView()
    setUpAddButton()
  }
  
  
  // Set Up Shugar View
  private func setUpShuagarView() {
    
    addSubview(shugarSetView)
    shugarSetView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom: 0, right: 8))
    
    shugarSetView.constrainHeight(constant: Constants.Main.DinnerCollectionView.shugarViewInCellHeight)
    
    // CLousers
    shugarSetView.didChangeShugarBeforeTextFieldToDinnerCellClouser = {[weak self] shugarBefore in
      self?.didShugarBeforeTextFieldChangeToDinnerViewController!(shugarBefore)
    }
    
  }
  // Set Up ProductView And Touches View
  
  private func setUpProductView() {
    
//    addSubview(touchesPassView)
//    touchesPassView.fillSuperview()
    
    touchesPassView.addSubview(productListViewController.view)
    productListViewController.view.anchor(top: shugarSetView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding:.init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:0, right: 8))
    
    heightProductListConstraint = productListViewController.view.heightAnchor.constraint(equalToConstant: 0)
    heightProductListConstraint.isActive = true
    
    // Нам нужно добавить эту вьющку поверх
//    insertSubview(touchesPassView, aboveSubview: productListViewController.view)
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
  
  private func setUpChoosePlaceInjectionsAndTotalInsulinView() {
    
    let stackView = UIStackView(arrangedSubviews: [
    chooseRowView,totalInsulinView
    ])
    totalInsulinView.constrainWidth(constant: 100)

    stackView.spacing = 10
    addSubview(stackView)
    stackView.anchor(top: nil, leading: leadingAnchor, bottom: willActiveRow.topAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 8, bottom:10, right: 8))
    stackView.constrainHeight(constant: Constants.Main.DinnerCollectionView.choosePlaceInjectionsRowHeight)
  }
  
  
  
  
  private func setUpWillActiveRow() {
    
    let spacingView = UIView()
    let stackView = UIStackView(arrangedSubviews: [
    willActiveRow,spacingView
    ])
    spacingView.constrainWidth(constant: 100)
    

//    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    addSubview(stackView)
    stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: Constants.Main.DinnerCollectionView.topMarginBetweenView, left: 8, bottom:10, right: 8))
    stackView.constrainHeight(constant: Constants.Main.DinnerCollectionView.willActiveRowHeight)
    
    
    
  }
  

}

// MARK: Set View Models

extension DinnerCollectionViewCell {
  

  func setViewModel(viewModel: DinnerViewModel) {
    
    compasationPosition = viewModel.compansationFase
    dinnerPosition = viewModel.dinnerPosition
    correctInsulinByShugarPosition = viewModel.correctInsulinByShugarPosition
    
    // Я так понимаю что здесь будут проблемы из за того что ячейки они обновляются постоянно и нельзя просто руками засетить флаги нужно и для нового обеда ставить свои флаги а это 2 раза больше кода но гораздо читаеме
    
    // Здесь до разделения должны идти методы которые засетят данные а уже изменение UI пускай идет в switch
    
    // Set Data
    setViewModelsInCell(viewModel: viewModel)
    
    
    // Set Views in Position
    
    switch viewModel.dinnerPosition {
    case .newdinner:
      

      updateViewsNewDinner()
    case .previosdinner:
      
      updateViewsPrevDinner()
    }
    
    // Set Views in Compansation Fase
    setCompansationFase()

    
  }
  
  // Set Data
  
  private func setViewModelsInCell(viewModel:DinnerViewModel) {
    setShugarViewModel(shugarTopViewModel: viewModel.shugarTopViewModel)
    setProductListViewModel(productListViewModel: viewModel.productListInDinnerViewModel)
    
    setTotalInsulinValue(totalInsulin: viewModel.totalInsulin)
    setChoosePlaceViewModel(placeInjections: viewModel.placeInjection)
  }

  
  // Set Compansation
   
   private func setCompansationFase() {

     switch compasationPosition {
       case .good:
         
       totalInsulinView.totalInsulinImageView.tintColor = #colorLiteral(red: 0, green: 0.8886825442, blue: 0, alpha: 1)
       
       case .bad:
         
       totalInsulinView.totalInsulinImageView.tintColor = #colorLiteral(red: 0.9538820386, green: 0.06064923853, blue: 0.02890501916, alpha: 1)
       case .progress:
         
       totalInsulinView.totalInsulinImageView.tintColor = #colorLiteral(red: 0.9173465967, green: 1, blue: 0.1846651733, alpha: 1)
     case .new:
      
       totalInsulinView.totalInsulinImageView.tintColor = .white


       }
   }

  
}


// MARK: Set View Models

extension DinnerCollectionViewCell {
  
  private func setTotalInsulinValue(totalInsulin: Float) {
    totalInsulinView.totalInsulinLabel.text = String(totalInsulin)
    // Если самый первый обед то у него не будет это поле!

  }
  
  private func setChoosePlaceViewModel(placeInjections: String) {
    
    if placeInjections.isEmpty == false {
      chooseRowView.chooseButton.setTitle(placeInjections, for: .normal)
    }
    
  }
  
  // Shugar ViewModle
  private func setShugarViewModel(shugarTopViewModel: ShugarTopViewModelable) {
    shugarSetView.setViewModel(
      viewModel: shugarTopViewModel,
      dinnerPosition: dinnerPosition,
      correctInsulinPosition: correctInsulinByShugarPosition)
  }
  
  // ProductListViewModel
  private func setProductListViewModel(productListViewModel: ProductListInDinnerViewModel) {

    
    productListViewController.setViewModel(viewModel: productListViewModel)
    
    let isPreviosDinner = productListViewModel.isPreviosDinner

    setProductListViewHeight(countProducts:productListViewModel.productsData.count, isPreviosDinner: isPreviosDinner)
    
  }
  
}

// MARK: Update New Dinner Views

extension DinnerCollectionViewCell {
  
  private func updateViewsNewDinner() {
     addNewProductInMealButton.isHidden = false
     chooseRowView.chooseButton.isEnabled = true
     
     chooseRowView.chooseButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
   }
}

// MARK: Update Previos Dinner Views
 
extension DinnerCollectionViewCell {
  
  private func updateViewsPrevDinner() {
    addNewProductInMealButton.isHidden = true
    chooseRowView.chooseButton.isEnabled = false

    chooseRowView.chooseButton.backgroundColor = .clear
  }
  
  
 
}

