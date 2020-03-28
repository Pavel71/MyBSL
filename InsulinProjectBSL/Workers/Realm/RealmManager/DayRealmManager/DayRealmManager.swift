//
//  DayRealmManager.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation
import RealmSwift


// Пока что эта базза данных будет состоять просто из дней!

class DayRealmManager {
  
  
//  var currentDayId: String!
  private var currentDay: DayRealm!
  
  
  let provider: RealmProvider
  
  var realm : Realm {provider.realm}
  
  init(provider: RealmProvider = RealmProvider.day) {
    self.provider = provider
    
  }
  
}

// MARK: Work With Day

extension DayRealmManager {
  

  
  // Пока просто создам пустой день
  
  func getBlankDayObject() {
    
    currentDay = DayRealm(date: Date())
    // Мне нужно теперь записать день в Realm! Чтобы потом я мог с ним работать!
    
    DispatchQueue.main.async {
      do {
        self.realm.beginWrite()
        self.realm.add(self.currentDay)
//        self.currentDayId = dayBlank.id
        try self.realm.commitWrite()
        print(self.realm.configuration.fileURL?.absoluteURL as Any,"Day DB")
        
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
  }
  
 
  
  
  // MARK: Fetch All Days
  private func fetchAllDays() -> Results<DayRealm> {
    
    return realm.objects(DayRealm.self)
  }
  
  
  // MARK: Get Date Days in this Month
  
  func getDaysInThisMonth() -> [Date] {
    
    let days = fetchAllDays()
    let todayMoth = Date().month()
    
    let dates: [Date] = days.map{$0.date}.filter{$0.month() == todayMoth }
    return dates
  }
  
  // MARK: Day By ID
  private func getDayById(dayId: String) -> DayRealm? {
    
    let days = fetchAllDays()
    
    let dayByID = days.first { (day) -> Bool in
      day.id == dayId
    }
    return dayByID
    
  }
  // MARK: Get CurrentDay
  
  func getCurrentDay() -> DayRealm {

    return currentDay
  }
  
  // MARK: Get CompansationObj by ID
  
  func getCompansationObjById(compObjId: String) -> CompansationObjectRelam? {
    
    return currentDay.listDinners.first(where: {$0.id == compObjId})
  }
  
}

// MARK: Update Compansation Obj

extension DayRealmManager {
  
  
  func updateLastCompansationObj(compObj: CompansationObjectRelam)  {
    
    updateCompObj(compObj: compObj)
    updateSugarObj(compObj: compObj)
  }
  
  private func updateSugarObj(compObj:CompansationObjectRelam) {
    
    guard let  sugarObj = currentDay.listSugar.first(where: {$0.compansationObjectId == compObj.updateThisID}) else {return}
    let deleteIndex = currentDay.listSugar.index(of: sugarObj)!
    
    let newsugarRealm = prepareSugarRealm(compObj: compObj)
    
    do {
      self.realm.beginWrite()
      
      // Оставлю время чтобы оно не менялось!
      newsugarRealm.time =  sugarObj.time
      
      currentDay.listSugar.remove(at: deleteIndex)
      currentDay.listSugar.append(newsugarRealm)
      
     // вот эта запись должна обновить объект!
     self.realm.add(currentDay, update: .modified)
     
     try self.realm.commitWrite()
     
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
  
  private func updateCompObj(compObj: CompansationObjectRelam) {
    
    guard let updateCompObj = getCompansationObjById(compObjId: compObj.updateThisID) else {return}
    let deleteIndex   = currentDay.listDinners.index(of: updateCompObj)!
    do {
      self.realm.beginWrite()
      
      
     compObj.timeCreate = updateCompObj.timeCreate
      
     currentDay.listDinners.remove(at: deleteIndex)
     currentDay.listDinners.append(compObj)
     // вот эта запись должна обновить объект!
     self.realm.add(currentDay, update: .modified)
     
     try self.realm.commitWrite()
     
      
    } catch {
      print(error.localizedDescription)
    }
  }
  
}

// MARK: Add Sugar and Compansation Obj To Realm
extension DayRealmManager {
  
  
  func addCompansationObjectToRealm(compObj: CompansationObjectRelam) {
    
    
    let sugarRealm = prepareSugarRealm(compObj: compObj)
    
    addSugarData(sugarRealm: sugarRealm)
    addCompansationObject(currentCompObj: compObj)
  }
  
  
  private func prepareSugarRealm(compObj: CompansationObjectRelam) -> SugarRealm {
    
    
    let sugar = compObj.sugarBefore
    
    
    var dataCase: ChartDataCase
    
    switch compObj.correctionPositionObject {
    case .correctDown:
      dataCase = .correctInsulinData
    case .correctUp:
      dataCase = .correctCarboData
    
    default:
      dataCase = .mealData
    }
    
    return SugarRealm(
      time                 : Date(),
      sugar                : sugar.roundToDecimal(2),
      dataCase             : dataCase ,
      compansationObjectId : compObj.id)
  }
  
   // MARK: Add Sugar Data
    func addSugarData(sugarRealm: SugarRealm) {
      
      // мне нужна проверка есть ли объект с таким же id! Если да то просто переписать его!
      // если есть такой объект то удалить его и записать новый
      
       do {
         self.realm.beginWrite()

         currentDay.listSugar.append(sugarRealm)
        self.realm.add(currentDay, update: .all)
        
         try self.realm.commitWrite()
        
         
       } catch {
         print(error.localizedDescription)
       }
         
    }
    
    
    private func addCompansationObject(currentCompObj: CompansationObjectRelam) {

       do {
         self.realm.beginWrite()
        // хз будет это работать или нет
        
   
        changeCompansationObjectStateSetSugarAfter(sugarAfter: currentCompObj.sugarBefore)
        
        currentDay.listDinners.append(currentCompObj)
        // вот эта запись должна обновить объект!
        self.realm.add(currentDay, update: .modified)
        
        try self.realm.commitWrite()
        
         
       } catch {
         print(error.localizedDescription)
       }
      
    }
    
    
    // Изходя из текущего сахара мы определям как мы компенсировали предыдущий обед хорошо или плохо
    private func changeCompansationObjectStateSetSugarAfter(sugarAfter: Double) {
      
      guard let lastCompansationObj = currentDay.listDinners.last else {return}
      
      lastCompansationObj.sugarAfter = sugarAfter
      
      let sugarCompansation = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: Float(sugarAfter))
      
      switch sugarCompansation {
      case .correctDown:
        lastCompansationObj.compansationFaseEnum = .bad
      case .correctUp:
        lastCompansationObj.compansationFaseEnum = .bad
      case .dontCorrect:
        lastCompansationObj.compansationFaseEnum = .good
      default:break
      }
      
      // Изменения внесутся в реалм!
      
    }
  
}

// MARK: DELETE Sugar And Compansation Sugar From Realm

extension DayRealmManager {
  
  func deleteCompasationObjByID(compansationObjId: String) {
    
    // При удаление нужно убрать последний обед
    // Убрать сахар при этом обеде
    // Изменить State последнего обеда на прогресс!
    
    print("Delete COmpObj",compansationObjId)
    
    do {
      self.realm.beginWrite()
      
      // Также нужно изменить последний обед его стайт на прогресс
      
      let sugarWithId = currentDay.listSugar.filter{$0.compansationObjectId != nil}
      
      guard let sugarToDelete = sugarWithId.first(where: {$0.compansationObjectId == compansationObjId}) else {return}
      let indexSugar =  currentDay.listSugar.index(of: sugarToDelete)!
      currentDay.listSugar.remove(at: indexSugar)
      
      //  в случае с обедами я могу сделать так
      currentDay.listDinners.removeLast()
      
      // Если есть предыдущий то обнови у него стейт
      if let nowLastCompObj = currentDay.listDinners.last {
        nowLastCompObj.compansationFaseEnum = .progress
      }
      
      
      // Перезаписываю день!
      self.realm.add(self.currentDay)
      //        self.currentDayId = dayBlank.id
      try self.realm.commitWrite()
      
      
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
}


// MARK: Dummy Data

extension DayRealmManager {
  
  // Пока задача будет такой! нужно вернуть 1 день и псмотреть шо из этого получится! Мазафака!
  
  func getDummyRealmData() -> DayRealm {
    
    let meal1Id = "111"
    let meal2Id = "222"
    let meal3Id = "333"
    let insulinCOmpansationObjectID = "444"
    let carboCompansationObjectID = "555"
    
    let testDay = DayRealm(date: Date())
    
//    let dinners1 = getDummyDInner()
//    dinners1.id  = meal1Id
//    let dinners2 = getDummyDInner2()
//    dinners2.id  = meal2Id
    
    // Insulin Compansation
    
//    let insulinCopmansationObject = CompansationObjectRelam(
//      typeObject: <#T##TypeCompansationObject#>,
//      sugarBefore: <#T##Double#>,
//      insulinOnTotalCarbo: <#T##Double#>,
//      insulinInCorrectionSugar: <#T##Double#>,
//      totalInsulin: <#T##Double#>)
//
//
//      CompansationObjectRelam(
//      typeObject: .correctSugarByInsulin,
//      sugarBefore: 12.5,
//      totalCarbo: 0,
//      totalInsulin: 1)
//
//    insulinCopmansationObject.id = insulinCOmpansationObjectID
//
//    // Carbo Compansation
//
//    let carboCompansationObject = CompansationObjectRelam(
//      typeObject: .correctSugarByCarbo,
//      sugarBefore: 2.5,
//      totalCarbo: 5.0,
//      totalInsulin: 0)
//    carboCompansationObject.id  = carboCompansationObjectID
    // Тут я также могу добавить еще и продукт который был употребленн!
    
//
    
    
//    testDay.listDinners.append(objectsIn: [dinners1,carboCompansationObject,insulinCopmansationObject,dinners2,dinner3])
    
    let sugars = getSugars()
    
    testDay.listSugar.append(objectsIn: sugars)
    
    return testDay
  }
  
  // Sugars
  
  private func getSugars() -> [SugarRealm] {
    
    
    
    let sugarMeal = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574838000),
      sugar      : 6.0,
      dataCase   : .mealData,
      compansationObjectId   : "111"
    )
    
    let carboSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574841600),
      sugar      : 2.5,
      dataCase   : .correctCarboData,
      compansationObjectId  : "555"
    )
    
    let simpleSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574841600),
      sugar      : 7.5,
      dataCase   : .sugarData,
      compansationObjectId  : nil
    )
    
    
    
