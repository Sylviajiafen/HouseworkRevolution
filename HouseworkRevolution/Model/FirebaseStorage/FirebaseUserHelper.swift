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

typealias RegisterResult = (RegistResult<String?>) -> Void

typealias AddMemberResult = (SendInvitationResult<String>) -> Void

// swiftlint:disable type_body_length
// swiftlint:disable function_parameter_count

class FirebaseUserHelper {
    
    static let shared = FirebaseUserHelper()
    
    private init() {}
    
    static var userID: String = "NOTSETYET"
    
    static var familyID: String = "NOTSETYET"
    
    static var currentListenerRegistration: ListenerRegistration?
    
    static var currentMemberListener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    
    // MARK: 註冊功能
    
    func registerUserWithEncrypt(_ user: FamilyMember, completion: @escaping RegisterResult) {
        
        var userPwdEncrypted = ""
        
        do {
            
            userPwdEncrypted = try RNCryptorManager.shared
                .encryptMessage(message: user.password,
                                encryptionKey: RNCryptorManager.encryptionKey)

        } catch {
            
            completion(.failed(error))
        }
        
        let ref = db.collection(DataCollection.houseUser.rawValue)
            .addDocument(data: [UserData.password.rawValue: userPwdEncrypted,
                                UserData.name.rawValue: user.name,
                                UserData.family.rawValue: user.family,
                                UserData.originFamily.rawValue: user.family,
                                UserData.wishes.rawValue: user.wishes],
                         completion: { (err) in
                            
                            if let err = err {
                                                                                            
                                completion(.failed(err))
                                                                                            
                            } else {
                                                                                            
                                completion(.success(nil))
                            }
                })
        
        FirebaseUserHelper.userID = ref.documentID
    }
    
    func registerDoneWith(_ family: FamilyGroup, username: String, completion: @escaping RegisterResult) {
        
       var familyRef: DocumentReference?
        
       familyRef = db.collection(DataCollection.houseGroup.rawValue)
            .addDocument(data: [FamilyGroupData.name.rawValue: family.name,
                                FamilyGroupData.houseworkLabels.rawValue: family.houseworkLabel],
                         completion: { [weak self] (err) in
                            
                            if let err = err {
                                
                                completion(.failed(err))
                                
                            } else {
                                
                                guard let familyID = familyRef?.documentID else { return }
                                
                                FirebaseUserHelper.familyID = familyID
                                
                                self?.db.collection(DataCollection.houseGroup.rawValue).document(familyID)
                                    .collection(CollectionOfFamily.member.rawValue)
                                    .document(FirebaseUserHelper.userID)
                                    .setData([UserData.name.rawValue: username])
                                
                                self?.db.collection(DataCollection.houseGroup.rawValue).document(familyID)
                                    .collection(CollectionOfFamily.houseworks.rawValue)
                                    .addDocument(data:
                                        [MissionData.title.rawValue: "加入翻轉家事(預設)",
                                         MissionData.tiredValue.rawValue: 0,
                                         MissionData.weekday.rawValue: DayManager.shared.weekday])
                                
                                self?.db.collection(DataCollection.houseUser.rawValue)
                                    .document(FirebaseUserHelper.userID).setData(
                                        [UserData.name.rawValue: username,
                                         UserData.family.rawValue: familyID,
                                         UserData.originFamily.rawValue: familyID], merge: true)
                                
                                completion(.success("註冊完成"))
                            }
            })
    }

    // MARK: 登入功能: 拿到 userID & familyID（有 Decrypt）
        
    func loginWithDecrypt(id: String, password: String, completion: LoggedInResult? = nil) {
       
        let userRef = db.collection(DataCollection.houseUser.rawValue).document(id)
        
        let userParentRef = db.collection(DataCollection.houseUser.rawValue)
            
        var currentExistingIDs = [String]()
            
        userParentRef.getDocuments { (querySnapshot, err) in
                
            if let querySnapshot = querySnapshot {
                    
                for doc in querySnapshot.documents {
                        
                    currentExistingIDs.append(doc.documentID)
                }
                    
                if currentExistingIDs.contains(id) {
                        
                    userRef.getDocument { (document, error) in
                                
                        if let document = document {
                                    
                            guard let correctPwdEncryted = document.data()?[UserData.password.rawValue] as? String,
                                let family = document.data()?[UserData.family.rawValue] as? String else { return }
                                
                            let correctPwd = try? RNCryptorManager.shared
                                                    .decryptMessage(encryptedMessage: correctPwdEncryted,
                                                                    encryptionKey: RNCryptorManager.encryptionKey)
                                
                            guard let correctPassword = correctPwd else {
                                
                                completion?(.failed(.unknownError))
                                
                                return
                            }
                                
                            if correctPassword == password {
                                    
                                FirebaseUserHelper.familyID = family
                                
                                FirebaseUserHelper.userID = id
                                     
                                completion?(LoginResult.success("登入成功"))
                                    
                            } else {
                                    
                                completion?(LoginResult.failed(.uncorrectPassword))
                            }
                                        
                        } else if let err = error {
                                
                            print("login get userInfo err: \(err)")
                        }
                    }
                    
                } else {
                        
                    completion?(LoginResult.failed(.userDidNotExist))
                }
                
            } else if let err = err {
                    
                print("login get user err: \(err)")
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
                
            } else if let err = err {
                
                print("read label failure: \(err)")
            }
        }
    }
    
