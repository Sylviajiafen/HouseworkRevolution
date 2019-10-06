//
//  FirebaseNotificationHelper.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/27.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import Firebase

class FirebaseNotificationHelper {
    
    static let shared = FirebaseNotificationHelper()
    
    private init() {}
    
    private let sendNotificationUrlString = Bundle.valueForString(key: .sendNotification)
    
    private let db = Firestore.firestore()
    
    static var memberTokens = [String]()
    
    static var userName: String = ""
    
    func sendNotificationToFamilies(title: String, body: String, data: String = StorageManager.userInfo.userID) {
        
        for token in FirebaseNotificationHelper.memberTokens {
                
            requestNotification(to: token, title: title, body: body, data: data)
        }
    }
    
    private func requestNotification(to memberToken: String, title: String, body: String, data: String) {
        
        guard let url = NSURL(string: sendNotificationUrlString) else { return }
        
        let paramString: [String: Any] = [HTTPBodyKey.to: memberToken,
                                          HTTPBodyKey.notification: [HTTPBodyKey.title: title, HTTPBodyKey.body: body],
                                          HTTPBodyKey.data: [HTTPBodyKey.poster: data]]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString,
                                                       options: [.prettyPrinted])
        
        request.setValue(HTTPHeaderValue.json, forHTTPHeaderField: HTTPHeaderField.contentType)

        request.setValue(HTTPHeaderValue.firebaseServerKey, forHTTPHeaderField: HTTPHeaderField.auth)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                
                if let jsonData = data {
                    
                    if let jsonDataDict = try JSONSerialization
                                                .jsonObject(with: jsonData,
                                                            options: JSONSerialization
                                                                .ReadingOptions.allowFragments)
                        as? [String: AnyObject] {
                        
                        print("Received Data: \(jsonDataDict)")
                    }
                }
                
            } catch let err as NSError {
                
                print(err.debugDescription)
            }
        }
        
        task.resume()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        
        if let token = Messaging.messaging().fcmToken {

            let userRef = db.collection(DataCollection.houseUser.rawValue)
                            .document(StorageManager.userInfo.userID)
            
            userRef.setData([UserData.fcmToken.rawValue: token],
                            merge: true) { (err) in
                
                if let err = err {
                    
                    print("save token to firebase err: \(err)")
                    
                } else {
                    
                    print("successfully save token! ")
                }
            }
            
        } else {
            
            print("fcmToken Not Ready!!!")
        }
    }
    
    func findFamilyMemberTokens(familyID: String = StorageManager.userInfo.familyID) {
        
        var memberIds = [String]()
        
        var memberTokens = [String]()
        
        let familyQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(familyID).collection(CollectionOfFamily.member.rawValue)
        
        let userQuery = db.collection(DataCollection.houseUser.rawValue)
                        
        familyQuery.getDocuments { (querySnapshot, err) in
            
            if let querySnapshot = querySnapshot {
                
                for member in querySnapshot.documents {
                    
                    memberIds.append(member.documentID)
                }
                
                for id in memberIds {
                    
                    userQuery.document(id).getDocument { (doc, err) in
                    
                        if let doc = doc {
                        
                            guard let token = doc[UserData.fcmToken.rawValue] as? String else { return }
                        
                            memberTokens.append(token)
                            
                            FirebaseNotificationHelper.memberTokens = memberTokens
                        
                        } else if let err = err {
                        
                            print("get member doc err: \(err)")
                        }
                    }
                }
        
            } else if let err = err {
                
                print("getting family member err: \(err)")
            }
        }
    }
    
    func getUserName(user: String = StorageManager.userInfo.userID) {
        
        let userIDQuery = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        userIDQuery.getDocument { (document, err) in
            
            if let document = document {
                
                guard let userName = document[UserData.name.rawValue]
                    as? String else { return }
                
                FirebaseNotificationHelper.userName = userName
                
            } else if let err = err {
                
                print("get user name failure: \(err)")
            }
        }
    }
}

struct HTTPHeaderField {

    static let contentType: String = "Content-Type"

    static let auth: String = "Authorization"
}

struct HTTPHeaderValue {

    private static let serverKey = Bundle.valueForString(key: .fcmKey)
    
    static let json: String = "application/json"
    
    static let firebaseServerKey: String = "key=\(HTTPHeaderValue.serverKey)"
}

struct HTTPBodyKey {
    
    static let to: String = "to"
    
    static let notification: String = "notification"
    
    static let title: String = "title"
    
    static let body: String = "body"
    
    static let data: String = "data"
    
    static let poster: String = "poster"
}
