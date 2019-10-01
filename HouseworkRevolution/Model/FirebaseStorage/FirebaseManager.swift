//
//  FirebaseManager.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import Firebase

typealias AddMissionMessege = (AddMissionResult<String>) -> Void

// swiftlint:disable type_body_length
// swiftlint:disable empty_parentheses_with_trailing_closure

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    private let db = Firestore.firestore()
    
    weak var delegate: FirebaseManagerDelegate?
    
    static var undoMission = [Mission]()
    
    static var doneMission = [Mission]()
    
    static var allMission = [WeekdayInEng.Monday.rawValue: [Mission](),
                             WeekdayInEng.Tuesday.rawValue: [Mission](),
                             WeekdayInEng.Wednesday.rawValue: [Mission](),
                             WeekdayInEng.Thursday.rawValue: [Mission](),
                             WeekdayInEng.Friday.rawValue: [Mission](),
                             WeekdayInEng.Saturday.rawValue: [Mission](),
                             WeekdayInEng.Sunday.rawValue: [Mission]()]
    
// MARK: 讀取今日家事
    
    // 新增當日 missions collection
    private func addDailyMissionToMissionByDate(of family: String, completion: @escaping () -> Void ) {
        
        let houseworksQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.houseworks.rawValue)
        
        let missionByDateQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
        
        houseworksQuery.whereField(MissionData.weekday.rawValue, isEqualTo: DayManager.shared.weekday)
            .getDocuments { (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 {
                
                        completion()

                    } else {
                        
                        for document in querySnapshot.documents {
                            
                            guard let title = document.data()[MissionData.title.rawValue]
                                        as? String,
                                  let tiredValue = document.data()[MissionData.tiredValue.rawValue]
                                        as? Int else { return }
                            
                            missionByDateQuery.document(DayManager.shared.stringOfToday)
                                .collection(CollectionOfFamily.subCollectionMissions.rawValue)
                                .addDocument(data:
                                    [MissionData.title.rawValue: title,
                                     MissionData.tiredValue.rawValue: tiredValue,
                                     MissionData.status.rawValue: MissionStatus.undo.rawValue],
                                completion: { (err) in
                                    
                                    if let err = err {
                                        
                                        print(err)
                                    } else {
                                        
                                        completion()
                                    }
                                })
                        }
                    }
                    
                } else if let err = error {
                    
                    print(err)
                }
        }
    }
    
    // 檢查 database 有沒有今天的資料，沒有的話新增
    func checkToday(family: String, completion: @escaping () -> Void) {
        
        let today = DayManager.shared.stringOfToday
        
        let missionByDateQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
        
        missionByDateQuery.whereField(CollectionOfFamily.subDocDay.rawValue, isEqualTo: today)
            .getDocuments { [weak self] (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.documents.count == 0 {
                    
                        missionByDateQuery.document(today).setData( [CollectionOfFamily.subDocDay.rawValue: today])
                        
                        self?.addDailyMissionToMissionByDate(of: family, completion: {
                            
                            completion()
                        })
                        
                    } else {
                        
                        completion()
                    }
                    
                } else if let error = error {
                    
                    print(error)
                }
        }
    }
    
    func getMissionListToday(family: String) {
        
        let today = DayManager.shared.stringOfToday
        
        var undoMissions = [Mission]()
        
        var doneMissions = [Mission]()
        
        let missionUndoQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
            .document(today)
            .collection(CollectionOfFamily.subCollectionMissions.rawValue)
        
        // 拿 undo 資料
        missionUndoQuery.whereField(MissionData.status.rawValue, isEqualTo: MissionStatus.undo.rawValue)
            .getDocuments { [unowned self] (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    for index in 0..<querySnapshot.count {
                        
                        guard let title = querySnapshot.documents[index].data()[MissionData.title.rawValue]
                                    as? String,
                              let tiredValue = querySnapshot.documents[index].data()[MissionData.tiredValue.rawValue]
                                    as? Int else { return }
                        
                        undoMissions.append(Mission(title: title, tiredValue: tiredValue))
                    }
                    
                    FirebaseManager.undoMission = undoMissions
                    
                    self.delegate?.getUndoListToday(self, didGetUndo: FirebaseManager.undoMission)
                    
                } else if let err = error {
                    
                    print("Error getting docs: \(err)")
                    
                    ProgressHUD.dismiss()
                }
        }
        
        // 拿 done 資料
        missionUndoQuery.whereField(MissionData.status.rawValue, isEqualTo: MissionStatus.done.rawValue)
            .getDocuments { [unowned self] (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    for index in 0..<querySnapshot.count {
                        
                        guard let title = querySnapshot.documents[index].data()[MissionData.title.rawValue]
                                    as? String,
                              let tiredValue = querySnapshot.documents[index].data()[MissionData.tiredValue.rawValue]
                                    as? Int else { return }
                        
                        doneMissions.append(Mission(title: title, tiredValue: tiredValue))
                    }
                    
                    FirebaseManager.doneMission = doneMissions
                    
                    self.delegate?.getDoneListToday(self, didGetDone: FirebaseManager.doneMission)
                    
                    ProgressHUD.dismiss()
                    
                } else if let err = error {
                    
                    print("Error getting docs: \(err)")
                    
                    ProgressHUD.dismiss()
                }
        }
    }
    
    // 完成家事，更新成 done
    func updateMissionStatus(title: String, tiredValue: Int, family: String) {
        
        let today = DayManager.shared.stringOfToday
        
        let missionUndoQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
            .document(today)
            .collection(CollectionOfFamily.subCollectionMissions.rawValue)
        
        missionUndoQuery.whereField(MissionData.title.rawValue, isEqualTo: title)
            .whereField(MissionData.tiredValue.rawValue, isEqualTo: tiredValue)
            .whereField(MissionData.status.rawValue, isEqualTo: MissionStatus.undo.rawValue)
            .getDocuments { (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    for document in querySnapshot.documents {
                        
                        missionUndoQuery.document(document.documentID).updateData(
                        [MissionData.status.rawValue: MissionStatus.done.rawValue]) { (err) in
                            
                            if let err = err {
                                
                                print("Error updating mission status: \(err)")
                            }
                        }
                    }
                    
                } else if let err = error {
                    
                    print("Error getting documents: \(err)")
                }
        }
    }
    
