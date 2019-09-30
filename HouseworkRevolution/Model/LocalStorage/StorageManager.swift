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
typealias ChangeFamily = () -> Void

class StorageManager {
    
    static let shared = StorageManager()

    private init() {}
    
    static var getUser = [UserInfo]()
    
    static var userInfo = UserLoggedIn()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "HouseworkRevolution")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error {
                
                fatalError("Unresolved error \(error)")
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
            
            fetchUserInfo()

        } catch {
            
            fatalError()
        }
    }
    
    func fetchUserInfo(completion: UserInfoResult? = nil) {
    
        let request = NSFetchRequest<UserInfo>(entityName: "UserInfo")
    
            do {
    
                let userInfo = try viewContext.fetch(request)
    
                StorageManager.getUser = userInfo
                
                StorageManager.userInfo = UserLoggedIn(info: userInfo[0])
    
                completion?(Result.success(userInfo))
    
            } catch {
    
                completion?(Result.failure(error))
            }
    }
    
    func updateFamily(familyID: String, completion: ChangeFamily? = nil) {
        
         let request = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        
        do {
            
            let userInfo = try viewContext.fetch(request)
            
            let tobeUpdatedInfo = userInfo[0] as NSManagedObject
            
            tobeUpdatedInfo.setValue(familyID, forKey: "familyID")
            
            do {
                
                try viewContext.save()
                
                fetchUserInfo()
                
                completion?()
                
            } catch {
                
                fatalError()
            }
            
        } catch {
            
            fatalError()
        }
        
    }
}
