//
//  StorageManager.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import CoreData

typealias UserInfoResult = (Result<[UserInfo]>) -> Void

class StorageManager {
    
    static let shared = StorageManager()
    
    static var userInfo = [UserInfo]()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "HouseworkRevolution")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error {
                
                fatalError("Unresolved error \(error)")
                
            } else {
                
                print("LocalStorage: \(storeDescription)")
            }
        })
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    func saveUserInfo(uid: String, familyRecognizer: String) {
        
        let user = UserInfo(context: viewContext)
        
        user.userID = uid
        
        user.familyID = familyRecognizer
        
        do {
            
            try viewContext.save()

        } catch {
            
            fatalError()
        }
    }
    
    func fetchUserInfo(completion: UserInfoResult? = nil) {
    
        let request = NSFetchRequest<UserInfo>(entityName: "UserInfo")
    
            do {
    
                let userInfo = try viewContext.fetch(request)
    
                StorageManager.userInfo = userInfo
    
                completion?(Result.success(userInfo))
                
                print("\(userInfo) fetched")
    
            } catch {
    
                completion?(Result.failure(error))
            }
    }
    
    func updateFamily(familyID: String) {
        
         let request = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        
        do {
            
            let userInfo = try viewContext.fetch(request)
            
            let tobeUpdatedInfo = userInfo[0] as NSManagedObject
            
            tobeUpdatedInfo.setValue(familyID, forKey: "familyID")
            
            do {
                
                try viewContext.save()
                
                fetchUserInfo()
                
            } catch {
                
                fatalError()
            }
            
        } catch {
            
            fatalError()
        }
        
    }
}

