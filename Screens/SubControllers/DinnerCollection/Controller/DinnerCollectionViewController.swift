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
    
    return collectionView
    
  }()
  
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
  

  
}





// MARK: Collection View Delegate DataSource

extension DinnerCollectionViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: DinnerCollectionViewCell.cellId, for: indexPath) as! DinnerCollectionViewCell
    
    let products = [ProductViewModel.init(carboIn100Grm: 10, carboInPortion: "5", name: "Пельмени", portion: "200")]
    
    let dummyViewModel = DinnerViewModel(shugar: "12", products: products, insulin: "1.5", shugarAfterMeal: nil)
    
    item.setViewModel(viewModel: dummyViewModel)
    setCellClousers(cell: item)
    return item
  }
  
  // в этом методе я расставлю  clouser чтобы только этот контроллер отвечал за все действия происходящие на его территории!
  private func setCellClousers(cell: DinnerCollectionViewCell) {
    
    // TextFiedl
    cell.shugarSetView.shugarValueTextField.delegate = self
    
    cell.productListViewController.didSelectTextFieldCellClouser = {[weak self] textField in
      self?.textFieldDidBeginEditing(textField)
    }
    
//    cell.productListViewController
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: UIScreen.main.bounds.width - 40, height: Constants.Main.Cell.mainMiddleCellHeight - 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Constants.Main.DinnerCollectionView.contentInsert
  }
  

}

extension DinnerCollectionViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didSelectTextField!(textField)
    print("Begin Editing Dinner Cell TextField")
  }
  
  
}
