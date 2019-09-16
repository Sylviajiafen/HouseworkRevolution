//
//  FirebaseUserHelper.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import Firebase

typealias LoggedInResult = (LoginResult<String>) -> Void

class FirebaseUserHelper {
    
    static let shared = FirebaseUserHelper()
    
    private init() {}
    
    static var userID: String = ""
    
    static var familyID: String = ""
    
    private let db = Firestore.firestore()
    
    // MARK: 註冊功能
    
    func registAnId(_ user: FamilyMember, completion: @escaping () -> Void) {
        
        let ref = db.collection(DataCollection.houseUser.rawValue)
            .addDocument(data: [UserData.password.rawValue: user.password,
                                UserData.name.rawValue: user.name,
                                UserData.family.rawValue: user.family,
                                UserData.originFamily.rawValue: user.family,
                                UserData.wishes.rawValue: user.wishes])
            { (err) in
                
                if let err = err {
                    
                    print(err)
                } else {
                    
                    completion()
                }
            }
        
        FirebaseUserHelper.userID = ref.documentID
    }
    
    func registDoneWith(_ family: FamilyGroup, username: String, completion: @escaping () -> Void) {
        
        let familyRef = db.collection(DataCollection.houseGroup.rawValue)
            .addDocument(data:[FamilyGroupData.name.rawValue: family.name,
                               FamilyGroupData.houseworkLabels.rawValue: family.houseworkLabel])
        
        FirebaseUserHelper.familyID = familyRef.documentID
        
        db.collection(DataCollection.houseGroup.rawValue).document(familyRef.documentID)
            .collection(CollectionOfFamily.member.rawValue)
            .document(FirebaseUserHelper.userID).setData(["name": username])
        
        db.collection(DataCollection.houseGroup.rawValue).document(familyRef.documentID)
            .collection(CollectionOfFamily.houseworks.rawValue)
            .addDocument(data:
                [MissionData.title.rawValue: "加入翻轉家事(預設)",
                 MissionData.tiredValue.rawValue: 0,
                 MissionData.weekday.rawValue: DayManager.shared.weekday])
        
        //        db.collection(DataCollection.houseGroup.rawValue).document(ref.documentID)
        //            .collection(CollectionOfFamily.missionByDate.rawValue)
        //            .addDocument(data:
        //                ["day": "(date)"])
        
        db.collection(DataCollection.houseUser.rawValue).document(FirebaseUserHelper.userID).setData(
            [UserData.name.rawValue: username,
             UserData.family.rawValue: familyRef.documentID,
             UserData.originFamily.rawValue: familyRef.documentID], merge: true)
        
        completion()
    }
    
// MARK: 登入功能: 拿到 userID & familyID
    
    func loginWith(id: String, password: String, completion: LoggedInResult? = nil) {
        
        // 判斷有無此人
        let userRef = db.collection(DataCollection.houseUser.rawValue).document(id)
        
        userRef.getDocument { [weak self] (document, error) in
            
            if let document = document, document.exists {
                
                guard let correctPwd = document.data()?[UserData.password.rawValue] as? String,
                    let family = document.data()?[UserData.family.rawValue] as? String else { return }
                
                // TODO: correctPWD 拿下來是轉換過的 pwd , 所以要把他轉回來才能比對使用者輸入的 ; 或是先轉使用者輸入的再和 correctPWD 比對
                
                if password == correctPwd {
                    
                    FirebaseUserHelper.familyID = family
                    FirebaseUserHelper.userID = id
                    
                    print("登入成功, userID:\(String(describing: FirebaseUserHelper.userID)), familyID: \(String(describing: FirebaseUserHelper.familyID))")
                 
                    completion?(LoginResult.success("登入成功"))
                    
                } else {
    
                    completion?(LoginResult.failed(LoginError.uncorrectPassword.rawValue))
                }
                
            } else {
                
                completion?(LoginResult.failed(LoginError.userDidNotExist.rawValue))
            }
        }
    }
    
    // MARK: 讀取、新增、移除家事標籤
    
