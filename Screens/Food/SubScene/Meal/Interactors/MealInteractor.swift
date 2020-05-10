//
//  MealInteractor.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 29/08/2019.
//  Copyright (c) 2019 PavelM. All rights reserved.
//

import UIKit
import RealmSwift

protocol MealBusinessLogic {
  func makeRequest(request: Meal.Model.Request.RequestType)
}

class MealInteractor: MealBusinessLogic {
  
  var presenter     : MealPresentationLogic?
  var realmManager  : MealRealmManager!
  var addService    : AddService!
  var updateService : UpdateService!
  var deleteService : DeleteService!
  
//  var items: Results<MealRealm>!
  
  var isDefaultList = true
  
  init() {
    let locator = ServiceLocator.shared
    
    realmManager  = locator.getService()
    addService    = locator.getService()
    updateService = locator.getService()
    deleteService = locator.getService()
  }
  
  func makeRequest(request: Meal.Model.Request.RequestType) {

    
    workWithMealRequest(request: request)
    workWithProductListFromMealRequests(request: request)
    
    switch request {
      
    // Show Sections By Type OF meal
    case .showListMealsBySection(let isDefaultList):
      
      self.isDefaultList = isDefaultList
      let items = realmManager.fetchAllMeals()
      
      presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
      
      // Search Bar
    case .searchMealByname(let character):
      
      let items = realmManager.seacrhMealByName(character: character)
      presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
      
    // Set Realm Observer
    case .setRealmObserver:
      
      realmManager.didChangeRealmDB = {[weak self] items in self?.realmDBDidChange(items: items)}
      let realmTokken = realmManager.setObserverToken()
      
      presenter?.presentData(response: .passRealmObserverTokken(realmTokken: realmTokken))

      
      // Show NewMealView
      
    case .showNewMealView(let mealId):
      
      let listOFTypeMeal = getListOfTypeOfMeal()
      let updateMeal = getUpdateMeal(mealId: mealId)
      
      presenter?.presentData(response: .prepareNewMealViewModel(updateMeal: updateMeal, listOfTypeMeal: listOFTypeMeal))
      
    default:break
    }
    
    
    
  }
  
  private func workWithProductListFromMealRequests(request:Meal.Model.Request.RequestType) {
    
    switch  request {
      // Product List Delete Update Add
      case .deleteProductFromMeal(let mealId, let productName):
        
        print("Delete Product From Realm and Firebase",productName)
        
        guard let productIdRemove = realmManager.getproductIdByNameFromMeal(mealId: mealId, productName: productName) else {return}
        
        realmManager.deleteProductFromMeal(productName: productName, mealId: mealId) // realmDBDidChange
        
        
        deleteProductFromMealFireStore(productId: productIdRemove, mealId: mealId)
      
      case .updateProductPortionFromMeal(let mealId, let productName, let portion):
        
        realmManager.updateProductPortionFromMeal(productName: productName, mealId: mealId, portion: portion) // realmDBDidChange
       
        guard let productId = realmManager.getproductIdByNameFromMeal(mealId: mealId, productName: productName) else {return}
        
        updateProductsPortionInMealsFireStore(productId: productId, portion: portion, mealId: mealId)
      
      case .addProductInMeal(let mealId, let product):
        
        guard let newProduct = realmManager.addproductInMeal(mealId: mealId, product: product) else {return} // realmDBDidChange
        addProductsInMealsFireStore(product: newProduct, mealId: mealId)
        
      
    default:break
    }
  }
  
  // MARK: Work With Meal Request
  
  private func workWithMealRequest(request:Meal.Model.Request.RequestType) {
    
    switch request {
      // FetchAll Meals
      case .fetchAllMeals:
        let items = realmManager.fetchAllMeals()
        presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
     
      
      
    // Expand Meal
      case .expandedMeal(let mealId):
      
        realmManager.changeMealExpande(mealId: mealId) // realmDBDidChange
      // Delete Meal
      case .deleteMeal(let mealId):
        
        realmManager.deleteMeal(mealId: mealId) // realmDBDidChange
       deleteMealFromFireStore(mealId: mealId)
      // Add or Update Meal
      
      case .addOrUpdateNewMeal(let viewModel):
        
        if viewModel.mealId != nil {
          
          
          realmManager.updateAllMealFields(viewModel: viewModel) { [weak self] (success) in
            self?.presenter?.presentData(response: .passSuccessAddOrUpdateMeal(isSuccessAdd:success, isUpdateMeal: true)) // realmDBDidChange
          }
          updateMealInFireStore(viewModel: viewModel)
          
          
        } else {
          
          let mealRealm = createMealRealm(viewModel: viewModel)
          
          realmManager.addNewMeal(mealRealm: mealRealm) { [weak self] (success) in
            
            self?.presenter?.presentData(response: .passSuccessAddOrUpdateMeal(isSuccessAdd:success, isUpdateMeal: false)) // realmDBDidChange
          }
          
          addMealToFireStore(mealRealm: mealRealm)
          
        }
      
    default:break
    }
  }
  
 
  
