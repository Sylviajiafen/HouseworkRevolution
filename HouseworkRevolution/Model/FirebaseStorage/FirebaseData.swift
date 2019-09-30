//
//  Data.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

struct FamilyMember {
    
    let password: String
    
    let name: String
    
    let family: String
    
    var wishes: [String]
    
    init(password: String) {
        
        self.password = password
        self.name = "(稱呼)"
        self.family = "(groupID)"
        self.wishes = ["放假(預設)",
                       "跟朋友出門(預設)",
                       "看場電影(預設)",
                       "睡到自然醒(預設)",
                       "不做家事一天(預設)",
                       "喝下午茶(預設)"]
    }
}

struct FamilyGroup {
    
    let name: String
    
    let houseworkLabel: [String]
    
    init(name: String) {
        
        self.name = name
        
        houseworkLabel = []
    }
}

struct Mission {
    
    let title: String
    
    let tiredValue: Int
}

struct InvitingFamily {
    
    let familyID: String
    
    let familyName: String
    
    let from: String
}

struct MemberData {
    
    let id: String
    
    let name: String
}

// Enum

enum CollectionOfFamily: String {
    
    case houseworks
    
    case member
    
    case missionByDate
    
    case requestedMember
    
    case subCollectionMissions = "missions"
    
    case subDocDay = "day"
}

enum DataCollection: String {
    
    case houseGroup
    
    case houseUser
}

enum MissionData: String {
    
    case title
    
    case tiredValue
    
    case weekday
    
    case status
}

enum MissionStatus: String {
    
    case undo
    
    case done
}

enum UserData: String {
    
    case password
    
    case name
    
    case originFamily
    
    case family
    
    case wishes
    
    case fcmToken
    
    case subCollection = "requestingFamily"
}

enum FamilyGroupData: String {
    
    case name
    
    case houseworkLabels
}

enum RequestingFamily: String {
    
    case familyID
    
    case familyName
    
    case from
}

enum RequestedMember: String {
    
    case username
    
    case userID
}

enum LoginResult<T> {
    
    case success(T)
    
    case failed(LoginError)
}

enum RegistResult<T> {
    
    case success(T)
    
    case failed(Error)
}

enum SendInvitationResult<T> {
    
    case success(T)
    
    case failed(InvitationErr)
}

enum AddMissionResult<T> {
    
    case duplicatedAdd(T)
    
    case success(T)
    
    case failed(T)
}

enum LoginError: String {
    
    case userDidNotExist = "沒有註冊過唷"
    
    case uncorrectPassword = "密碼不正確"
    
    case unknownError = "未知錯誤，請聯絡開發人員"
}


enum InvitationErr: String {
    
    case duplicatedInvitation = "已邀請過囉"
    
    case memberAlreadyExist = "已是家人囉"
}

// Local Storage
struct UserLoggedIn {
    
    let userID: String
    
    let familyID: String
    
    init(info: UserInfo) {
        
        userID = info.userID ?? ""
        
        familyID = info.familyID ?? ""
    }
    
    init() {
        
        userID = ""
        
        familyID = ""
    }
}

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}
