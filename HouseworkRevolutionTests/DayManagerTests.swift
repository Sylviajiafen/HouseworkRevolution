//
//  DayManagerTestCase.swift
//  HouseworkRevolutionTests
//
//  Created by Sylvia Jia Fen  on 2019/10/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import XCTest

@testable import HouseworkRevolution

class DayManagerTests: XCTestCase {
    
    var sut: DayManager!
    
    var today: String!

    override func setUp() {
        super.setUp()
        
        sut = DayManager.shared
        
        today = sut.weekday
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
        
        today = nil
    }

    func testExample() {
        
    }
    
    func testWeekdayString() {
        
        let aWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        if aWeek.contains(today) {
            
            XCTAssert(true)
            
        } else {
            
            XCTAssert(false, "DayManager 讀取今日星期錯誤")
        }
    }
    
//    func testWeekdayConvertor() {
//
//        let whatDayIsToday = sut.convertToCH(of: today) ?? Weekdays(rawValue: "")
//
//        if today == "Monday" && whatDayIsToday?.rawValue == "星期一" {
//
//            XCTAssert(true)
//
//        } else if today == "Tuesday" && whatDayIsToday?.rawValue == "星期二" {
//
//            XCTAssert(true)
//            
//        } else if today == "Wednesday" && whatDayIsToday?.rawValue == "星期三" {
//
//            XCTAssert(true)
//
//        } else if today == "Thursday" && whatDayIsToday?.rawValue == "星期四" {
//
//            XCTAssert(true)
//
//        } else if today == "Friday" && whatDayIsToday?.rawValue == "星期五" {
//
//            XCTAssert(true)
//
//        } else if today == "Saturday" && whatDayIsToday?.rawValue == "星期六" {
//
//            XCTAssert(true)
//
//        } else if today == "Sunday" && whatDayIsToday?.rawValue == "星期日" {
//
//            XCTAssert(true)
//
//        } else {
//
//            XCTAssert(false, "轉換中文星期錯誤")
//        }
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
