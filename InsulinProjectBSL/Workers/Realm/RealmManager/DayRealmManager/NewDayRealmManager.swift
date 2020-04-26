//
//  NewDayRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 03.04.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation

import RealmSwift



class NewDayRealmManager {
  
  
//  static var shared: NewDayRealmManager = {NewDayRealmManager()}()
  
//  let locator = ServiceLocator.shared
  
  
  private var compObjrealm      : CompObjRealmManager!
  private var sugarRealmManager : SugarRealmManager!
  
  
  
  private var currentDay: DayRealm!
  
  let provider: RealmProvider
  
  var realm : Realm {provider.realm}
  
  init(provider: RealmProvider = RealmProvider.day) {
    self.provider = provider
    
    let locator = ServiceLocator.shared
    compObjrealm      = locator.getService()
    sugarRealmManager = locator.getService()
    
  }
  
}


// MARK: Fetch
extension NewDayRealmManager {
  
  func fetchAllDays() -> Results<DayRealm> {
    
    return realm.objects(DayRealm.self)
    
  }
  
  func fetchDayById(dayId: String) -> DayRealm? {
    
    let day = fetchAllDays().first(where: {$0.id == dayId})
    return day
  }
  
  func fetchDayByDate(dayDate: Date) -> DayRealm? {
    let allDays = fetchAllDays()
    return allDays.first(where: {$0.date.compareDate(with: dayDate)})
  }
  
  func fetchLastSevenDaysDate() -> [Date] {
    
     return fetchAllDays().suffix(7).map{$0.date}
     
   }

  
}

// MARK: Get Day

extension NewDayRealmManager {
  
  // MARK: Get CurrentDay
  func getCurrentDay() -> DayRealm {
    
    return self.currentDay
    
  }
  
  // может просто стоит переписать этот метод и добавлять последний
  
  func setDayByDate(date: Date) {
    guard let day  = fetchDayByDate(dayDate: date) else {return}
    self.currentDay = day
  }
  
  func isNowLastDayInDB() -> Bool {
    
      let days = fetchAllDays()
      guard let lastDay = days.last else {return false}
      let dateNow = Date()
      return lastDay.date.compareDate(with: dateNow)
//      return lastDay.date.onlyDate()! == dateNow.onlyDate()!
  
    }
  
}



// MARK: Add or Update Day

extension NewDayRealmManager {
  
  func addBlankDay() {
    
    self.currentDay = DayRealm(date: Date())
    addOrUpdateNewDay(dayRealm: currentDay)
    
  }
  
  func addOrUpdateNewDay(dayRealm: DayRealm) {
    
    do {
      
      self.realm.beginWrite()
      self.realm.add(dayRealm, update: .all)
      
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"Day in DB")
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}

// MARK: Work With CompObjId

extension NewDayRealmManager {

  // ADD and Update
  func addNewCompObjId(compObjId: String) {

      
      do {
        self.realm.beginWrite()
        
        currentDay.listCompObjID.append(compObjId)
        self.realm.add(currentDay, update: .all)
        try self.realm.commitWrite()
        
        
      } catch {
        print(error.localizedDescription)
      }

      
    

  }
  
  //Delete
  
  
  
  func deleteCompObjById(compObjId: String) {
    
    guard let deleteIndex = currentDay.listCompObjID.index(of: compObjId) else {return}
    
    do {
      self.realm.beginWrite()
      
      currentDay.listCompObjID.remove(at: deleteIndex)
      self.realm.add(currentDay, update: .all)
      try self.realm.commitWrite()
      
    } catch {
      print(error.localizedDescription)
    }
    
    
    compObjrealm.deleteCompObgById(compObjId: compObjId)
  }

}

// MARK: Work With Sugar
extension NewDayRealmManager {
  
  // ADD
  func addNewSugarId(sugarId: String) {

      do {
        self.realm.beginWrite()
        
        currentDay.listSugarID.append(sugarId)
        self.realm.add(currentDay, update: .all)
        
        try self.realm.commitWrite()

      } catch {
        print(error.localizedDescription)
      }
      
  }
  
  //Delete
  
  func deleteSugarByCompObjId(sugarCompObjId: String) {
    
    guard
      let sugarRealm = sugarRealmManager.fetchSugarByCompansationId(sugarCompObjId: sugarCompObjId)
      else {return}
    
//    sugarRealmManager.fetchSugarByCompansationId(sugarCompObjId: sugarCompObjId) else {return}
    
    
    guard let deleteIndex = currentDay.listSugarID.index(of:sugarRealm.id) else {return}
    
    do {
      self.realm.beginWrite()
      
      currentDay.listSugarID.remove(at: deleteIndex)
      self.realm.add(currentDay, update: .all)
      try self.realm.commitWrite()
      
    } catch {
      print(error.localizedDescription)
    }
    
    sugarRealmManager.deleteSugarByCompObjId(sugarCompObjId: sugarCompObjId)
  }
  
 
}

// MARK: Testing


extension NewDayRealmManager {
  
  
  private func testDaysMethod(yestarday: Date) {

      currentDay = DayRealm(date: yestarday)
      addOrUpdateNewDay(dayRealm: currentDay)
      
//      addNewSugarId(sugarId: <#T##String#>)
      
      let testCompObj = getDummyCompansationObj()
//      addCompansationObjectToRealm(compObj: testCompObj)

      
  //    for _ in 0...8 {
  //      let dayBefore = DayRealm(date: dateBefore)
  //      writeDayInDB(dayRealm: dayBefore)
  //
  //      dateBefore = dateBefore.dayBefore()
  //    }
      
      
    }
    
    private func getDummyCompansationObj() -> CompansationObjectRelam {
      
              let dinner = CompansationObjectRelam(
                typeObject: .mealObject,
                sugarBefore: 5.8,
                insulinOnTotalCarbo: 2.0,
                insulinInCorrectionSugar: 0,
                totalCarbo: 20,
                placeInjections: "some")
          let product1 = ProductRealm(
            name          : "Молоко",
            category      : "Молочные продукты",
            carboIn100Grm : 5,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
            isFavorits    : false, 
            actualInsulin : 0.5
          )
          let product2 = ProductRealm(
            name          : "Яблоко",
            category      : "Фрукты",
            carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
            isFavorits    : false,
            actualInsulin : 1
          )
      
          let product3 = ProductRealm(
            name          : "Мандарин",
            category      : "Фрукты",
            carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
            isFavorits    : false,
            actualInsulin : 1
          )
      
          dinner.listProduct.append(objectsIn: [product1,product2,product3])
      
          return dinner
    }
  
}

