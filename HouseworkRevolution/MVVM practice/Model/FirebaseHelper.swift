//
//  FirebaseHelper.swift
//  HouseworkRevolution
//
//  Created by Sylvia Wu on 2019/12/5.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper: NSObject {
    
//    static let shared = FirebaseHelper()
    
//    private override init() {}
    
    private let db = Firestore.firestore()
    
    @objc public
    func getAllMissionsForOC(day: String) -> [OCMissionObject] {
        
        FirebaseManager.allMission[day]?.removeAll()
        
        var dailyMission = [OCMissionObject]()
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(StorageManager.userInfo.familyID)
            .collection(CollectionOfFamily.houseworks.rawValue)
        
        query.whereField(MissionData.weekday.rawValue, isEqualTo: day)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 {
                        
                        dailyMission = []
                        
                    } else {
                    
                        for index in 0..<querySnapshot.count {
                            
                            let mission = OCMissionObject()
                        
                            guard let title = querySnapshot.documents[index][MissionData.title.rawValue]
                                        as? String,
                                  let tiredValue = querySnapshot.documents[index][MissionData.tiredValue.rawValue]
                                        as? Int else { return }
                            
                            mission.title = title
                            
                            mission.tiredValue = Int32(tiredValue)
                            
                            dailyMission.append(mission)
                        }
                    }
                    
                } else if let err = err {
                    
                    print("Error getting all missions: \(err)")
                }
        }
        
        return dailyMission
    }
}

