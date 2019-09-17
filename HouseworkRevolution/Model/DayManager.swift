//
//  DayManager.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation

class DayManager {
    
    static let shared = DayManager()
    
    static let weekdayInCH: [Weekdays] = [.Monday,
                                          .Tuesday,
                                          .Wednesday,
                                          .Thursday,
                                          .Friday,
                                          .Saturday,
                                          .Sunday]
    
    static let weekdayInEng: [WeekdayInEng] = [.Monday,
                                               .Tuesday,
                                               .Wednesday,
                                               .Thursday,
                                               .Friday,
                                               .Saturday,
                                               .Sunday]
    
    private let today = Date()
    private let dateFormatter = DateFormatter()
    private let weekdayFormatter = DateFormatter()
    
    let stringOfToday: String
    
    let weekday: String
    
    private init() {
        
        dateFormatter.dateFormat = "YYYYMMdd"
        weekdayFormatter.dateFormat = "EEEE"
        
        stringOfToday = dateFormatter.string(from: today)
        weekday = weekdayFormatter.string(from: today)
    }
    
}
