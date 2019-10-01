//
//  AppDelegate.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase

import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         // first open app
        if UserDefaults.standard.value(forKey: "userKey") == nil {
            
            window?.rootViewController = UIStoryboard.auth.instantiateInitialViewController()!
            
        } else {
            
            window?.rootViewController = UIStoryboard.main.instantiateInitialViewController()!
            
            StorageManager.shared.fetchUserInfo()
        }
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        print("resign active") // 按 home 鍵退出觸發
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print("become active") // 從 background 叫回
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
//        self.saveContext()
    }
    
// MARK: Notification
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var tokenString = ""
        
        for byte in deviceToken {
            
            let hexString = String(format: "%02x", byte)
            
            tokenString += hexString
        }
        
        print("Appdelegate did get token for remote notification: \(tokenString)")
    }
    
    func showAuthRequest(application: UIApplication) {
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in

        })

        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        
//        let dataDict: [String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        guard let poster = userInfo["poster"] as? String else { return }
        
        if poster != StorageManager.userInfo.userID {
            
            completionHandler([.alert, .badge, .sound])
        }
    }
}
    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "HouseworkRevolution")
//
//        container.loadPersistentStores(
//
//            completionHandler: { (storeDescription, error) in
//
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//
//        return container
//
//    }()

    // MARK: - Core Data Saving support

//    func saveContext() {
//
//        let context = persistentContainer.viewContext
//
//        if context.hasChanges {
//
//            do {
//
//                try context.save()
//
//            } catch {
//
//                let nserror = error as NSError
//
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
//    func saveUserKey(_ key: String) {
//
//        let context = persistentContainer.viewContext
//
//        let userInfo = UserInfo(context: context)
//
//        userInfo.key = key
//
//        do {
//
//            try context.save()
//
//        } catch {
//
//            let nserror = error as NSError
//
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