    func readLabelsOf(family: String, completion: @escaping ([String]) -> Void) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.getDocument { (document, err) in
            
            if let document = document {
                
                guard let labels = document[FamilyGroupData.houseworkLabels.rawValue]
                    as? [String] else { return }
                
                completion(labels)
                
                print("Labels: \(labels) read!!")
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
        }
    }
    
    func addLabelOf(content: String, family: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.updateData([
            FamilyGroupData.houseworkLabels.rawValue: FieldValue.arrayUnion([content])])
        
        print("successfully add label!")
    }
    
    func removeLabelOf(content: String, family: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.updateData([
            FamilyGroupData.houseworkLabels.rawValue: FieldValue.arrayRemove([content])])
        
        print("successfully remove label!")
    }
    
    // MARK: 讀取、新增、移除願望
    
    func readWishesOf(user: String, completion: @escaping ([String]) -> Void) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.getDocument { (document, err) in
            
            if let document = document {
                
                guard let wishes = document[UserData.wishes.rawValue]
                    as? [String] else { return }
                
                completion(wishes)
                
                print("Wishes: \(wishes) read!!")
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
        }
    }
    
    func addWishOf(content: String, user: String) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.updateData([
            UserData.wishes.rawValue: FieldValue.arrayUnion([content])])
        
