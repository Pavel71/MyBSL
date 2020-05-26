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
  
  var items: Results<ProductRealm>! // Все объекты из схемы
  var productProvider: RealmProvider
  
  init(productProvider: RealmProvider = RealmProvider.products) {
    self.productProvider = productProvider
    
    setItems()
  }
  
  // Короче сюда нужно передать какой сегмент у нас потомучто обсервер достает значение которое почему то не изменяется
  
  // Set Observer Token
  var didChangeRealmDB: (() -> Void)?
  //  var didChangeSegmentItems: ((Results<ProductRealm>) -> Void)?
  
  // Че то это все очень медленно работает! Надо переписать руками обновление!
  
//  func setObserverToken() -> NotificationToken {
//
//    // Просто этот клоузер почему то завхватывает значения на момент инициализации
//    // Поэтому здеь работать с itesm не лучший вариант
//    let realmObserverToken = items.observe({  (change) in
//
//      switch change {
//      case .error(let error):
//        print(error)
//      case .initial(_):
//
//        self.didChangeRealmDB!()
//      case .update(_, deletions: let deletions, insertions: let insertions, modifications: let updates):
//        print("change Food Db")
//
//        //        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates) // Это почему то не работает
//
//        self.didChangeRealmDB!()
//      }
//      self.productProvider.realm.refresh() // Обновляю реалм схему
//    })
//
//    return realmObserverToken
//  }
  
  func setItems() {
    items = allProducts()
  }
  
  func getItems() -> Results<ProductRealm> {
    return items
  }
  
  
}

// MARK: Fetch Data From DB

extension FoodRealmManager {
  
  // Fetch All
  
  func allProducts() -> Results<ProductRealm> {
    
    
    let items = productProvider.realm.objects(ProductRealm.self).sorted(byKeyPath: ProductRealm.Property.name.rawValue)
    
    return items
  }
  
  // Fetch By Name
  
  func fetchProductByName(name: String) -> Results<ProductRealm> {
    
    let realm = productProvider.realm
    
    return realm.objects(ProductRealm.self).filter("name CONTAINS[cd] %@", name)
    
  }
  
  // Fetch By Favorits
  func fetchFavorits() -> Results<ProductRealm> {
    print("Fetch Favorits Products")
    let items = allProducts().filter("isFavorits == %@", true).sorted(byKeyPath: ProductRealm.Property.name.rawValue)
    print(items,"Favorit")
    return items
  }
  
  // Get product By Id
  
  func getProductById(id: String?) -> ProductRealm? {
    
    guard let id = id else {return nil}
    
    let checkProduct = allProducts().first { (product) -> Bool in
      return product.id == id
    }
    return checkProduct
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
}

// MARK: Add Data in DB

extension FoodRealmManager {
  
  func addNewProduct(product: ProductRealm) {
  
    addProduct(product: product)

  }
  
  func setProductsFromFireStore(products: [ProductRealm]) {
    let realm = productProvider.realm
    do {
         realm.beginWrite()
         realm.add(products, update: .all)
         try realm.commitWrite()
         print(realm.configuration.fileURL?.absoluteURL as Any,"Products in DB")
         
       } catch {
         print(error.localizedDescription)
       }
    setItems()
  }
  

  
  private func addProduct(product: ProductRealm) {
    let realm = productProvider.realm
    
    print("Добавляем продукт")
    
      do {
        
        realm.beginWrite()
        realm.add(product, update: .modified)
        
        try realm.commitWrite()
        
        print(realm.configuration.fileURL?.absoluteURL as Any,"Food in DB")
        
      } catch let error {
        print("Add  a New Product  in RealmError",error)
      
    }

  }
  
  
  
  // Check By Name
  func isCheckProductByName(name: String) -> Bool  {
    
    let realm = productProvider.realm
    
    return realm.objects(ProductRealm.self).filter("name == %@",name).isEmpty
  }
  
  // Update Favorits
  func updateProductFavoritField(product: ProductRealm) {
    
    let realm = productProvider.realm
    
    do {
      
      realm.beginWrite()
      product.isFavorits = !product.isFavorits
      
      try realm.commitWrite()
      
      
    } catch let error {
      print("Update Favorits",error)
    }
  }
  
  //MARK: Update allFields
  func updateAllFields(dataDict: [String: Any],productId: String) {
    
    let realm = productProvider.realm
    
    guard let product = getProductById(id: productId) else {return}
    
      do {
        
        realm.beginWrite()
        
        product.name           = dataDict[ProductNetworkModel.CodingKeys.name.rawValue] as! String
        product.carboIn100grm  = dataDict[ProductNetworkModel.CodingKeys.carboIn100grm.rawValue] as! Int
        product.category       = dataDict[ProductNetworkModel.CodingKeys.category.rawValue] as! String
        product.isFavorits     = dataDict[ProductNetworkModel.CodingKeys.isFavorits.rawValue] as! Bool
        product.portion        =  dataDict[ProductNetworkModel.CodingKeys.portion.rawValue] as! Int
        
        try realm.commitWrite()
        
        
      } catch let error {
        print("Update Current Product in Realm Error",error)
      }
    
  }
  
  
  
  //DELETE
  func deleteProduct(product: ProductRealm) {
    
    let realm = productProvider.realm
    
    do {
      
      realm.beginWrite()
      realm.delete(product)
      
      try realm.commitWrite()
      
      
    } catch let error {
      print("Update Favorits",error)
    }
    
  }
}