    func addLabelOf(content: String, family: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.updateData([
            FamilyGroupData.houseworkLabels.rawValue: FieldValue.arrayUnion([content])])
    }
    
    func removeLabelOf(content: String, family: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.updateData([
            FamilyGroupData.houseworkLabels.rawValue: FieldValue.arrayRemove([content])])
    }
    
    // MARK: 讀取、新增、移除願望
    
    func readWishesOf(user: String, completion: @escaping ([String]) -> Void) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.getDocument { (document, err) in
            
            if let document = document {
                
                guard let wishes = document[UserData.wishes.rawValue]
                    as? [String] else { return }
                
                completion(wishes)
              
            } else if let err = err {
                
                print("read wishes failure: \(err)")
                
                ProgressHUD.dismiss()
            }
        }
    }
    
    func addWishOf(content: String, user: String) {
        
        ProgressHUD.show()
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.updateData([UserData.wishes.rawValue: FieldValue.arrayUnion([content])]) { (err) in
            
            if let err = err {
                
                print("updateWish err: \(err)")
                
            } else {
                
                ProgressHUD.showＷith(text: "許願成功！")
            }
        }
    }
    
    func removeWishOf(content: String, user: String) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.updateData([
            UserData.wishes.rawValue: FieldValue.arrayRemove([content])])
    }
    
    func removeAllWishes(user: String) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.setData([UserData.wishes.rawValue: []], merge: true)
    }
    
    // MARK: 顯示id、成員、家庭名稱
    
    func getHomeDatasOf(user: String, family: String,
                        userNameHandler: @escaping (String) -> Void,
                        familyNameHandler: @escaping (String) -> Void) {
        
        ProgressHUD.show()
        
        let userIDQuery = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        userIDQuery.getDocument { (document, err) in
            
            if let document = document {
                
                guard let userName = document[UserData.name.rawValue]
                    as? String else { return }
                
                userNameHandler(userName)
               
            } else if let err = err {
                
                print("get home data failure: \(err)")
                
                ProgressHUD.dismiss()
            }
        }
        
        let familyIDQuery = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        familyIDQuery.getDocument { (document, err) in
            
            if let document = document {
                
                guard let familyName = document[FamilyGroupData.name.rawValue]
                    as? String else { return }
                
                familyNameHandler(familyName)
                
            } else if let err = err {
                
               print("get home data failure: \(err)")
            }
        }
    }
    
    func getFamilyMembers(family: String, handler: @escaping ([MemberData]) -> Void) {
        
        ProgressHUD.show()
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family)
            .collection(CollectionOfFamily.member.rawValue)
        
        // addSnapshot
        FirebaseUserHelper.currentMemberListener = 
        query.addSnapshotListener { (querySnapshot, err) in
            
            if let members = querySnapshot?.documents {
                
                var membersArr = [MemberData]()
                
                for member in members {
                    
                    guard let name = member["name"] as? String else { return }
                    
                    membersArr.append(MemberData(id: member.documentID, name: name))
                }
                
                handler(membersArr)
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
                
                ProgressHUD.dismiss()
            }
        }
    }
    
    func getAllUser(result: @escaping ([MemberData]) -> Void) {
        
        let query = db.collection(DataCollection.houseUser.rawValue)
        
        // addSnapshot
        query.addSnapshotListener { (querySnapshot, err) in
            
            if let houseUsers = querySnapshot?.documents {
                
                var allUser = [MemberData]()
                
                for user in houseUsers {
                    
                    guard let userName = user[UserData.name.rawValue] as? String else { return }
                    
                    allUser.append(MemberData(id: user.documentID, name: userName))
                }
                
                result(allUser)
                
            } else if let err = err {
                
                print("get doc failure: \(err)")
            }
        }
    }
    
