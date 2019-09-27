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
    
    func sendNotificationToFamilyMembers(to memberToken: String,
                                         title: String,
                                         body: String) {
        
        guard let url = NSURL(string: sendNotificationUrlString) else { return }
        
        let paramString: [String: Any] = ["to": memberToken,
                                          "notification": ["title": title, "body": body]]
        
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
            
            userRef.setData([UserData.fcmToken.rawValue: token], merge: true)
        }
    }
}

//    func subscribeToFamily(id: String) {
//
//        DispatchQueue.main.async {
//
//            Messaging.messaging().subscribe(toTopic: id) { error in
//
//                if let err = error {
//
//                    print("Error of subscribing family(\(id)): \(err) ")
//                } else {
//
//                    print("Subscribed to family(\(id)) succeeded!")
//                }
//            }
//        }
//    }
//
//    func unSubscribePreviousFamily(id: String) {
//
//        DispatchQueue.main.async {
//
//            Messaging.messaging().unsubscribe(fromTopic: id) { error in
//
//                if let err = error {
//
//                    print("Error of subscribing family(\(id)): \(err) ")
//                } else {
//
//                    print("Subscribed to family(\(id)) succeeded!")
//                }
//            }
//        }
//    }

