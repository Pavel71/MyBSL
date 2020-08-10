//
//  SugarMetricWorkerTests.swift
//  BSLTests
//
//  Created by Павел Мишагин on 29.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import XCTest
@testable import BSL

// Тесты писать просто ништяк! Как же мне этого не хватало! Без них просто какая то жесть!


class SugarMetricWorkerTests: XCTestCase {
  
  var sut                : SugarMetricConverter!
  var userDefaultsWorker : UserDefaultsWorker!

  override func setUp() {
    super.setUp()
    
    sut                = SugarMetricConverter()
    userDefaultsWorker = ServiceLocator.shared.getService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
    
  }
  
  
  // MARK: Set
  
  func testUserDerfaultsNotNill() {

    XCTAssertNotNil(sut.userDefaultsWorker)
  }
  
  
  // MARK: Converting
  

  
  func testConvertSugar_ThengetMmol_Metric() {
    
    userDefaultsWorker.setSugarMetric(sugarMetric: .mgdl, key: UserDefaultsKey.sugarMetric)
    let mgdlMetricSugar = 192.0
    let mmolMetricSugar = sut.convertMgdltoMmol(mgdlSugar: mgdlMetricSugar)
    XCTAssertEqual((192.0 / 18).roundToDecimal(2), mmolMetricSugar)
    
  }
  
  func testConvertMgdlSugarStringToMmolSugarString() {
    let mgdlMetricSugarString = "180.0"
    let mmolSugarString       = sut.convertMgdlSugarStringToMmolSugarString(mgdlSugarString: mgdlMetricSugarString)
    XCTAssertEqual("10.0", mmolSugarString)
  }
  
  func testConvertMmolSugarStringToMgdlSugarString() {

    let mmolMetricSugarString = "7.0"
    let mgdlSugarString       = sut.convertMmolSugarStringToMgdlSugarString(mmolSugarString: mmolMetricSugarString)
    XCTAssertEqual("126.0", mgdlSugarString)
  }

}
