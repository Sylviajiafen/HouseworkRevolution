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
    
    private let serverKeyFirstHalf = "AAAA__pbBY8:APA91bGeUq7XzHj3hlQvVnAbvqiMMl_pwMJTiGG0o2U_lPBImCO9a7yv7-TFKnA3F_Fs"
    private let serverKetSecondHalf = "fBAM5SJynPQ8xVv3MDaAOfUjMzn5hS-Ve9KmNvjsr-y9_7Uw8CuYGp3W_9rvy3SwNH9NVHkK"
    
    private let sendNotificationUrlString = "https://fcm.googleapis.com/fcm/send"
    
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
        
        let paramString: [String: Any] = ["to": memberToken,
                                          "notification": ["title": title, "body": body],
                                          "data": ["poster": data]]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString,
                                                       options: [.prettyPrinted])
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("key=\(serverKeyFirstHalf)\(serverKetSecondHalf)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                
                if let jsonData = data {
                    
                    if let jsonDataDict = try JSONSerialization
                                                .jsonObject(with: jsonData,
                                                            options: JSONSerialization.ReadingOptions.allowFragments)
                        as? [String: AnyObject] {
                        
                        print("Recieved Data: \(jsonDataDict)")
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
                    
                    print("一個一個核對 member doc id ")
                    
                    memberIds.append(member.documentID)
                }
                
                for id in memberIds {
                    
                    print(id)
                    
                    userQuery.document(id).getDocument { (doc, err) in
                    
                        if let doc = doc {
                        
                            guard let token = doc[UserData.fcmToken.rawValue] as? String else { return }
                        
                            memberTokens.append(token)
                            
                            FirebaseNotificationHelper.memberTokens = memberTokens
                            
                            print("加 member token 中...")
                        
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
                
                print("成功讀取使用者稱呼：\(userName)")
                
            } else if let err = err {
                
                print("get user name failure: \(err)")
            }
        }
    }
    
}

