//
//  RNCryptorManager.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import RNCryptor

class RNCryptorManager {
    
    static let shared = RNCryptorManager()
    
    static let encryptionKey: String = "userPWD"
    
    private init() {}
    
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }

    func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {

        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!

        return decryptedString
    }
}
