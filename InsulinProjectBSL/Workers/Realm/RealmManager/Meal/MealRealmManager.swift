//
//  MealRealmManager.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 30/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift


class MealRealmManager {
  
  
  let provider: RealmProvider
  let foodRealmManager: FoodRealmManager
  
  var items: Results<MealRealm>!
  
  init(provider: RealmProvider = RealmProvider.meals) {
    self.provider = provider
    self.foodRealmManager = FoodRealmManager()
    setItems()
  }
  
  // SetObserver
  var didChangeRealmDB: ((Results<MealRealm>) -> Void)?
  
  func setObserverToken() -> NotificationToken {
    
    let realmObserverToken = items.observe({ (change) in
      
      switch change {
      case .error(let error):
        print(error)
      case .initial(_):
        
        self.didChangeRealmDB!(self.items)
      case .update(_, deletions: let deletions, insertions: let insertions, modifications: let updates):
        
        self.didChangeRealmDB!(self.items)
      }
      
      self.provider.realm.refresh() // Обновляю реалм схему
    })
    
    return realmObserverToken
  }

  
  private func setItems() {
    let realm = RealmProvider.meals.realm
    items = realm.objects(MealRealm.self)
  }
  
  
  
}

// MARK: Delete All Meals

extension MealRealmManager {
  func deleteAllMeals() {
    let realm = self.provider.realm
    do {
      realm.beginWrite()
      realm.deleteAll()
      try realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
    
  }
}

// MARK: Work with Meal

extension MealRealmManager {
  
  func fetchAllProductsInMealById(mealId: String) -> [ProductRealm]? {
    
    guard let meal = getMealById(mealId: mealId) else {return nil}
    return Array(meal.listProduct)
  }
  
  // Fetch ALL
  func fetchAllMeals() -> Results<MealRealm> {
    
    let realm = RealmProvider.meals.realm
    
    return realm.objects(MealRealm.self)
  }
  
  // Search
  
  func seacrhMealByName(character: String) -> Results<MealRealm> {
    return items.filter("name CONTAINS[cd] %@",character)
  }
  
  // Delete Meal
  func deleteMeal(mealId: String) {
    let realm = RealmProvider.meals.realm
    
    guard let mealById = getMealById(mealId: mealId) else {return}
    
    do {
         realm.beginWrite()
         
          realm.delete(mealById)
         
         try realm.commitWrite()

       } catch let error {
         
         print("Update Current Product in Realm Error",error)
       }

  }
  
  // MARK: Change Expanded Fields
  func changeMealExpande(mealId: String) {
    let realm = RealmProvider.meals.realm
    
    guard let mealById = getMealById(mealId: mealId) else {return}
    
    do {
      
      realm.beginWrite()
      
       mealById.isExpandMeal = !mealById.isExpandMeal
      
      try realm.commitWrite()
      
      
      
    } catch let error {
      
      print("Update Current Product in Realm Error",error)
    }
     
    
  }
  
  // UPdate Meal
  
  // MARK: Update allFields
  func updateAllMealFields(viewModel: MealViewModel) -> MealRealm? {
    
    let realm = RealmProvider.meals.realm
    guard let meal = getMealById(mealId: viewModel.mealId!) else {return nil}
    
    do {
      
      realm.beginWrite()
      
      meal.name     = viewModel.name
      meal.typeMeal = viewModel.typeMeal
      
      try realm.commitWrite()

    } catch let error {
      
      print("Update Current Product in Realm Error",error)
    }
    return meal
  }
  
  // MARK: Add New Meal
  func addNewMeal(mealRealm: MealRealm,callBackError: @escaping (Bool) -> Void) {
    
    // Здесь нужна проверка по имени обеда!
    if isCheckMealByName(name: mealRealm.name) {
      
      addMeal(meal: mealRealm)
      callBackError(true)
      
    } else {
      
      callBackError(false)
    }
    
  }
  
