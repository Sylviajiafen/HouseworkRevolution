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

    override func setUp() {
        super.setUp()
        
        sut = DayManager.shared
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }

    func testExample() {
        
    }
    
    func testWeekdayConvertor() {
        
        let today = sut.weekday
        
        let whatDayIsToday = sut.changeWeekdayIntoCH(weekday: today)
        
        if today == "Tuesday" && whatDayIsToday == "星期二" {
            
            XCTAssert(true)
            
        } else {
            
            XCTAssert(false, "日期轉換錯誤")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
