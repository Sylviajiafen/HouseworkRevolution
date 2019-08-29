//
//  AppDelegate.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import CoreData

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
        }
        
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

}
