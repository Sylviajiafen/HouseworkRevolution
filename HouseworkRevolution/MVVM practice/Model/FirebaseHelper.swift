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
    
    @objc public
    func deleteMission(title: String,
                       tiredValue: Int,
                       weekday: String) {
        
        let houseworksQuery = db.collection(DataCollection.houseGroup.rawValue)
                                .document(StorageManager.userInfo.familyID)
                                .collection(CollectionOfFamily.houseworks.rawValue)
        
        houseworksQuery.whereField(MissionData.title.rawValue, isEqualTo: title)
            .whereField(MissionData.tiredValue.rawValue, isEqualTo: tiredValue)
            .whereField(MissionData.weekday.rawValue, isEqualTo: weekday)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    for document in querySnapshot.documents {
                        
                        houseworksQuery.document(document.documentID).delete() { (err) in
                            
                            if let err = err {
                                
                                print("Error deleting mission: \(err)")
                            }
                        }
                    }
                    
                } else if let err = err {
                    
                    print("Error getting documents: \(err)")
                }
        }
        
        if weekday == DayManager.shared.weekday {
            
            self.deleteMissionFromMissionByDate(title: title,
                                                tiredValue: tiredValue,
                                                family: StorageManager.userInfo.familyID)
        }
    }
    
    @objc
    private func deleteMissionFromMissionByDate(title: String, tiredValue: Int, family: String) {
        
        let query =  db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
            .document(DayManager.shared.stringOfToday)
            .collection(CollectionOfFamily.subCollectionMissions.rawValue)
        
        query.whereField(MissionData.title.rawValue, isEqualTo: title)
            .whereField(MissionData.tiredValue.rawValue, isEqualTo: tiredValue)
            .getDocuments { (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 {
                        
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        
                        query.document(document.documentID).delete() { (err) in
                            
                            if let err = err {
                                
                                print("Error updating document: \(err)")
                            }
                        }
                    }
                    
                } else if let err = error {
                    
                    print("Error getting documents: \(err)")
                }
        }
    }
}