// MARK: 邀請成員
    func inviteMember(id: String, name: String, from familyID: String,
                      familyName: String, inviter whoseName: String,
                      invitorCompletion: @escaping AddMemberResult) {
      
        let familyQuery = db.collection(DataCollection.houseGroup.rawValue).document(familyID)
        
        let userQuery = db.collection(DataCollection.houseUser.rawValue).document(id)
        
        familyQuery.collection(CollectionOfFamily.member.rawValue).document(id)
            .getDocument(completion: { (document, err) in
            
            if let doc = document {
                
                if doc.exists {
                    
                    invitorCompletion(.failed(.memberAlreadyExist))
                    
                } else {
                    
                    // 邀請人家庭加入邀請中的成員
                    familyQuery.collection(CollectionOfFamily.requestedMember.rawValue)
                        .whereField(RequestedMember.userID.rawValue, isEqualTo: id)
                        .getDocuments { (querySnapshot, err) in
                            
                            if let querySnapshot = querySnapshot {
                                
                                if querySnapshot.count > 0 {
                                    
                                    invitorCompletion(.failed(.duplicatedInvitation))
                                    
                                } else {
                                    
                                familyQuery.collection(CollectionOfFamily.requestedMember.rawValue)
                                    .addDocument(data: [RequestedMember.username.rawValue: name,
                                                        RequestedMember.userID.rawValue: id])
                                    
                                    invitorCompletion(.success("邀請成功！"))
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
                                    
                                    return
                                    
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
        
        ProgressHUD.show()
        
        let familyQuery = db.collection(DataCollection.houseGroup.rawValue).document(family)
            .collection(CollectionOfFamily.requestedMember.rawValue)
    
        // addSnapshot
        FirebaseUserHelper.currentListenerRegistration =
        familyQuery.addSnapshotListener { (querySnapshot, err) in
                        
            var invitedUser = [MemberData]()
                        
            if let querySnapshot = querySnapshot {
                            
                for invited in querySnapshot.documents {
                                
                    guard let id = invited[RequestedMember.userID.rawValue] as? String,
                            let name = invited[RequestedMember.username.rawValue] as? String else { return }
                                
                    invitedUser.append(MemberData(id: id, name: name))
                }
                            
                invitedMember(invitedUser)
    
            } else if let err = err {
                
                ProgressHUD.dismiss()
                
                print("check query err: \(err)")
            }
        }
        
        let userQuery = db.collection(DataCollection.houseUser.rawValue).document(user)
            .collection(UserData.subCollection.rawValue)
        
        // addSnapshot
        userQuery.addSnapshotListener { (querySnapshot, err) in
            
            if let querySnapshot = querySnapshot {
                
                var invitingGroup = [InvitingFamily]()
                
                for inviting in querySnapshot.documents {
                    
                    guard let familyId = inviting[RequestingFamily.familyID.rawValue] as? String,
                        let familyName = inviting[RequestingFamily.familyName.rawValue] as? String,
                        let inviter = inviting[RequestingFamily.from.rawValue] as? String else { return }
                    
                    invitingGroup.append(InvitingFamily(familyID: familyId,
                                                        familyName: familyName,
                                                        from: inviter))
                }
                
                invitingFamily(invitingGroup)
                
            } else if let err = err {
                
                ProgressHUD.dismiss()
                
                print("get inviting family err: \(err)")
            }
        }
    }
    
    // MARK: 接受、刪除邀請
    func acceptInvitation(from family: String, myID: String, myName: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family).collection(CollectionOfFamily.member.rawValue)
        
        query.document(myID).setData([UserData.name.rawValue: myName])
        
        let userQuery = db.collection(DataCollection.houseUser.rawValue)
            .document(myID)
        
        userQuery.setData([UserData.family.rawValue: family], merge: true)
        
        self.rejectInvitation(from: family, myID: myID)
    }
    
    func rejectInvitation(from family: String, myID: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue)
            .document(family).collection(CollectionOfFamily.requestedMember.rawValue)
        
        query.whereField(RequestedMember.userID.rawValue, isEqualTo: myID)
            .getDocuments { (querySnapshot, err) in
                
                if let querySnapshot = querySnapshot {
                    
                    querySnapshot.documents.map({ (document) -> Void in
                        
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
                    
                    querySnapshot.documents.map({ (document) -> Void in
                        
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
            }
        }
    }
    
    func getCurrentFamily(user: String, completion: @escaping (String) -> Void) {
        
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
    
    func changeName(user: String, to newName: String, currentFamily: String) {
        
        let query = db.collection(DataCollection.houseUser.rawValue).document(user)
        
        query.setData([UserData.name.rawValue: newName], merge: true)
        
        query.getDocument { [weak self] (querySnapshot, err) in
            
            if let snapshot = querySnapshot {
                
                guard let originFamilyID = snapshot[UserData.originFamily.rawValue]
                    as? String else { return }
                
                self?.db.collection(DataCollection.houseGroup.rawValue).document(originFamilyID)
                .collection(CollectionOfFamily.member.rawValue).document(user)
                .setData([UserData.name.rawValue: newName], merge: true)
                
            } else if let err = err {
               
                print("set name err: \(err)")
            }
        }
        
        let familyQuery = db.collection(DataCollection.houseGroup.rawValue).document(currentFamily)
                                .collection(CollectionOfFamily.member.rawValue).document(user)
        
        familyQuery.setData([UserData.name.rawValue: newName], merge: true)
    }
    
    func changFamilyName(family: String, to new: String) {
        
        let query = db.collection(DataCollection.houseGroup.rawValue).document(family)
        
        query.setData([FamilyGroupData.name.rawValue: new], merge: true)
    }
    
// MARK: 判斷是否為 originFamily
    
    func comparingFamily(user: String, originFamilyHandler: @escaping (String) -> Void) {
        
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
