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
  

  
  func setItems() {
    items = allProducts()
  }
  
  func getItems() -> Results<ProductRealm> {
    return items
  }
  
  
}

// MARK: Delete All Foods
extension FoodRealmManager {
  func deleteAllProducts() {
    
    let realm = self.productProvider.realm
    do {
      realm.beginWrite()
      realm.deleteAll()
      try realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
    
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
    
    let items = allProducts().filter("isFavorits == %@", true).sorted(byKeyPath: ProductRealm.Property.name.rawValue)
    
    return items
  }
  
  // Get product By Id
  
  func getProductById(id: String?) -> ProductRealm? {
    
    guard let id = id else {return nil}
    
    let realm = productProvider.realm
    let checkProduct = realm.object(ofType: ProductRealm.self, forPrimaryKey: id)

    return checkProduct
  }
  
  // Get categoryList
  
  func getCategoryList() -> [String] {
    
    let items = allProducts()
    let category = Set(items.map{$0.category})
    return Array(category).sorted()
  }
}

// MARK: Add Data in DB

extension FoodRealmManager {
  
  func addNewProduct(product: ProductRealm) {
  
    addProduct(product: product)

  }
  
  func setProductsToRealm(products: [ProductRealm]) {
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
  

  
}
  //MARK: DELETE
extension FoodRealmManager {
  
//  func deleteWhenProductListnerGetData(product: ProductRealm) {
//    let realm = productProvider.realm
//    
//    guard let realmProduct = realm.object(ofType: ProductRealm.self, forPrimaryKey: product.id) else {return}
//    deleteProduct(product: realmProduct)
//  }
  
  func deleteProducts(products:[ProductRealm]) {
    let realm = productProvider.realm
  
    let findProducts = products.compactMap({getProductById(id: $0.id)})
    do {
      realm.beginWrite()
      realm.delete(findProducts)
      
      try realm.commitWrite()
    } catch let error {
      print("Delete Products",error)
    }
  }

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
