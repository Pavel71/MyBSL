////
////  DayRealmManager.swift
////  InsulinProjectBSL
////
////  Created by Павел Мишагин on 26.11.2019.
////  Copyright © 2019 PavelM. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//
//// Пока что эта базза данных будет состоять просто из дней!
//
//class DayRealmManager {
//
//
////  var currentDayId: String!
//  private var currentDay: DayRealm!
//
//
//  let provider: RealmProvider
//
//  var realm : Realm {provider.realm}
//
//  init(provider: RealmProvider = RealmProvider.day) {
//    self.provider = provider
//
//  }
//
//}
//
//// MARK: Work With Day
//
//extension DayRealmManager {
//
//
//
//  // Пока просто создам пустой день
//
//  func addBlankDay() {
//
//    print("Add Blank Day")
//
//     let today = Date()
//    currentDay = DayRealm(date: today)
//       // Мне нужно теперь записать день в Realm! Чтобы потом я мог с ним работать!
//    writeDayInDB(dayRealm: currentDay)
//
//  }
//
//  func getTestsObjects() {
//
//
//    // Просто для тестирования
//
//    let yestarday = Date().dayBefore()
//
//    testDaysMethod(yestarday: yestarday)
//
//
////    currentDay = DayRealm(date: today)
////    // Мне нужно теперь записать день в Realm! Чтобы потом я мог с ним работать!
////    writeDayInDB(dayRealm: currentDay)
//
//  }
//
//  // MARK: Test Methods
//
//  // Добавлю вчерашний день
//  private func testDaysMethod(yestarday: Date) {
//
//    currentDay = DayRealm(date: yestarday)
//    writeDayInDB(dayRealm: currentDay)
//
//    let testCompObj = getDummyCompansationObj()
//    addCompansationObjectToRealm(compObj: testCompObj)
//
//
////    for _ in 0...8 {
////      let dayBefore = DayRealm(date: dateBefore)
////      writeDayInDB(dayRealm: dayBefore)
////
////      dateBefore = dateBefore.dayBefore()
////    }
//
//
//  }
//
//  private func getDummyCompansationObj() -> CompansationObjectRelam {
//
//            let dinner = CompansationObjectRelam(
//              typeObject: .mealObject,
//              sugarBefore: 5.8,
//              insulinOnTotalCarbo: 2.0,
//              insulinInCorrectionSugar: 0,
//              totalCarbo: 20,
//              placeInjections: "some")
//        let product1 = ProductRealm(
//          name          : "Молоко",
//          category      : "Молочные продукты",
//          carboIn100Grm : 5,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//          isFavorits    : false,
//          actualInsulin : 0.5
//        )
//        let product2 = ProductRealm(
//          name          : "Яблоко",
//          category      : "Фрукты",
//          carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//          isFavorits    : false,
//          actualInsulin : 1
//        )
//
//        let product3 = ProductRealm(
//          name          : "Мандарин",
//          category      : "Фрукты",
//          carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
//          isFavorits    : false,
//          actualInsulin : 1
//        )
//
//        dinner.listProduct.append(objectsIn: [product1,product2,product3])
//
//        return dinner
//  }
//
//  // MARK: Write Day in DB
//  private func writeDayInDB(dayRealm: DayRealm) {
//    do {
//           self.realm.beginWrite()
//           self.realm.add(dayRealm)
//
//           try self.realm.commitWrite()
////           print(self.realm.configuration.fileURL?.absoluteURL as Any,"Day DB")
//
//         } catch {
//           print(error.localizedDescription)
//         }
//  }
//
//
//
//
//  // MARK: Fetch All Days
//  private func fetchAllDays() -> Results<DayRealm> {
//
//    return realm.objects(DayRealm.self)
//  }
//
//
//  // MARK: Get Date Days in this Month
//
//  func getDaysInThisMonth() -> [Date] {
//
//    let days = fetchAllDays()
//    let todayMoth = Date().month()
//
//    let dates: [Date] = days.map{$0.date}.filter{$0.month() == todayMoth }
//    return dates
//  }
//
//  func getLastSevenDaysDate() -> [Date] {
//
//    let days = fetchAllDays()
//    print(days.count,"Days Count")
//    let sevenDate: [Date] = days.suffix(7).map{$0.date}
//
//    return sevenDate
//  }
//
//  // MARK: Get Day by Date
//
//  func setCurrentDayByDate(date: Date) {
//
//    let days = fetchAllDays()
//
//    guard let realmDay = days.first(where: {$0.date.compareDate(with: date)}) else {return}
//
//    currentDay = realmDay
//
//  }
//
//  // MARK: Check Days on last in DB
//
//  func isNowLastDayInDB() -> Bool {
//    let days = fetchAllDays()
//
//    guard let lastDay = days.last else {return false}
//    
//    let dateNow = Date()
//
//    return lastDay.date.onlyDate()! == dateNow.onlyDate()!
//
//  }
//
//  // MARK: Day By ID
//  private func getDayById(dayId: String) -> DayRealm? {
//
//    let days = fetchAllDays()
//
//    let dayByID = days.first { (day) -> Bool in
//      day.id == dayId
//    }
//    return dayByID
//
//  }
//  // MARK: Get CurrentDay
//
//  func getCurrentDay() -> DayRealm {
//
//    return currentDay
//  }
//
//  func getYestarday() -> DayRealm? {
//
//    let days = fetchAllDays()
//
//    let yestarday = days.first(where: {$0.date.onlyDate() == currentDay.date.onlyDate()?.dayBefore()})
//    return yestarday
//  }
//
//  // MARK: Get CompansationObj by ID
//
//  func getCompansationObjById(compObjId: String) -> CompansationObjectRelam? {
//
//    return currentDay.listCompObj.first(where: {$0.id == compObjId})
//  }
//
//}
//
//
//
//
//
//// MARK: Update Compansation Obj
//
//extension DayRealmManager {
//
//
//  func updateLastCompansationObj(compObj: CompansationObjectRelam)  {
//
//    updateCompObj(compObj: compObj)
//    updateSugarObj(compObj: compObj)
//
//    // Все таки логика расчитанна на то что мы обновляем после записи
//    // если нет предыдущего compObj то и обновлять нам нечего
//    guard let prevCompObjForChanging = haveWeCompObjForChangingUpdating() else {return}
//    writeChangingToPrevCompObj(prevCompObj: prevCompObjForChanging,
//                               sugarAfter: compObj.sugarBefore)
//  }
//
//  private func updateSugarObj(compObj:CompansationObjectRelam) {
//
//    guard let  sugarObj = currentDay.listSugar.first(where: {$0.compansationObjectId == compObj.updateThisID}) else {return}
//
//    let deleteIndex = currentDay.listSugar.index(of: sugarObj)!
//
//    let newsugarRealm = prepareSugarRealm(compObj: compObj)
//
//    do {
//      self.realm.beginWrite()
//
//      // Оставлю время чтобы оно не менялось!
//      newsugarRealm.time =  sugarObj.time
//
//      currentDay.listSugar.remove(at: deleteIndex)
//      currentDay.listSugar.append(newsugarRealm)
//
//     // вот эта запись должна обновить объект!
//     self.realm.add(currentDay, update: .modified)
//
//     try self.realm.commitWrite()
//
//
//    } catch {
//      print(error.localizedDescription)
//    }
//
//  }
//
//
//  private func updateCompObj(compObj: CompansationObjectRelam) {
//
//    guard let updateCompObj = getCompansationObjById(compObjId: compObj.updateThisID) else {return}
//    let deleteIndex   = currentDay.listCompObj.index(of: updateCompObj)!
//
//    do {
//      self.realm.beginWrite()
//
//
//     compObj.timeCreate = updateCompObj.timeCreate
//
//     currentDay.listCompObj.remove(at: deleteIndex)
//     currentDay.listCompObj.append(compObj)
//     // вот эта запись должна обновить объект!
//     self.realm.add(currentDay, update: .modified)
//
//     try self.realm.commitWrite()
//
//
//    } catch {
//      print(error.localizedDescription)
//    }
//  }
//
//}
//
//// MARK: Add Sugar and Compansation Obj To Realm
//extension DayRealmManager {
//
//
//  func addCompansationObjectToRealm(compObj: CompansationObjectRelam) {
//
//
//    let sugarRealm = prepareSugarRealm(compObj: compObj)
//
//    addSugarData(sugarRealm: sugarRealm)
//    addCompansationObject(currentCompObj: compObj)
//  }
//
//
//  private func prepareSugarRealm(compObj: CompansationObjectRelam) -> SugarRealm {
//
//
//    let sugar = compObj.sugarBefore
//
//
//    var dataCase: ChartDataCase
//
//    switch compObj.correctionPositionObject {
//    case .correctDown:
//      dataCase = .correctInsulinData
//    case .correctUp:
//      dataCase = .correctCarboData
//
//    default:
//      dataCase = .mealData
//    }
//
//    return SugarRealm(
//      time                 : Date(),
//      sugar                : sugar.roundToDecimal(2),
//      dataCase             : dataCase ,
//      compansationObjectId : compObj.id)
//  }
//
//   // MARK: Add Sugar Data
//    func addSugarData(sugarRealm: SugarRealm) {
//
//      // мне нужна проверка есть ли объект с таким же id! Если да то просто переписать его!
//      // если есть такой объект то удалить его и записать новый
//
//       do {
//         self.realm.beginWrite()
//
//         currentDay.listSugar.append(sugarRealm)
//        self.realm.add(currentDay, update: .modified)
//
//         try self.realm.commitWrite()
//
//
//       } catch {
//         print(error.localizedDescription)
//       }
//
//    }
//
//    // MARK: Add CompansationObj
//
//    private func addCompansationObject(currentCompObj: CompansationObjectRelam) {
//
//
//
//
//      // если предыдущиего объекта нет то и менять нечего
//      guard let prevCompObjForChanging = haveWeСompObjForChangingAdding() else { writeCompObjToDB(compObj: currentCompObj)
//        return
//
//      }
//      // Есть предыдущий объект подрпавим его и Добавим новый!
//      writeChangingToPrevCompObj(prevCompObj: prevCompObjForChanging, sugarAfter: currentCompObj.sugarBefore)
//      writeCompObjToDB(compObj: currentCompObj)
//
//
//    }
//  // MARK: Write Compansation Obj To DB
//  private func writeCompObjToDB(compObj: CompansationObjectRelam) {
//
//    do {
//      self.realm.beginWrite()
//
//     currentDay.listCompObj.append(compObj)
//
//     // вот эта запись должна обновить объект!
//     self.realm.add(currentDay, update: .modified)
//
//     try self.realm.commitWrite()
//
//
//    } catch {
//      print(error.localizedDescription)
//    }
//  }
//  // MARK: Write changing in prev Compansation Obj
//
//  private func writeChangingToPrevCompObj(
//    prevCompObj: CompansationObjectRelam,sugarAfter: Double) {
//
//
//    do {
//      self.realm.beginWrite()
//      // хз будет это работать или нет
//
//      changeCompansationObjectStateSetSugarAfter(
//        sugarAfter      : sugarAfter,
//        compansationObj : prevCompObj)
//
//      // вот эта запись должна обновить объект!
//      self.realm.add(currentDay, update: .modified)
//
//      try self.realm.commitWrite()
//
//
//    } catch {
//      print(error.localizedDescription)
//
//    }
//  }
//
//
//  // MARK: Have We CompObjFor Changing?
//  private func haveWeСompObjForChangingAdding() -> CompansationObjectRelam? {
//
//    // он возвращает nil так как для первого дня нет предыдущиего
//
//    if let yesterday = getYestarday() { // Есть вчерашний день
//
//      return currentDay.listCompObj.count != 0 ? currentDay.listCompObj.last : yesterday.listCompObj.last
//
//    } else { // Вчера нет
//
//      return currentDay.listCompObj.count != 0 ? currentDay.listCompObj.last : nil
//    }
//
//  }
//
//  private func haveWeCompObjForChangingUpdating() -> CompansationObjectRelam? {
//
//    if let yesterday = getYestarday() { // Есть вчерашний день
//
//
//         return currentDay.listCompObj.count > 1 ? currentDay.listCompObj[currentDay.listCompObj.count - 2] : yesterday.listCompObj.last
//
//       } else { // Вчера нет
//
//         return currentDay.listCompObj.count > 1 ? currentDay.listCompObj[currentDay.listCompObj.count - 2] : nil
//       }
//  }
//
//
//  private func haveWeCompObjForChangingDeleting() -> CompansationObjectRelam? {
//
//    if let yesterday = getYestarday() { // Есть вчерашний день
//
//        return currentDay.listCompObj.count != 0 ? currentDay.listCompObj.last : yesterday.listCompObj.last
//
//      } else { // Вчера нет
//
//        return currentDay.listCompObj.count != 0 ? currentDay.listCompObj.last : nil
//      }
//  }
//
//
//
//  private func changeCompansationObjectStateSetSugarAfter(
//    sugarAfter: Double,
//    compansationObj: CompansationObjectRelam) {
//
//
//      compansationObj.sugarAfter = sugarAfter
//
//      let sugarCompansation = ShugarCorrectorWorker.shared.getWayCorrectPosition(sugar: Float(sugarAfter))
//
//      switch sugarCompansation {
//      case .correctDown:
//        compansationObj.compansationFaseEnum = .bad
//      case .correctUp:
//        compansationObj.compansationFaseEnum = .bad
//      case .dontCorrect:
//        compansationObj.compansationFaseEnum = .good
//      case .progress:
//        compansationObj.compansationFaseEnum = .progress
//      default:break
//      }
//
//      // Изменения внесутся в реалм!
//
//    }
//
//}
//
//// MARK: DELETE Sugar And Compansation Sugar From Realm
//
//extension DayRealmManager {
//
//  func deleteCompasationObjByID(compansationObjId: String) {
//
//
//   writeDeletingCopmObjInDb(compansationObjId: compansationObjId)
//
//
//    guard let prevCompObjForChanging = haveWeCompObjForChangingDeleting() else {return}
//       // Есть предыдущий объект подрпавим его и удалим последний
//    writeChangingToPrevCompObj(prevCompObj: prevCompObjForChanging, sugarAfter: -1)
//
//  }
//
//
//  private func writeDeletingCopmObjInDb(compansationObjId: String) {
//    do {
//         self.realm.beginWrite()
//
//         // Также нужно изменить последний обед его стайт на прогресс
//
//         let sugarWithId = currentDay.listSugar.filter{$0.compansationObjectId != nil}
//
//         guard let sugarToDelete = sugarWithId.first(where: {$0.compansationObjectId == compansationObjId}) else {return}
//         let indexSugar =  currentDay.listSugar.index(of: sugarToDelete)!
//         currentDay.listSugar.remove(at: indexSugar)
//
//         //  в случае с обедами я могу сделать так
//         currentDay.listCompObj.removeLast()
//
//         // Если есть предыдущий то обнови у него стейт
//         if let nowLastCompObj = currentDay.listCompObj.last {
//           nowLastCompObj.compansationFaseEnum = .progress
//         }
//
//
//         // Перезаписываю день!
//         self.realm.add(self.currentDay)
//         //        self.currentDayId = dayBlank.id
//         try self.realm.commitWrite()
//
//
//       } catch {
//         print(error.localizedDescription)
//       }
//  }
//
//}
//
//
//// MARK: Learning Compansation Obj
//
//extension DayRealmManager {
//
//  func isReadyToLearnInMl() -> Bool {
//
//
//    guard let prevCompObjToPrepare = haveWeCompObjForChangingUpdating() else {return false}
//
//    let updateCompObj = MLPreparingDataWorker.prepareCompObj(compObj: prevCompObjToPrepare)
//
//    // теперь проблема как сохранить данные поэтому объекту в списке дня!
//
//    writePreparedCompObjToDB(prepareCompObj: updateCompObj)
//
//    return true
//  }
//
//
//
//  private func writePreparedCompObjToDB(prepareCompObj: CompansationObjectRelam) {
//
//    // Итак у нас есть объект - мы должны определить из какого он дня! и перезаписать его!
//    guard let dayRealm = findDayWhereisPrepareCompObj(prepareCompObj: prepareCompObj) else { return print("Не нашли такой день где этот объект")}
//
////    let deleteIndex = dayRealm.listDinners.index(of: dayRealm)
//
//    do {
//        self.realm.beginWrite()
//
//
//
//        //        self.currentDayId = dayBlank.id
//        try self.realm.commitWrite()
//      } catch {
//        print(error.localizedDescription)
//      }
//  }
//
//  private func findDayWhereisPrepareCompObj(prepareCompObj: CompansationObjectRelam) -> DayRealm? {
//    return currentDay.listCompObj.contains(prepareCompObj) ? currentDay : getYestarday()
//  }
//
//}
//
//// MARK: Dummy Data
//
//extension DayRealmManager {
//
//  // Пока задача будет такой! нужно вернуть 1 день и псмотреть шо из этого получится! Мазафака!
//
//  func getDummyRealmData() -> DayRealm {
//
//    let meal1Id = "111"
//    let meal2Id = "222"
//    let meal3Id = "333"
//    let insulinCOmpansationObjectID = "444"
//    let carboCompansationObjectID = "555"
//
//    let testDay = DayRealm(date: Date())
//
////    let dinners1 = getDummyDInner()
////    dinners1.id  = meal1Id
////    let dinners2 = getDummyDInner2()
////    dinners2.id  = meal2Id
//
//    // Insulin Compansation
//
////    let insulinCopmansationObject = CompansationObjectRelam(
////      typeObject: <#T##TypeCompansationObject#>,
////      sugarBefore: <#T##Double#>,
////      insulinOnTotalCarbo: <#T##Double#>,
////      insulinInCorrectionSugar: <#T##Double#>,
////      totalInsulin: <#T##Double#>)
////
////
////      CompansationObjectRelam(
////      typeObject: .correctSugarByInsulin,
////      sugarBefore: 12.5,
////      totalCarbo: 0,
////      totalInsulin: 1)
////
////    insulinCopmansationObject.id = insulinCOmpansationObjectID
////
////    // Carbo Compansation
////
////    let carboCompansationObject = CompansationObjectRelam(
////      typeObject: .correctSugarByCarbo,
////      sugarBefore: 2.5,
////      totalCarbo: 5.0,
////      totalInsulin: 0)
////    carboCompansationObject.id  = carboCompansationObjectID
//    // Тут я также могу добавить еще и продукт который был употребленн!
//
////
//
//
////    testDay.listDinners.append(objectsIn: [dinners1,carboCompansationObject,insulinCopmansationObject,dinners2,dinner3])
//
//    let sugars = getSugars()
//
//    testDay.listSugar.append(objectsIn: sugars)
//
//    return testDay
//  }
//
//  // Sugars
//
//  private func getSugars() -> [SugarRealm] {
//
//
//
//    let sugarMeal = SugarRealm(
//      time       : Date(timeIntervalSince1970: 1574838000),
//      sugar      : 6.0,
//      dataCase   : .mealData,
//      compansationObjectId   : "111"
//    )
//
//    let carboSugar = SugarRealm(
//      time       : Date(timeIntervalSince1970: 1574841600),
//      sugar      : 2.5,
//      dataCase   : .correctCarboData,
//      compansationObjectId  : "555"
//    )
//
//    let simpleSugar = SugarRealm(
//      time       : Date(timeIntervalSince1970: 1574841600),
//      sugar      : 7.5,
//      dataCase   : .sugarData,
//      compansationObjectId  : nil
//    )
//
//
//
//    let correctInsulinSugar = SugarRealm(
//      time       : Date(timeIntervalSince1970: 1574845200),
//      sugar      : 12.5,
//      dataCase   : .correctInsulinData,
//      compansationObjectId     : "444"
//    )
//
//    let sugarMeal2 = SugarRealm(
//      time       : Date(timeIntervalSince1970: 1574849000),
//      sugar      : 6.0,
//      dataCase   : .mealData,
//      compansationObjectId     : "222"
//    )
//
//    let sugarMeal3 = SugarRealm(
//      time       : Date(timeIntervalSince1970: 1574852000),
//      sugar      : 8.0,
//      dataCase   : .mealData,
//      compansationObjectId     : "333"
//    )
//
//    return [sugarMeal,carboSugar,simpleSugar,correctInsulinSugar,sugarMeal2,sugarMeal3]
//
//  }
//
//
//  // Dinner
//
////  private func getDummyDInner() -> CompansationObjectRelam {
////
////
////
////    //    let dinner = DinnersRealm(
////    //      compansationFase    : CompansationPosition.progress.rawValue,
////    //         timeEating       : Date(timeIntervalSince1970: 1574838000),
////    //         sugarBefore      : 6.0,
////    //         totalCarbo       : 5,
////    //         totalInsulin     : 0.5,
////    //         totalPortion     : 100
////    //
////    //
////    //       )
////    let product1 = ProductRealm(
////      name          : "Молоко",
////      category      : "Молочные продукты",
////      carboIn100Grm : 5,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
////      isFavorits    : false,
////      actualInsulin : 0.5
////    )
////    let product2 = ProductRealm(
////      name          : "Яблоко",
////      category      : "Фрукты",
////      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
////      isFavorits    : false,
////      actualInsulin : 1
////    )
////
////    let product3 = ProductRealm(
////      name          : "Мандарин",
////      category      : "Фрукты",
////      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
////      isFavorits    : false,
////      actualInsulin : 1
////    )
////
////    compansationObjectLikeMeal.listProduct.append(objectsIn: [product1,product2,product3])
////
////    return compansationObjectLikeMeal
////  }
////
////  private func getDummyDInner2() -> CompansationObjectRelam {
////
////    let compansationObjectLikeMeal = CompansationObjectRelam(
////      typeObject   : .mealObject,
////      sugarBefore  : 8.0,
////      totalCarbo   : 13.0,
////      totalInsulin : 1.5)
////
////    let product1 = ProductRealm(
////      name          : "Печенье",
////      category      : "Сладости",
////      carboIn100Grm : 25,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
////      isFavorits    : false,
////      actualInsulin : 1
////    )
////    let product2 = ProductRealm(
////      name          : "Суп с картошкой",
////      category      : "Суп",
////      carboIn100Grm : 3,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
////      isFavorits    : false,
////      actualInsulin : 0.3
////    )
////
////    let product3 = ProductRealm(
////      name          : "Мандарин",
////      category      : "Фрукты",
////      carboIn100Grm : 11,                     // Здесь может быть ошибка нужно внимательно проверить чтобы шла в модель именно карбо ин портино а не на 100гр
////      isFavorits    : false,
////      actualInsulin : 1
////    )
////
////    compansationObjectLikeMeal.listProduct.append(objectsIn: [product1,product2,product3])
////
////    return compansationObjectLikeMeal
////  }
//
//}