        print("successfully add wish!")
    }
    
    func removeWishOf(content: String, user: String) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.updateData([
            UserData.wishes.rawValue: FieldValue.arrayRemove([content])])
        
        print("successfully remove wish: \(content)!")
    }
    
    // MARK: 顯示id、成員、家庭名稱
    
    func getHomeDatasOf(user: String, family: String,
                        userNameHandler: @escaping (String) -> Void,
                        familyNameHandler: @escaping (String) -> Void) {
        
        let userIDQuery = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        userIDQuery.getDocument { (document, err) in
            
            if let document = document {
                
                guard let userName = document[UserData.name.rawValue]
                    as? String else { return }
                
                userNameHandler(userName)
                
                print("成功讀取使用者稱呼：\(userName)")
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
        }
        
        let familyIDQuery = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        familyIDQuery.getDocument { (document, err) in
            
            if let document = document {
                
                guard let familyName = document[FamilyGroupData.name.rawValue]
                    as? String else { return }
                
                familyNameHandler(familyName)
                
                print("成功讀取家庭名稱：\(familyName)")
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
        }
    }
    
    func getFamilyMembers(family: String, handler: @escaping ([MemberData]) -> Void) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.member.rawValue)
        
        var membersArr = [MemberData]()
        
        query.getDocuments { (querySnapshot, err) in
            
            if let members = querySnapshot?.documents {
                
                for member in members {
                    
                    guard let name = member["name"] as? String else { return }
                    
                    membersArr.append(MemberData(id: member.documentID, name: name))
                    
                    //                    handler(membersArr)
                }
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
            
            handler(membersArr)
        }
    }
    
    // 可能不要這個 function, 因為 user 每打一個字就打一次 api...
    func searchForID(contains searchingString: String, result: @escaping ([MemberData]) -> Void) {
        
        var allUser = [MemberData]()
        
        var filtered = [MemberData]()
        
        let query = db.collection(DataCollection.houseUser.rawValue)
        
        query.getDocuments { (querySnapshot, err) in
            
            if let houseUsers = querySnapshot?.documents {
                
                for user in houseUsers {
                    
                    guard let userName = user[UserData.name.rawValue] as? String else { return }
                    
                    allUser.append(MemberData(id: user.documentID, name: userName))
                    
                    filtered = allUser.filter({ (data) -> Bool in
                        
                        return data.id.contains(searchingString)
                    })
                    
                    result(filtered)
                }
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
            
        }
    }
    
    func getAllUser(result: @escaping ([MemberData]) -> Void) {
        
        var allUser = [MemberData]()
        
        let query = db.collection(DataCollection.houseUser.rawValue)
        
        query.getDocuments { (querySnapshot, err) in
            
            if let houseUsers = querySnapshot?.documents {
                
                for user in houseUsers {
                    
                    guard let userName = user[UserData.name.rawValue] as? String else { return }
                    
                    allUser.append(MemberData(id: user.documentID, name: userName))
                    
                    //                    result(allUser)
                }
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
            
            result(allUser)
        }
    }
    
    func inviteMember(id: String, name: String, from familyID: String,
                      familyName:String, inviter whoseName: String) {
        
        print("inviting...")
        
        let familyQuery = db.collection(DataCollection.houseGroup.rawValue).document(familyID)
        
        let userQuery = db.collection(DataCollection.houseUser.rawValue).document(id)
        
        familyQuery.collection(CollectionOfFamily.member.rawValue).document(id).getDocument(completion: { (document, err) in
            
            if let doc = document {
                
                if doc.exists {
                    
                    print("已經是成員囉")
                    return
                    
                } else {
                    
                    // 邀請人家庭加入邀請中的成員
                    familyQuery.collection(CollectionOfFamily.requestedMember.rawValue)
                        .whereField(RequestedMember.userID.rawValue, isEqualTo: id)
                        .getDocuments { (querySnapshot, err) in
                            
                            if let querySnapshot = querySnapshot {
                                
                                if querySnapshot.count > 0 {
                                    
                                    print("TODO: 告訴 user 重複邀請了")
                                    
                                } else {
                                    
                                    familyQuery.collection(CollectionOfFamily.requestedMember.rawValue)
                                        .addDocument(data: [RequestedMember.username.rawValue : name,
                                                            RequestedMember.userID.rawValue: id])
                                }
                                
                            } else if let err = err {
                                
                                print("familyQueryErr: \(err)")
                            }
                    }
                    
                    // 被邀請的成員加入邀請我的家庭
                    userQuery.collection(UserData.subCollection.rawValue)
                        .whereField(RequestingFamily.familyID.rawValue, isEqualTo: familyID)
                        .getDocuments { (querySnapshot, err) in
                            
                            if let querySnapshot = querySnapshot {
                                
                                if querySnapshot.count > 0 {
                                    
                                    print("TODO: 告訴 user 重複被邀請了")
                                    
                                } else {
                                    
                                    userQuery.collection(UserData.subCollection.rawValue)
                                        .addDocument(data: [RequestingFamily.familyID.rawValue: familyID,
                                                            RequestingFamily.familyName.rawValue: familyName,
                                                            RequestingFamily.from.rawValue: whoseName])
                                }
                                
                            } else if let err = err {
                                
                                print("userQueryErr: \(err)")
                            }
                    }
                    
                }
                
            } else if let err = err {
                
                print(err)
            }
        })
    }
    
    func showInvites(family: String, user: String,
                     invitedMember: @escaping ([MemberData]) -> Void,
                     invitingFamily: @escaping ([InvitingFamily]) -> Void) {
        
        let familyQuery = db.collection(DataCollection.houseGroup.rawValue).document(family)
            .collection(CollectionOfFamily.requestedMember.rawValue)
        
        familyQuery.getDocuments { (querySnapshot, err) in
            
            var invitedUser = [MemberData]()
            
            if let querySnapshot = querySnapshot {
                
                for invited in querySnapshot.documents {
                    
                    guard let id = invited[RequestedMember.userID.rawValue] as? String,
                        let name = invited[RequestedMember.username.rawValue] as? String else { return }
                    
                    invitedUser.append(MemberData(id: id, name: name))
                    
                }
                
            } else if let err = err {
                
                print("get invited member err: \(err)")
            }
            
            invitedMember(invitedUser)
        }
        
        let userQuery = db.collection(DataCollection.houseUser.rawValue).document(user)
            .collection(UserData.subCollection.rawValue)
        
        userQuery.getDocuments { (querySnapshot, err) in
            
            var invitingGroup = [InvitingFamily]()
            
            if let querySnapshot = querySnapshot {
                
                for inviting in querySnapshot.documents {
                    
                    guard let familyId = inviting[RequestingFamily.familyID.rawValue] as? String,
                        let familyName = inviting[RequestingFamily.familyName.rawValue] as? String,
                        let inviter = inviting[RequestingFamily.from.rawValue] as? String else { return }
                    
                    invitingGroup.append(InvitingFamily(familyID: familyId,
                                                        familyName: familyName,
                                                        from: inviter))
                    
                }
                
            } else if let err = err {
                
                print("get inviting family err: \(err)")
            }
            
            invitingFamily(invitingGroup)
        }
    }
    
    // MARK: 接受、刪除邀請
    func acceptInvitation(from family: String, myID: String, myName: String) {
        
        // 新增自己至新家的 member
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family).collection(CollectionOfFamily.member.rawValue)
        
        query.document(myID).setData([UserData.name.rawValue: myName])
        
        // 更改自己的 family Field Value
        let userQuery = db.collection(DataCollection.houseUser.rawValue)
            .document(myID)
        
        userQuery.setData([UserData.family.rawValue: family], merge: true)
        
        // 刪除邀請
        self.rejectInvitation(from: family, myID: myID)
    }
    
    func rejectInvitation(from family: String, myID: String)  {
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family).collection(CollectionOfFamily.requestedMember.rawValue)
        
        query.whereField(RequestedMember.userID.rawValue, isEqualTo: myID)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    querySnapshot.documents.map({ (document) -> () in
                        
                        query.document(document.documentID).delete()
                    })
                    
                } else if let err = err {
                    
                    print("get err: \(err)")
                }
        }
        
        let memberQuery = db.collection(DataCollection.houseUser.rawValue)
            .document(myID).collection(UserData.subCollection.rawValue)
        
        memberQuery.whereField(RequestingFamily.familyID.rawValue, isEqualTo: family)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    querySnapshot.documents.map({ (document) -> () in
                        
                        memberQuery.document(document.documentID).delete()
                    })
                    
                } else if let err = err {
                    
                    print("get err: \(err)")
                }
        }
    }
    
    // MARK: 移除(退出)家庭
    func dropOutFamily(familyID: String, user: String, getOriginFamily: @escaping (String) -> Void) {
        
        let query = db.collection(DataCollection.houseUser.rawValue)
            .document(user)
        
        query.getDocument { (document, err) in
            
            if let doc = document {
                
                guard let originFamily = doc[UserData.originFamily.rawValue] as? String else { return }
                
                // 更新自己的 family Field
                query.setData([UserData.family.rawValue: originFamily], merge: true)
                
                getOriginFamily(originFamily)
                
            } else if let err = err {
                
                print("get user doc err: \(err)")
            }
        }
        
        // 把自己從舊家 member 更改掉
        let beDroppedFamilyQuery = db.collection(DataCollection.houseGroup.rawValue)
            .document(familyID).collection(CollectionOfFamily.member.rawValue)
        
        beDroppedFamilyQuery.document(user).delete { (err) in
            
            if let err = err {
                
                print("delete member err: \(err)")
            } else {
                
                print("Member deleted!")
            }
        }
    }
    
    func getCurrentFamily(user: String, completion: @escaping (String) -> ()) {
        
        let query = db.collection(DataCollection.houseUser.rawValue)
            .document(user)
        
        query.getDocument { (doc, err) in
            
            if let doc = doc {
                
                guard let familyID = doc[UserData.family.rawValue] as? String else { return }
                
                completion(familyID)
                
            } else if let err = err {
                
                print("get familyID err: \(err)")
            }
        }
    }
    
// MARK: 變更名稱
    
    func changeName(user: String, to newName: String) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.setData([UserData.name.rawValue: newName], merge: true)
    }
    
    func changFamilyName(family: String, to new: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.setData([FamilyGroupData.name.rawValue: new], merge: true)
    }
    
// MARK: 判斷是否為 originFamily
    
    func comparingFamily(user: String, originFamilyHandler: @escaping (String) -> ()) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.getDocument { (doc, err) in
            
            if let doc = doc {
                
                guard let origin = doc[UserData.originFamily.rawValue] as? String else { return }
                
                originFamilyHandler(origin)
                
            } else if let err = err {
                
                print("comparingFamily Err: \(err)")
            }
        }
    }
    
}
