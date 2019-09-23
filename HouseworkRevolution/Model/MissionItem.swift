//
//  dailyMission.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/4.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

final class MissionItem: NSObject, Codable {
    
    let tiredValue: Int
    let content: String
    
    static let shareIdentifier: String = "missionDone"
    
    init(value: Int, content: String) {
        self.tiredValue = value
        self.content = content
        super.init()
    }
}

extension MissionItem: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        
        return [MissionItem.shareIdentifier]
    }
    
    // Prepare data for providing to destinationAPP
    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        switch typeIdentifier {
            
        case MissionItem.shareIdentifier:
            
            let data = try? JSONEncoder().encode(self)
            
            completionHandler(data, nil)
            
        default:
            fatalError()
        }
        
        return nil
    }
}

extension MissionItem: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        
        return [MissionItem.shareIdentifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> MissionItem {
        
        switch typeIdentifier {
            
        case MissionItem.shareIdentifier:
            
            do {
                
                let mission = try JSONDecoder().decode(MissionItem.self, from: data)
                
                return mission
                
            } catch {
                
                throw error
            }
        default:
            fatalError()
        }
    }
}
