//
//  HouseworkArrangement.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

enum WeekdayInEng: String {
    
    case Monday
    
    case Tuesday
    
    case Wednesday
    
    case Thursday
    
    case Friday
    
    case Saturday
    
    case Sunday
    
    var inChinese: String {
        
        switch self {
            
        case .Monday:
            
            return "星期一"
            
        case .Tuesday:
            
            return "星期二"
            
        case .Wednesday:
            
            return "星期三"
            
        case .Thursday:
            
            return "星期四"
            
        case .Friday:
            
            return "星期五"
            
        case .Saturday:
            
            return "星期六"
            
        case .Sunday:
            
            return "星期日"
        }
    }
}

enum DefaultHouseworks: String {
    
    case sweep = "掃地"
    
    case mop = "拖地"
    
    case vacuum = "吸塵"
    
    case garbage = "倒垃圾"
    
    case laundry = "洗衣服"
    
    case cook = "煮飯"
    
    case grocery = "買菜"
    
    case toilet = "掃廁所"
    
}

struct UserDefaultString {
    
    static let key: String = "userKey"
    
    static let value: String = "isLoggedIn"
}