  private func realmDBDidChange(items: Results<MealRealm>) {
    print("Change DB Meal Realm")
    
    presenter?.presentData(response: .prepareMealViewModelforTableView(items: items, bySections: isDefaultList))
  }
  
}


// MARK: Work with FireStore

extension MealInteractor {
  
  // MARK: Products from Meals
  
  // Delete Product
  
  private func deleteProductFromMealFireStore(productId: String, mealId: String) {
    
    deleteService.deleteProductFromMealFireStore(mealId: mealId, productId: productId)
  }
  
  // Add Product
  private func addProductsInMealsFireStore(product:ProductRealm,mealId: String) {
    
    let productFireStore = createNewFireBaseProduct(productRealm: product)
    
    addService.addProductInMeal(mealId: mealId, product: productFireStore)
    
  }
  // Update Product
  private func updateProductsPortionInMealsFireStore(
    productId : String,
    portion   : Int,
    mealId    : String) {
    
    
    
    updateService.updateProductInMealInFireStore(productId: productId, mealId: mealId, portion: portion)
  }
  
  
  
  // MARK: Meals
  private func deleteMealFromFireStore(mealId: String) {
    deleteService.deleteMealFromFireStore(mealId: mealId)
  }
  
  
  // UPDATE Meal
  private func updateMealInFireStore(viewModel: MealViewModel) {
    
    let data = createMealData(viewModel: viewModel)
    
    updateService.updateMealInFireStore(
      mealId: viewModel.mealId!,
      data: data)
  }
  
  private func createMealData(viewModel: MealViewModel) -> [String: Any] {
    
    [
      MealNetworkModel.CodingKeys.name.rawValue         : viewModel.name,
      MealNetworkModel.CodingKeys.isExpandMeal.rawValue : viewModel.isExpanded,
      MealNetworkModel.CodingKeys.typeMeal.rawValue     : viewModel.typeMeal,
      MealNetworkModel.CodingKeys.listProduct.rawValue  : viewModel.products
    ]
    
  }
  
   private func createNewFireBaseProduct(productRealm: ProductRealm) -> ProductNetworkModel {
    
    print(productRealm,"Product Realm")

     return ProductNetworkModel(
       id                     : productRealm.id,
       name                   : productRealm.name,
       category               : productRealm.category,
       carboIn100grm          : productRealm.carboIn100grm,
       portion                : productRealm.portion,
       percantageCarboInMeal  : productRealm.percantageCarboInMeal,
       userSetInsulinOnCarbo  : productRealm.userSetInsulinOnCarbo,
       insulinOnCarboToML     : productRealm.insulinOnCarboToML,
       isFavorits             : productRealm.isFavorits)
   }
  
  
  
  // ADD Meal
  private func addMealToFireStore(mealRealm:MealRealm) {
    
    let mealNetworkModel = createMealNetworkModel(mealRealm: mealRealm)
    
    addService.addMealToFireStore(meal: mealNetworkModel)
  }
  
  private func createMealNetworkModel(mealRealm: MealRealm) -> MealNetworkModel {
    
    MealNetworkModel(
      id           : mealRealm.id,
      isExpandMeal : mealRealm.isExpandMeal,
      name         : mealRealm.name,
      typeMeal     : mealRealm.typeMeal,
      listProduct  : [])
  }
  
}

// MARK: Work with Realm Base

extension MealInteractor {
  
  
  private func createMealRealm(viewModel: MealViewModel) -> MealRealm {
    let newMeal = MealRealm(
    
    name         : viewModel.name,
    typeMeal     : viewModel.typeMeal,
    isExpandMeal : viewModel.isExpanded)
    return newMeal
  }
  
  // MARK: Get Update Meal
   
   private func getUpdateMeal(mealId: String?) -> MealRealm? {
     
     var updateMeal: MealRealm?
     if let mealId = mealId {
       updateMeal = realmManager.getMealById(mealId: mealId)
     }
     return updateMeal
   }
   
   private func getListOfTypeOfMeal() -> [String] {
     return realmManager.getTypeOFMealList()
   }
}