  private func addMeal(meal: MealRealm) {
    
    let realm = RealmProvider.meals.realm
    
    do {
      
      realm.beginWrite()
      
      realm.add(meal, update: .modified)
      
      try realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  // MARK: Set Meals From FireStore
  
  func setMealsFromFireStore(meals: [MealRealm]) {
    let realm = RealmProvider.meals.realm
    

    
    do {
         realm.beginWrite()
         realm.add(meals, update: .all)
         try realm.commitWrite()
         print(realm.configuration.fileURL?.absoluteURL as Any,"Meals in DB")
         
       } catch {
         print(error.localizedDescription)
       }
  }
  
  // Check By Name
  private func isCheckMealByName(name: String) -> Bool  {
    let realm = RealmProvider.meals.realm
    return realm.objects(MealRealm.self).filter("name == %@",name).isEmpty
  }
  
  // get MEal By ID
  func getMealById(mealId: String) -> MealRealm? {
    
    let items = fetchAllMeals()
    
    let checkMeal = items.first { (meal) -> Bool in
      return meal.id == mealId
    }
    return checkMeal
    
  }
  
  // List TypeOF Meal
  
  func getTypeOFMealList() -> [String] {
    
    let realm = RealmProvider.meals.realm
    
    let items = realm.objects(MealRealm.self)
    
    var category = Set<String>()
    
    items.forEach { (meal) in
      category.insert(meal.typeMeal)
    }
    
    return Array(category).sorted()
  }
}

// MARK: Work With Product List in Meal

extension MealRealmManager {
  
  
  // MARK: Delete Product From Meal
  
  func deleteProductFromMeal(productName: String, mealId: String) -> MealRealm? {
    
    let realm = RealmProvider.meals.realm
    
    guard let  meal = getMealById(mealId: mealId) else {return nil}
    
    guard let index = meal.listProduct.index(matching: "name == %@",productName) else {return nil}
    
    do {
      
      realm.beginWrite()
      
      meal.listProduct.remove(at: index)
      
      try realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    
    return meal
    
  }
  

  func getproductIdByNameFromMeal(mealId: String,productName: String) -> String? {
    
    guard let  meal = getMealById(mealId: mealId) else {return nil}
    
    guard let product = meal.listProduct.filter("name == %@",productName).first else {return nil}
    
    print("Update or delete product ID",product.id)
    return product.id
  }
  
  // MARK: Update Product In Meal
  
  func updateProductPortionFromMeal(productName: String, mealId: String, portion:Int) -> MealRealm? {
    
    let realm = RealmProvider.meals.realm
    guard let  meal = getMealById(mealId: mealId) else {return nil}
    
    do {
      
      realm.beginWrite()
      
      meal.listProduct.forEach { (product) in
        if product.name == productName {
          product.portion = portion
          
        }
      }
      
      try realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    
    return meal
  }
  
  
  // MARK: Add Product To Meal
  
  func addproductInMeal(mealId: String, product: ProductRealm) -> MealRealm? {
    
    let realmMeal = RealmProvider.meals.realm
    
    guard let  meal = getMealById(mealId: mealId) else {return nil}
    //    guard let product = foodRealmManager.getProductById(id: productId) else {return}
    
    // Создаем только кошда нет такого имени в обеде!
    guard isProductInMeal(meal: meal, productName: product.name) else {return nil}
      
      
      let newProduct = ProductRealm(
        name                  : product.name,
        category              : product.category,
        carboIn100Grm         : product.carboIn100grm,
        isFavorits            : product.isFavorits,
        portion               : product.portion)
      
      print("Add New product with ID", newProduct.id)
        
      do {
        
        realmMeal.beginWrite()
        
        meal.listProduct.insert(newProduct, at: 0)
        
        try realmMeal.commitWrite()
        
        
      } catch {
        print(error.localizedDescription)
      }
      
      return meal

  }
  
  private func isProductInMeal(meal: MealRealm,productName: String) -> Bool {
    
    return meal.listProduct.filter("name == %@",productName).isEmpty
  }
}