    let correctInsulinSugar = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574845200),
      sugar      : 12.5,
      dataCase   : .correctInsulinData,
      compansationObjectId     : "444"
    )
    
    let sugarMeal2 = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574849000),
      sugar      : 6.0,
      dataCase   : .mealData,
      compansationObjectId     : "222"
    )
    
    let sugarMeal3 = SugarRealm(
      time       : Date(timeIntervalSince1970: 1574852000),
      sugar      : 8.0,
      dataCase   : .mealData,
      compansationObjectId     : "333"
    )
    
    return [sugarMeal,carboSugar,simpleSugar,correctInsulinSugar,sugarMeal2,sugarMeal3]
    
  }
  
  
  // Dinner
  
//  private func getDummyDInner() -> CompansationObjectRelam {
//
//
//
//    //    let dinner = DinnersRealm(
//    //      compansationFase    : CompansationPosition.progress.rawValue,
//    //         timeEating       : Date(timeIntervalSince1970: 1574838000),
//    //         sugarBefore      : 6.0,
//    //         totalCarbo       : 5,
//    //         totalInsulin     : 0.5,
//    //         totalPortion     : 100
//    //
//    //
//    //       )
//    let product1 = ProductRealm(
//      name          : "Молоко",
//      category      : "Молочные продукты",
//      carboIn100Grm : 5,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//      isFavorits    : false,
//      actualInsulin : 0.5
//    )
//    let product2 = ProductRealm(
//      name          : "Яблоко",
//      category      : "Фрукты",
//      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//      isFavorits    : false,
//      actualInsulin : 1
//    )
//
//    let product3 = ProductRealm(
//      name          : "Мандарин",
//      category      : "Фрукты",
//      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//      isFavorits    : false,
//      actualInsulin : 1
//    )
//
//    compansationObjectLikeMeal.listProduct.append(objectsIn: [product1,product2,product3])
//
//    return compansationObjectLikeMeal
//  }
//
//  private func getDummyDInner2() -> CompansationObjectRelam {
//
//    let compansationObjectLikeMeal = CompansationObjectRelam(
//      typeObject   : .mealObject,
//      sugarBefore  : 8.0,
//      totalCarbo   : 13.0,
//      totalInsulin : 1.5)
//
//    let product1 = ProductRealm(
//      name          : "Печенье",
//      category      : "Сладости",
//      carboIn100Grm : 25,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//      isFavorits    : false,
//      actualInsulin : 1
//    )
//    let product2 = ProductRealm(
//      name          : "Суп с картошкой",
//      category      : "Суп",
//      carboIn100Grm : 3,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//      isFavorits    : false,
//      actualInsulin : 0.3
//    )
//
//    let product3 = ProductRealm(
//      name          : "Мандарин",
//      category      : "Фрукты",
//      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//      isFavorits    : false,
//      actualInsulin : 1
//    )
//
//    compansationObjectLikeMeal.listProduct.append(objectsIn: [product1,product2,product3])
//
//    return compansationObjectLikeMeal
//  }
  
}
