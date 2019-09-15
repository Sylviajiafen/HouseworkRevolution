//
//  FirebaseManager.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import Firebase

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
    private func addDailyMissionToMissionByDate(of family: String) {
        
        let houseworksQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.houseworks.rawValue)
        
        let missionByDateQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
        
        houseworksQuery.whereField(MissionData.weekday.rawValue, isEqualTo: DayManager.shared.weekday)
            .getDocuments { [weak self] (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 { // 沒有設定那個星期日期的家事
                        
                        print("沒有當天星期的家事")
                        // TODO: 顯示給使用者說請他快點去新增
                        
                    } else { // 有家事
                        
                        for index in 0..<querySnapshot.count {
                            
                            guard let title = querySnapshot.documents[index].data()[MissionData.title.rawValue]
                                as? String,
                                let tiredValue = querySnapshot.documents[index].data()[MissionData.tiredValue.rawValue]
                                    as? Int else { return }
                            
                            print("當天星期有\(querySnapshot.count)件家事: \(querySnapshot.documents)")
                            
                            missionByDateQuery.document(DayManager.shared.stringOfToday)
                                .collection(CollectionOfFamily.subCollectionMissions.rawValue)
                                .addDocument(data:
                                    [MissionData.title.rawValue: title,
                                     MissionData.tiredValue.rawValue: tiredValue,
                                     MissionData.status.rawValue: MissionStatus.undo.rawValue])
                            
                            print("新增了今天的 missionByDate")
                        }
                    }
                    
                } else if let err = error {
                    
                    print(err)
                }
        }
    }
    
    
    // 檢查 database 有沒有今天的資料，沒有的話新增
    func checkToday(family: String, completion: @escaping () -> ()){
        
        let today = DayManager.shared.stringOfToday
        
        let missionByDateQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
        
        missionByDateQuery.whereField("day", isEqualTo: today)
            .getDocuments { [weak self] (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.documents.count == 0 { // 表示今天還沒有人點開建立，新建一筆
                        
                        print("沒資料，建一筆")
                        
                        missionByDateQuery.document(today).setData(["day": today])
                        
                        self?.addDailyMissionToMissionByDate(of: family) // 創造每天的 “mission" collection，只能寫一次，不然會重複加
                        
                    } else { // 表示今天已有人建一筆，不新增
                        
                        print("有資料ㄌ")
                    }
                    
                } else if let error = error {
                    
                    print(error)
                }
                
                completion()
                print("建完了")
        }
    }
    
    // 分別讀取今天已完成 & 未完成的家事
    func getMissionToday(family: String, undoHandler: @escaping ([Mission]) -> Void, doneHandler: @escaping ([Mission]) -> Void ) {
        
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
            .getDocuments { [weak self] (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 {
                        
                        print("沒有未完成家事資料")
                    }
                    
                    for index in 0..<querySnapshot.count {
                        
                        guard let title = querySnapshot.documents[index].data()[MissionData.title.rawValue]
                            as? String,
                            let tiredValue = querySnapshot.documents[index].data()[MissionData.tiredValue.rawValue]
                                as? Int else { return }
                        
                        undoMissions.append(Mission(title: title, tiredValue: tiredValue))
                        
                        FirebaseManager.undoMission = undoMissions
                        
                        //                            undoHandler (FirebaseManager.undoMission)
                        
                    }
                    
                } else if let err = error {
                    
                    print("Error getting docs: \(err)")
                }
                
                undoHandler (FirebaseManager.undoMission)
        }
        
        // 拿 done 資料
        missionUndoQuery.whereField(MissionData.status.rawValue, isEqualTo: MissionStatus.done.rawValue)
            .getDocuments { (querySnapshot, error) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count == 0 {
                        
                        print("沒有已完成家事資料")
                    }
                    
                    for index in 0..<querySnapshot.count {
                        
                        guard let title = querySnapshot.documents[index].data()[MissionData.title.rawValue]
                            as? String,
                            let tiredValue = querySnapshot.documents[index].data()[MissionData.tiredValue.rawValue]
                                as? Int else { return }
                        
                        doneMissions.append(Mission(title: title, tiredValue: tiredValue))
                        
                        FirebaseManager.doneMission = doneMissions
                        
                        //                        doneHandler (FirebaseManager.doneMission)
                        
                    }
                    
                } else if let err = error {
                    
                    print("Error getting docs: \(err)")
                }
                
                doneHandler (FirebaseManager.doneMission)
        }
    }
    
    func getMissionListToday(family: String) {
        
        let today = DayManager.shared.stringOfToday
        
        FirebaseManager.undoMission.removeAll()
        FirebaseManager.doneMission.removeAll()
        
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
                        
                        FirebaseManager.undoMission.append(Mission(title: title, tiredValue: tiredValue))
                    }
                    
                } else if let err = error {
                    
                    print("Error getting docs: \(err)")
                }
                
                self.delegate?.getUndoListToday(self, didGetUndo: FirebaseManager.undoMission)
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
                        
                        FirebaseManager.doneMission.append(Mission(title: title, tiredValue: tiredValue))
                    }
                    
                } else if let err = error {
                    
                    print("Error getting docs: \(err)")
                }
                
                self.delegate?.getDoneListToday(self, didGetDone: FirebaseManager.doneMission)
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
                    
                    if querySnapshot.count == 0 {
                        
                        print("找不到符合條件並且需要更新的家事")
                    }
                    
                    for document in querySnapshot.documents {
                        
                        missionUndoQuery.document(document.documentID).updateData(
                        [MissionData.status.rawValue: MissionStatus.done.rawValue]) { (err) in
                            
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("\(missionUndoQuery.document(document.documentID)) successfully updated to \(MissionStatus.done.rawValue)")
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
                    
                    for index in 0..<querySnapshot.count {
                        
                        guard let title = querySnapshot.documents[index][MissionData.title.rawValue] as? String,
                            let tiredValue = querySnapshot.documents[index][MissionData.tiredValue.rawValue] as? Int else { return }
                        
                        FirebaseManager.allMission[day]?.append(Mission(title: title, tiredValue: tiredValue))
                        
                        //                    handler(FirebaseManager.allMission[day] ?? [])
                    }
                    
                } else if let err = err {
                    
                    print("Error getting documents: \(err)")
                }
                
                handler(FirebaseManager.allMission[day] ?? [])
        }
        
        
    }
    
