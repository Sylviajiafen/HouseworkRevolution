//
//  KeychainManager.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import KeychainAccess

class KeyChainManager {
    
    static let shared = KeyChainManager()
    
    private let service: Keychain
    
    private let serverKey: String = "userInfo"
    
    private init() {
        
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }
    
}
