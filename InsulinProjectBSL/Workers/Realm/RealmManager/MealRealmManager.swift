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
  
  
  // Fetch ALL
  func fetchAllMeals() -> Results<MealRealm> {
    
    let realm = RealmProvider.meals.realm
    
    return realm.objects(MealRealm.self)
  }
  
  private func setItems() {
    let realm = RealmProvider.meals.realm
    items = realm.objects(MealRealm.self)
  }
  
  // Search Meal By Name
  
//  func seacrhMealByName(character: String) -> Results<MealRealm> {
//
//    return fetchAllMeals().filter("name CONTAINS[cd] %@",character)
//  }
  
  func seacrhMealByName(character: String) -> Results<MealRealm> {
    
    return items.filter("name CONTAINS[cd] %@",character)
  }
  
  // либо вручную перезаписывать items или повесить обсервер!
  
  // MARK: Work With Meal
  
  // Delete Meal
  func deleteMeal(mealId: String) {
    let realm = RealmProvider.meals.realm
    
    guard let mealById = getMealById(mealId: mealId) else {return}
 
    try! realm.write {
      realm.delete(mealById)
    }
  }
  
  // Change Expanded Fields
  func changeMealExpande(mealId: String) {
    let realm = RealmProvider.meals.realm
    
    guard let mealById = getMealById(mealId: mealId) else {return}
    
    try! realm.write {
      mealById.isExpandMeal = !mealById.isExpandMeal
    }

  }
  
  // UPdate Meal
  
  // Update allFields
  func updateAllMealFields(viewModel: MealViewModel,callBackError: @escaping (Bool) -> Void) {
    
    let realm = RealmProvider.meals.realm
    guard let meal = getMealById(mealId: viewModel.mealId!) else {return}
    
    do {
      try realm.write {
        
        meal.name = viewModel.name
        meal.typeMeal = viewModel.typeMeal
        
      }
      callBackError(true)
      
    } catch let error {
      callBackError(false)
      print("Update Current Product in Realm Error",error)
    }
  }
  
  // Add New Meal
  func addNewMeal(viewModel: MealViewModel,callBackError: @escaping (Bool) -> Void) {
    
    // Здесь нужна проверка по имени обеда!
    if isCheckMealByName(name: viewModel.name) {
      // Нет такого имени
      let newMeal = MealRealm(name: viewModel.name, typeMeal: viewModel.typeMeal,isExpandMeal: viewModel.isExpanded)
      addMeal(meal: newMeal)
      callBackError(true)
      
    } else {
      
      callBackError(false)
    }
   
  }
  
  private func addMeal(meal: MealRealm) {
    
    let realm = RealmProvider.meals.realm
    
    try! realm.write {
      realm.add(meal)
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
  
  
  // MARK: Add Delete Update ProductList in MEal
  
  func deleteProductFromMeal(row: Int, mealId: String) {
    let realm = RealmProvider.meals.realm
    guard let  meal = getMealById(mealId: mealId) else {return}
    
    try! realm.write {
      meal.listProduct.remove(at: row)
    }
    
  }
  
  func updateProductPortionFromMeal(row: Int, mealId: String, portion:Int) {
    
    let realm = RealmProvider.meals.realm
    guard let  meal = getMealById(mealId: mealId) else {return}
    
    // проверка на то что мы получили новые данные тогда перезаписываем!
    guard meal.listProduct[row].portion != portion else {return}
    
    try! realm.write {
      
      meal.listProduct[row].portion = portion

    }
  }
  
  func addproductInMeal(mealId: String, productId: String) {
    
    let realmMeal = RealmProvider.meals.realm
    
    guard let  meal = getMealById(mealId: mealId) else {return}
    guard let product = foodRealmManager.getProductById(id: productId) else {return}
    
    // Создаем только кошда нет такого имени в обеде!
    if isProductInMeal(meal: meal, productName: product.name) {
      
      let newProduct = ProductRealm(name: product.name, category: product.category, carbo: product.carbo, isFavorits: product.isFavorits,portion: product.portion)
      try! realmMeal.write {
//        meal.listProduct.append(newProduct)
        meal.listProduct.insert(newProduct, at: 0)
      }
      
    }

    
  }
  
  private func isProductInMeal(meal: MealRealm,productName: String) -> Bool {
    
    return meal.listProduct.filter("name == %@",productName).isEmpty
  }
  
}
