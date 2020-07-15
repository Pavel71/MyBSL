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

// MARK: Replace Day
extension NewDayRealmManager {
  
  func replaceCurrentDay(replaceDay: DayRealm) {
    
    guard let todayDay = fetchDayByDate(dayDate: Date()) else {return}
   
    do {
         
         self.realm.beginWrite()
      
      
      todayDay.listSugarID.forEach(sugarRealmManager.deleteSugarId(sugarId:))
      todayDay.listCompObjID.forEach(compObjrealm.deleteCompObgById(compObjId:))
      
      self.realm.delete(todayDay)
      // помимио этого нужно удалить все объекты дня
      
      
      
      self.realm.add(replaceDay)
         
         try self.realm.commitWrite()
         print(self.realm.configuration.fileURL?.absoluteURL as Any,"Day in DB")
         
       } catch {
         print(error.localizedDescription)
       }
     self.currentDay = replaceDay
    
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
    return allDays.first(where: {$0.date.compareDateByDay(with: dayDate)})
  }
  
  func fetchLastSevenDaysDate() -> [Date] {
    
     return fetchAllDays().suffix(7).map{$0.date}
     
   }
  
  func fetchSugarIdByCompObjId(compObjId: String) -> String? {

    return sugarRealmManager.fetchSugarByCompansationId(sugarCompObjId: compObjId)?.id
  }

  
}

// MARK: Get Set Day

extension NewDayRealmManager {
  
  // MARK: Get CurrentDay
  func getCurrentDay() -> DayRealm {
    
    return self.currentDay
    
  }
  
  func setCurrentDay(dayRealm: DayRealm) {
    self.currentDay = dayRealm
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
      return lastDay.date.compareDateByDay(with: dateNow)
//      return lastDay.date.onlyDate()! == dateNow.onlyDate()!
  
    }
  
}

// MARK: Delete Clear Days
extension NewDayRealmManager {
  
  func deleteDaysRealm() {
    
    do {
      self.realm.beginWrite()
      self.realm.deleteAll()
      try self.realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func deleteToday()  {
    print("Удаляем сегодня если есть")
    guard let today = fetchDayByDate(dayDate: Date()) else {return}
    do {
      self.realm.beginWrite()
      self.realm.delete(today)
      try self.realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
  func deleteCurrentDay() {
    do {
      self.realm.beginWrite()
      self.realm.delete(currentDay)
      try self.realm.commitWrite()
    } catch {
      print(error.localizedDescription)
    }
  }
}


// MARK: Add or Update Day

extension NewDayRealmManager {
  
//  func addBlankDay() -> DayRealm {
//
//    let newDay = DayRealm(date: Date())
//    self.currentDay = newDay
//
//    setDayToRealm(day: newDay)
//
//    return newDay
//  }
  
  
  
  
  func setDayToRealm(day: DayRealm) {
    
    print("Устанавливаю день в реалм",day.id)
    do {
      self.realm.beginWrite()
      self.realm.add(day, update: .all)
      try self.realm.commitWrite()
      print(self.realm.configuration.fileURL?.absoluteURL as Any,"Days in DB")
      
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func setDaysToRealm(days: [DayRealm]) {
    
    let sortedDays = days.sorted(by: {$0.date < $1.date})
    
    
    do {
         self.realm.beginWrite()
         self.realm.add(sortedDays, update: .all)
         try self.realm.commitWrite()
         print(self.realm.configuration.fileURL?.absoluteURL as Any,"Days in DB")
         
       } catch {
         print(error.localizedDescription)
       }
    
    self.currentDay = sortedDays.last
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
  
  func deleteSugarByCompObjId(sugarId: String){
    
    let removeSugars = sugarRealmManager.getNearestSugarToDelete(sugarId: sugarId)
    
    removeSugars.forEach{deletSugarFromList(sugarId:$0)}
    
    
  }
  
  
  private func deletSugarFromList(sugarId:String) {
    
    guard let deleteIndex = currentDay.listSugarID.index(of:sugarId) else {return}
       
       do {
         self.realm.beginWrite()
         
         currentDay.listSugarID.remove(at: deleteIndex)
         
         try self.realm.commitWrite()
         
       } catch {
         print(error.localizedDescription)
       }
    
    sugarRealmManager.deleteSugarId(sugarId: sugarId)
  }
  
 
}



