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
        
        //
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//
//          UNUserNotificationCenter.current().requestAuthorization(
//
//            options: authOptions,
//            completionHandler: {_, _ in })
//
//        } else {
//
//          let settings: UIUserNotificationSettings =
//          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//
//        }
//
//        application.registerForRemoteNotifications()
        //
        
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
    
    func showAuthzRequest(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
          UNUserNotificationCenter.current().requestAuthorization(
            
            options: authOptions,
            completionHandler: {_, _ in })
            
        } else {
            
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
            
        }

        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("========= remoteMessage App data ========")
        print(remoteMessage.appData)
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
