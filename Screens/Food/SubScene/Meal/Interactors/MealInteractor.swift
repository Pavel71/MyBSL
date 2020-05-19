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
  
  // MARK: Work With Products Requests
  
  private func workWithProductListFromMealRequests(request:Meal.Model.Request.RequestType) {
    
    switch  request {
      // Product List Delete Update Add
      case .deleteProductFromMeal(let mealId, let productName):
        
        
        guard let meal = realmManager.deleteProductFromMeal(productName: productName, mealId: mealId) else {return}
      
        updateMealInFireStore(mealRealm: meal)
      
      case .updateProductPortionFromMeal(let mealId, let productName, let portion):
        
        guard let meal = realmManager.updateProductPortionFromMeal(productName: productName, mealId: mealId, portion: portion) else {return}
       
        updateMealInFireStore(mealRealm: meal)
        
      case .addProductInMeal(let mealId, let product):
        
        guard let updateMeal = realmManager.addproductInMeal(mealId: mealId, product: product) else {return} // realmDBDidChange
        
        addMealToFireStore(mealRealm: updateMeal)
      
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
          
          // pдесь нам нужно получать обноленный mealRealm и записывать его
          guard let meal = realmManager.updateAllMealFields(viewModel: viewModel)  else {return}
          
           updateMealInFireStore(mealRealm: meal)
          
          self.presenter?.presentData(response: .passSuccessAddOrUpdateMeal(isSuccessAdd:true, isUpdateMeal: true))
          
         
          
          
        } else {
          
          let mealRealm = createMealRealm(viewModel: viewModel)
          
          realmManager.addNewMeal(mealRealm: mealRealm) { [weak self] (success) in
            
            if success {
              self?.addMealToFireStore(mealRealm: mealRealm)
            }
            
            self?.presenter?.presentData(response: .passSuccessAddOrUpdateMeal(isSuccessAdd:success, isUpdateMeal: false)) // realmDBDidChange
          }

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

  // MARK: Meals
  
  // Delete
  private func deleteMealFromFireStore(mealId: String) {
    deleteService.deleteMealFromFireStore(mealId: mealId)
  }
  
  // Update
  private func updateMealInFireStore(mealRealm: MealRealm) {
    let mealNetworkModel = convertMealRealmToMealNetworkModel(mealRealm: mealRealm)
    updateService.updateMealInFireStore(mealNetworkModel: mealNetworkModel)
  }

  
  // ADD Meal
  private func addMealToFireStore(mealRealm:MealRealm) {
    
    let mealNetworkModel = convertMealRealmToMealNetworkModel(mealRealm: mealRealm)
    
    addService.addMealToFireStore(meal: mealNetworkModel)
  }
  
  private func convertMealRealmToMealNetworkModel(mealRealm: MealRealm) -> MealNetworkModel {
    
    let listProduct:[ProductNetworkModel] = mealRealm.listProduct.map(convertProductRealmToProductNetworkModel)
    
    return MealNetworkModel(
      id           : mealRealm.id,
      isExpandMeal : mealRealm.isExpandMeal,
      name         : mealRealm.name,
      typeMeal     : mealRealm.typeMeal,
      listProduct  : listProduct)
  }
  
  private func convertProductRealmToProductNetworkModel(productRealm: ProductRealm) -> ProductNetworkModel {

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
