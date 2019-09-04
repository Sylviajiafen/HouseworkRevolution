//
//  dailyMission.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/4.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

final class Mission: NSObject, Codable {
    
    let charger: String
    let content: String
    
    static let shareIdentifier: String = "missionDone"
    
    init(charger: String, content: String) {
        self.charger = charger
        self.content = content
        super.init()
    }
}

extension Mission: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        
        return [Mission.shareIdentifier]
    }
    
    // Prepare data for providing to destinationAPP
    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        switch typeIdentifier {
            
        case Mission.shareIdentifier:
            
            let data = try? JSONEncoder().encode(self)
            
            completionHandler(data, nil)
            
        default:
            fatalError()
        }
        
        return nil
    }
}

extension Mission: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        
        return [Mission.shareIdentifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Mission {
        
        switch typeIdentifier {
            
        case Mission.shareIdentifier:
            
            do {
                
                let mission = try JSONDecoder().decode(Mission.self, from: data)
                
                return mission
                
            } catch {
                
                throw error
            }
        default:
            fatalError()
        }
    }
}
