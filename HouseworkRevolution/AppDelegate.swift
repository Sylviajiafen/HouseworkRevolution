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
        if UserDefaults.standard.value(forKey: UserDefaultString.key.rawValue) == nil {
            
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
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
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
    }
    
    func showAuthRequest(application: UIApplication) {
        
          // For iOS 10 display notification (sent via APNS)
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
    }
    
<<<<<<< HEAD
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
=======
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        guard let poster = userInfo["poster"] as? String else { return }
        
        if poster != StorageManager.userInfo.userID {
            
            completionHandler([.alert, .badge, .sound])
        }
>>>>>>> 43e069365901cd5a6ccf8ef60bbe233fb6ac193e
    }
}
