//
//  Bundle+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation

extension Bundle {
  
    static func valueForString(key: BundleKey) -> String {
        
        guard let string = Bundle.main.infoDictionary?[key.rawValue]
            as? String else { return "" }
        
        return string
    }
}

enum BundleKey: String {
    
    case privacyLink = "PrivacyLinkURL"
    
    case sendNotification = "FCMSendNotificationURL"
    
    case fcmKey = "FirebaseFCMKey"
    
    case mailReceiver = "ProjectEmailReceiver"
}
