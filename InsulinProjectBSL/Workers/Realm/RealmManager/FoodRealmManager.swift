//
//  FoodRealmManager.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift

// Возможно мне стоит здесь хранить Массив объектов Реалм!

class FoodRealmManager {
  
//  var items: Results<Product>! // Все объекты из схемы
  
  var productProvider: RealmProvider
  init(productProvider: RealmProvider = RealmProvider.products) {
    self.productProvider = productProvider
  }
  
  // Set Observer Token
  var didChangeRealmDB: (() -> Void)?
  func setObserverToken(items: Results<ProductRealm>) -> NotificationToken {

    let realmObserverToken = items.observe({ (change) in

      switch change {
      case .error(let error):
        print(error)
      case .initial(_):
        self.didChangeRealmDB!()
      case .update(_, deletions: let deletions, insertions: let insertions, modifications: let updates):
        
//        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates) // Это почему то не работает
        
        self.didChangeRealmDB!()
      }
      self.productProvider.realm.refresh() // Обновляю реалм схему
    })

    return realmObserverToken
  }
  
  
  // Get ALL
  func allProducts() -> Results<ProductRealm> {
    let allObjects = productProvider.realm.objects(ProductRealm.self)
    return allObjects.sorted(byKeyPath: ProductRealm.Property.name.rawValue)
  }
  
  // Get categoryList
  
  func getCategoryList() -> [String] {
    
    let realm = productProvider.realm
    let items = realm.objects(ProductRealm.self)
    var category = Set<String>()
    items.forEach { (product) in
      category.insert(product.category)
    }
    
    return Array(category).sorted()
  }
  
  // MARK: Add New Product
  func addNewProduct(newProduct: ProductRealm, callBackError: @escaping (Bool) -> Void) {
    
    if isCheckProductByName(name: newProduct.name) {
      // Нет такого имени
      addProduct(product: newProduct)
      callBackError(true)
    } else {
      callBackError(false)
    }
    
  }
  
  private func addProduct(product: ProductRealm) {
    let realm = productProvider.realm
    do {
      try realm.write {
        realm.add(product)
      }
    } catch let error {
      print("Add  a New Product  in RealmError",error)
    }
  }
  
  func getProductById(id: String?) -> ProductRealm? {
    
    guard let id = id else {return nil}
    
    let checkProduct = allProducts().first { (product) -> Bool in
      return product.id == id
    }
    return checkProduct
  }
  
  // Check By Name
  private func isCheckProductByName(name: String) -> Bool  {
    let realm = productProvider.realm
    return realm.objects(ProductRealm.self).filter("name == %@",name).isEmpty
  }
  
  // Update Favorits
  func updateProductFavoritField(product: ProductRealm) {
    let realm = productProvider.realm

    try! realm.write {
      product.isFavorits = !product.isFavorits
    }
  }
  
  // Update allFields
  func updateAllFields(viewModel: FoodCellViewModel) {
    
    let realm = productProvider.realm
    
    guard let product = getProductById(id: viewModel.id) else {return}

    do {
      try realm.write {
        
        product.name = viewModel.name
        product.carbo  = Int(viewModel.carbo)!
        product.category  = viewModel.category
        product.isFavorits = viewModel.isFavorit
        product.portion =  Int(viewModel.portion)!
        
      }
      
    } catch let error {
      print("Update Current Product in Realm Error",error)
    }
  }
  
  
  
  //DELETE
  func deleteProduct(product: ProductRealm) {
    
    let realm = productProvider.realm
    try! realm.write {
      realm.delete(product)
    }
  }
  
  // Filter By Name
  
//  func fetchProductByName(name: String) -> Results<Product> {
//    let realm = productProvider.realm
//    return realm.objects(Product.self).filter("name CONTAINS[cd] %@", name)
//  }
  
  // Filter By Favorits
  func fetchFavorits() -> Results<ProductRealm> {
    let realm = productProvider.realm
    return realm.objects(ProductRealm.self).filter("isFavorits == %@", true)
  }
  
  
}