// MARK: 更動已設定之家事
    
    // 更新 houseworks collection
    // 新增
    func addMissionToHouseworks(title: String, tiredValue: Int, weekday: String, family: String) { // weekday 記得填入英文的星期
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.houseworks.rawValue)
        
        let missionBydateQuery =  db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.missionByDate.rawValue)
            .document(DayManager.shared.stringOfToday)
            .collection(CollectionOfFamily.subCollectionMissions.rawValue)
        
        // 判斷在同天內有沒有設定過一樣的家事 title
        query.whereField(MissionData.title.rawValue, isEqualTo: title)
            .whereField(MissionData.weekday.rawValue, isEqualTo: weekday)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    if querySnapshot.count > 0 {
                        
                        for document in querySnapshot.documents {
                            
                            print("有在同一天設定過相同家事")
                            print("TODO: 通知使用者設定過了，會直接更新成這次設定的內容")
                            
                            query.document(document.documentID)
                                .setData([MissionData.tiredValue.rawValue: tiredValue], merge: true) { (err) in
                                    
                                    if let err = err {
                                        
                                        print("Error updating document: \(err)")
                                    } else {
                                        
                                        print("\(query.document(document.documentID))) successfully update)")
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
                        
                        print("未在同一天設定過相同家事")
                        
                        query.addDocument(data:
                            [MissionData.title.rawValue: title,
                             MissionData.tiredValue.rawValue: tiredValue,
                             MissionData.weekday.rawValue: weekday])
                        
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
                    
                    if querySnapshot.count == 0 {
                        
                        print("找不到符合條件的家事")
                    }
                    
                    for document in querySnapshot.documents {
                        
                        houseworksQuery.document(document.documentID).delete() { (err) in
                            
                            if let err = err {
                                
                                print("Error updating document: \(err)")
                            } else {
                                
                                print("\(houseworksQuery.document(document.documentID)) successfully removed)")
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
    // 新增
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
        
        print("同步新增至當日家事列表")
    }
    
    // 刪除
    private func deleteMissionFromMissionByDate(title: String, tiredValue: Int, family: String) { // weekday 記得填入英文的星期
        
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
                        
                        print("找不到符合條件的家事")
                    }
                    
                    for document in querySnapshot.documents {
                        
                        query.document(document.documentID).delete() { (err) in
                            
                            if let err = err {
                                
                                print("Error updating document: \(err)")
                            } else {
                                
                                print("同步從當日家事列表移除 \(query.document(document.documentID))")
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