// MARK: 讀取全部家事
    
    func getAllMissions(family: String, day: String, handler: @escaping ([Mission]) -> Void) {
        
        FirebaseManager.allMission[day]?.removeAll()
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.houseworks.rawValue)
        
        query.whereField(MissionData.weekday.rawValue, isEqualTo: day)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 {
                        
                        FirebaseManager.allMission[day] = []
                        
                    } else {
                    
                        for index in 0..<querySnapshot.count {
                        
                            guard let title = querySnapshot.documents[index][MissionData.title.rawValue]
                                        as? String,
                                  let tiredValue = querySnapshot.documents[index][MissionData.tiredValue.rawValue]
                                        as? Int else { return }
                        
                            FirebaseManager.allMission[day]?.append(Mission(title: title, tiredValue: tiredValue))
                        }
                    }
                    
                    handler(FirebaseManager.allMission[day] ?? [])
                    
                } else if let err = err {
                    
                    print("Error getting all missions: \(err)")
                }
        }
    }
    
// MARK: 更動已設定之家事
    
    // 更新 houseworks collection
    // 新增
    func addMissionToHouseworks(title: String, tiredValue: Int, weekday: String,
                                family: String, message: AddMissionMessege? = nil) {
    
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.houseworks.rawValue)
        
        let missionBydateQuery =  db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
            .document(DayManager.shared.stringOfToday)
            .collection(CollectionOfFamily.subCollectionMissions.rawValue)
        
        query.whereField(MissionData.title.rawValue, isEqualTo: title)
            .whereField(MissionData.weekday.rawValue, isEqualTo: weekday)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count > 0 {
                        
                        for document in querySnapshot.documents {
                            
                            query.document(document.documentID)
                                .setData([MissionData.tiredValue.rawValue: tiredValue],
                                         merge: true) { (err) in
                                    
                                    if let err = err {
                                        
                                        print("Error updating mission: \(err)")

                                    } else {
                                        
                                        message?(AddMissionResult
                                            .duplicatedAdd("同日設定過一樣的家事，更新疲勞值為此次設定值"))
                                    }
                            }
                            
                            if weekday == DayManager.shared.weekday {
                                
                                missionBydateQuery.whereField(MissionData.title.rawValue, isEqualTo: title)
                                    .getDocuments(completion: { (querySnapshot, err) in
                                        
                                        if let querySnapshot = querySnapshot {
                                            
                                            for document in querySnapshot.documents {
                                                
                                                missionBydateQuery.document(document.documentID)
                                                    .setData([MissionData.tiredValue.rawValue: tiredValue], merge: true)
                                            }
                                        }
                                    })
                            }
                        }
                        
                    } else {
                     
                        query.addDocument(data:
                            [MissionData.title.rawValue: title,
                             MissionData.tiredValue.rawValue: tiredValue,
                             MissionData.weekday.rawValue: weekday],
                            completion: { (err) in
                                
                                if let err = err {
                                    
                                    print("Error adding mission: \(err)")
                                
                                } else {
                                    
                                    message?(AddMissionResult
                                        .success("新增成功"))
                                }
                        })
                        
                        if weekday == DayManager.shared.weekday {
                            
                            self.addMissionToMissionByDate(title: title, tiredValue: tiredValue, family: family)
                        }
                    }
                    
                } else if let err = err {
                    
                    print("Error getting documents: \(err)")
                }
        }
    }
    
    // 刪除
    func deleteMissionFromHouseworks(title: String, tiredValue: Int, weekday: String, family: String) {
        
        let houseworksQuery = db.collection(DataCollection.houseGroup.rawValue).document(family)
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
            
            self.deleteMissionFromMissionByDate(title: title, tiredValue: tiredValue, family: family)
        }
    }
    
    // 更新 missionBydate collection
    // 新增至今日列表
    private func addMissionToMissionByDate(title: String, tiredValue: Int, family: String) { // weekday 記得填入英文的星期
        
        let query =  db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
            .document(DayManager.shared.stringOfToday)
            .collection(CollectionOfFamily.subCollectionMissions.rawValue)
        
        query.addDocument(data:
            [MissionData.title.rawValue: title,
             MissionData.tiredValue.rawValue: tiredValue,
             MissionData.status.rawValue: MissionStatus.undo.rawValue])
    }
    
    // 從今日列表中刪除
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

protocol FirebaseManagerDelegate: AnyObject {
    
    func getUndoListToday(_ manager: FirebaseManager, didGetUndo: [Mission])
    
    func getDoneListToday(_ manager: FirebaseManager, didGetDone: [Mission])
    
}
